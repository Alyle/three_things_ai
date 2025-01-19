import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:idb_shim/idb_browser.dart' if (dart.library.io) 'package:idb_shim/idb_io.dart';
import '../models/goal.dart';
import 'log_service.dart';
import 'package:flutter/foundation.dart';
import '../core/config/environment_config.dart';
import 'package:flutter/services.dart';

class StorageService {
  static const String _localStorageKey = 'goals';
  static const String _dbName = 'app_storage';
  static const String _goalsStore = 'goals';
  static const String _userStore = 'user';
  static const String _logsStore = 'logs';
  
  late final SharedPreferences _prefs;
  late final String documentsPath;
  late final LogService _logService;
  
  // IndexedDB 相关
  late final IdbFactory _idbFactory;
  Database? _db;

  // 添加一个公共方法来访问 SharedPreferences
  SharedPreferences get prefs => _prefs;

  Future<void> init() async {
    try {
      // 初始化 SharedPreferences
      _prefs = await SharedPreferences.getInstance();
      
      // 获取文档目录
      if (EnvironmentConfig.isWeb) {
        documentsPath = '/';
        _idbFactory = getIdbFactory()!;
        await _initWebDb();
      } else {
        final docDir = await getApplicationDocumentsDirectory();
        documentsPath = docDir.path;
      }

      // 初始化日志服务
      _logService = LogService(_db);
      await _logService.init(documentsPath);
      
      await _logService.info('存储服务初始化成功');

      // Web环境下检查和加载数据
      if (EnvironmentConfig.isWeb) {
        // 检查IndexedDB中是否存在数据
        final hasData = await _checkIndexedDBData();
        if (!hasData) {
          // 如果没有数据，则初始化默认数据
          await _initializeDefaultData();
        } else {
          // 如果有数据，从IndexedDB加载数据
          await _loadDataFromIndexedDB();
        }
      }
    } catch (e) {
      debugPrint('初始化存储服务失败: $e');
    }
  }

  /// 初始化Web数据库
  Future<void> _initWebDb() async {
    _db = await _idbFactory.open(_dbName,
      version: 1,
      onUpgradeNeeded: (VersionChangeEvent event) {
        final db = event.database;
        // 创建所有需要的 stores
        db.createObjectStore(_goalsStore, autoIncrement: true);
        db.createObjectStore(_userStore, autoIncrement: true);
        db.createObjectStore(_logsStore, autoIncrement: true);
      }
    );
  }

  /// 获取日志服务实例
  LogService get logService => _logService;

  Future<List<Goal>> loadGoals() async {
    try {
      if (EnvironmentConfig.isWeb) {
        return await _loadGoalsFromIndexedDB();
      } else {
        return await _loadGoalsFromPrefs();
      }
    } catch (e) {
      debugPrint('加载目标时出错: $e');
      return [];
    }
  }

  Future<void> saveGoals(List<Goal> goals) async {
    try {
      if (EnvironmentConfig.isWeb) {
        await _saveGoalsToIndexedDB(goals);
      } else {
        await _saveGoalsToPrefs(goals);
      }
    } catch (e) {
      debugPrint('保存目标时出错: $e');
    }
  }

  Future<List<Goal>> _loadGoalsFromIndexedDB() async {
    if (_db == null) return [];
    
    final txn = _db!.transaction(_goalsStore, 'readonly');
    final store = txn.objectStore(_goalsStore);
    final records = await store.getAll();
    await txn.completed;
    
    return records.map((record) => 
      Goal.fromJson(jsonDecode((record as Map<String, dynamic>)['data'] as String))
    ).toList();
  }

  Future<void> _saveGoalsToIndexedDB(List<Goal> goals) async {
    if (_db == null) return;
    
    try {
      final txn = _db!.transaction(_goalsStore, 'readwrite');
      final store = txn.objectStore(_goalsStore);
      
      await store.clear();
      for (var goal in goals) {
        await store.add({
          'data': jsonEncode(goal.toJson()),
          'timestamp': DateTime.now().toIso8601String(),
        });
      }
      await txn.completed;
      debugPrint('目标数据成功保存到 IndexedDB');
    } catch (e) {
      debugPrint('保存目标到 IndexedDB 失败: $e');
    }
  }

  Future<List<Goal>> _loadGoalsFromPrefs() async {
    final goalsJson = _prefs.getString(_localStorageKey);
    if (goalsJson != null) {
      final List<dynamic> decoded = jsonDecode(goalsJson);
      return decoded.map((item) => Goal.fromJson(item)).toList();
    }
    return [];
  }

  Future<void> _saveGoalsToPrefs(List<Goal> goals) async {
    final goalsJson = jsonEncode(goals.map((goal) => goal.toJson()).toList());
    await _prefs.setString(_localStorageKey, goalsJson);
  }

  /// 保存用户数据
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    if (!EnvironmentConfig.isWeb || _db == null) return;
    
    try {
      final txn = _db!.transaction(_userStore, 'readwrite');
      final store = txn.objectStore(_userStore);
      
      await store.clear();
      await store.add({
        'data': jsonEncode(userData),
        'timestamp': DateTime.now().toIso8601String(),
      });
      await txn.completed;
      debugPrint('用户数据成功保存到 IndexedDB');
    } catch (e) {
      debugPrint('保存用户数据到 IndexedDB 失败: $e');
    }
  }

  /// 加载用户数据
  Future<Map<String, dynamic>?> loadUserData() async {
    if (!EnvironmentConfig.isWeb || _db == null) return null;
    
    final txn = _db!.transaction(_userStore, 'readonly');
    final store = txn.objectStore(_userStore);
    final records = await store.getAll();
    await txn.completed;
    
    if (records.isEmpty) return null;
    
    final record = records.last as Map<String, dynamic>;
    return jsonDecode(record['data'] as String);
  }

  /// 初始化默认数据
  Future<void> _initializeDefaultData() async {
    if (_db == null) return;

    try {
      // 检查是否已经有数据
      final txn = _db!.transaction(_goalsStore, 'readonly');
      final store = txn.objectStore(_goalsStore);
      final existingGoals = await store.getAll();
      await txn.completed;

      // 如果没有数据，则导入默认数据
      if (existingGoals.isEmpty) {
        // 从文件读取目标数据
        final goalsJson = await rootBundle.loadString('documents/goal_data.json');
        final goalsDataMap = jsonDecode(goalsJson);
        final goals = (goalsDataMap['goals'] as List).map((goalJson) => Goal.fromJson(goalJson)).toList();
        await saveGoals(goals);

        // 从文件读取用户数据
        final userDataJson = await rootBundle.loadString('documents/user_data.json');
        final userDataMap = jsonDecode(userDataJson);
        await saveUserData(userDataMap);

        await _logService.info('默认数据初始化成功');
      }
    } catch (e) {
      debugPrint('初始化默认数据失败: $e');
      await _logService.error('初始化默认数据失败: $e');
    }
  }

  /// 检查IndexedDB中是否存在数据
  Future<bool> _checkIndexedDBData() async {
    if (_db == null) return false;

    try {
      // 检查goals数据
      final goalsTxn = _db!.transaction(_goalsStore, 'readonly');
      final goalsStore = goalsTxn.objectStore(_goalsStore);
      final goalsCount = await goalsStore.count();
      await goalsTxn.completed;

      // 检查user数据
      final userTxn = _db!.transaction(_userStore, 'readonly');
      final userStore = userTxn.objectStore(_userStore);
      final userCount = await userStore.count();
      await userTxn.completed;

      await _logService.info('检查IndexedDB数据: goals=$goalsCount, user=$userCount');
      return goalsCount > 0 || userCount > 0;
    } catch (e) {
      debugPrint('检查IndexedDB数据失败: $e');
      await _logService.error('检查IndexedDB数据失败: $e');
      return false;
    }
  }

  /// 从IndexedDB加载数据
  Future<void> _loadDataFromIndexedDB() async {
    if (_db == null) return;

    try {
      // 加载goals数据
      final goals = await loadGoals();
      if (goals.isNotEmpty) {
        debugPrint('从IndexedDB成功加载${goals.length}个目标');
      }

      // 加载user数据
      final userData = await loadUserData();
      if (userData != null) {
        debugPrint('从IndexedDB成功加载用户数据');
      }

      await _logService.info('从IndexedDB加载数据成功');
    } catch (e) {
      debugPrint('从IndexedDB加载数据失败: $e');
      await _logService.error('从IndexedDB加载数据失败: $e');
    }
  }
} 
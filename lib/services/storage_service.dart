import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import '../models/goal.dart';
import 'log_service.dart';
import 'package:flutter/foundation.dart';
import '../core/config/environment_config.dart';
import '../core/config/app_config.dart';

class StorageService {
  static const _localStorageKey = 'goals_data';
  late final SharedPreferences _prefs;
  late final String documentsPath;
  late final LogService _logService;

  // 添加一个公共方法来访问 SharedPreferences
  SharedPreferences get prefs => _prefs;

  Future<void> init() async {
    try {
      // 初始化 SharedPreferences
      _prefs = await SharedPreferences.getInstance();
      
      // 获取文档目录
      if (EnvironmentConfig.isWeb) {
        // Web环境使用配置的路径
        documentsPath = AppConfig.path.webDocumentsPath;
      } else {
        // 原生平台使用应用文档目录
        final docDir = await getApplicationDocumentsDirectory();
        documentsPath = docDir.path;
      }

      // 初始化日志服务
      _logService = LogService();
      await _logService.init(documentsPath);
      
      await _logService.info('存储服务初始化成功');
    } catch (e) {
      debugPrint('初始化存储服务失败: $e');
    }
  }

  /// 获取日志服务实例
  LogService get logService => _logService;

  Future<List<Goal>> loadGoals() async {
    try {
      final goalsJson = prefs.getString(_localStorageKey);
      debugPrint('从本地存储加载数据: $goalsJson');
      
      if (goalsJson != null) {
        final List<dynamic> decoded = jsonDecode(goalsJson);
        return decoded.map((item) => Goal.fromJson(item)).toList();
      }
    } catch (e) {
      debugPrint('加载目标时出错: $e');
    }
    return [];
  }

  Future<void> saveGoals(List<Goal> goals) async {
    try {
      final goalsJson = jsonEncode(goals.map((goal) => goal.toJson()).toList());
      debugPrint('保存数据到本地存储: $goalsJson');
      await prefs.setString(_localStorageKey, goalsJson);
    } catch (e) {
      debugPrint('保存目标时出错: $e');
    }
  }
} 
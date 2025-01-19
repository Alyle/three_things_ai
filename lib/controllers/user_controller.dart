import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/storage_service.dart';
import '../core/utils/date_time_util.dart';
import '../core/config/environment_config.dart';

class UserController extends GetxController {
  final StorageService _storageService;
  final _userData = Rxn<UserData>();
// 更新键名

  UserController(this._storageService);

  /// 获取用户数据
  UserData? get userData => _userData.value;

  /// 初始化
  @override
  Future<void> onInit() async {
    super.onInit();
    await _loadData();
  }

  /// 加载数据
  Future<void> _loadData() async {
    try {
      if (EnvironmentConfig.isWeb) {
        final data = await _storageService.loadUserData();
        _userData.value = data != null 
            ? UserData.fromJson(data)
            : _createDefaultUserData();
      } else {
        final jsonString = _storageService.prefs.getString('user_data');
        _userData.value = jsonString != null 
            ? UserData.fromJson(jsonDecode(jsonString))
            : _createDefaultUserData();
      }
      await _saveData();
    } catch (e) {
      debugPrint('加载用户数据失败: $e');
      _userData.value = _createDefaultUserData();
    }
  }

  /// 保存数据
  Future<void> _saveData() async {
    if (_userData.value == null) return;
    
    try {
      if (EnvironmentConfig.isWeb) {
        await _storageService.saveUserData(_userData.value!.toJson());
      } else {
        await _storageService.prefs.setString(
          'user_data',
          jsonEncode(_userData.value!.toJson())
        );
      }
    } catch (e) {
      debugPrint('保存用户数据失败: $e');
    }
  }

  /// 更新首次启动状态
  Future<void> setFirstLaunch(bool value) async {
    if (_userData.value == null) return;
    
    _userData.value = _userData.value!.copyWith(isFirstLaunch: value);
    await _saveData();
  }

  /// 更新登录时间
  Future<void> updateLoginTime() async {
    if (_userData.value == null) return;
    
    _userData.value = _userData.value!.copyWith(lastLoginTime: DateTime.now());
    await _saveData();
  }

  /// 创建默认用户数据
  UserData _createDefaultUserData() {
    final now = DateTime.now();
    return UserData(
      isFirstLaunch: true,
      lastLoginTime: now,
      user: User(
        id: 'default_user',
        name: '默认用户',
        createdAt: now,
        lastLoginAt: now,
      ),
      stats: GoalStats(
        total: 0,
        completed: 0,
        byPeriod: {
          'day': _createDefaultPeriodStats(DateTimeUtil.getDayOfYear()),
          'week': _createDefaultPeriodStats(DateTimeUtil.getWeekOfYear()),
          'month': _createDefaultPeriodStats(DateTimeUtil.getMonthOfYear()),
          'quarter': _createDefaultPeriodStats(DateTimeUtil.getQuarterOfYear()),
          'year': _createDefaultPeriodStats(now.year),
        },
      ),
    );
  }

  /// 创建默认周期统计数据
  PeriodStats _createDefaultPeriodStats(int number) {
    return PeriodStats(
      total: 0,
      completed: 0,
      currentPeriod: CurrentPeriodStats(
        number: number,
        total: 0,
        completed: 0,
      ),
    );
  }

  // ... 其他辅助方法保持不变 ...
} 
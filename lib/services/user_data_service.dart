import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/user_data.dart';
import 'storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/utils/date_time_util.dart';

class UserDataService {
  static const String _key = 'user_data';
  UserData? _userData;
  final StorageService _storageService;

  UserDataService(this._storageService);

  /// 初始化服务
  Future<void> init() async {
    try {
      final jsonString = _storageService.prefs.getString(_key);
      if (jsonString != null) {
        _userData = UserData.fromJson(jsonDecode(jsonString));
        debugPrint('用户数据加载成功: ${jsonEncode(_userData!.toJson())}');
      } else {
        _userData = _createDefaultUserData();
        await _saveData();
        debugPrint('创建新的用户数据: ${jsonEncode(_userData!.toJson())}');
      }
    } catch (e) {
      _userData = _createDefaultUserData();
      debugPrint('加载用户数据失败，使用默认值: $e');
    }
  }

  /// 保存数据
  Future<void> _saveData() async {
    if (_userData == null) return;
    await _storageService.prefs.setString(_key, jsonEncode(_userData!.toJson()));
  }

  /// 更新首次启动状态
  Future<void> setFirstLaunch(bool value) async {
    if (_userData == null) return;
    
    _userData = _userData!.copyWith(isFirstLaunch: value);
    await _saveData();
  }

  /// 更新登录时间
  Future<void> updateLoginTime() async {
    if (_userData == null) return;
    
    _userData = _userData!.copyWith(lastLoginTime: DateTime.now());
    await _saveData();
  }

  /// 获取用户数据
  UserData? get userData => _userData;

  Future<void> saveUserData(UserData userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, jsonEncode(userData.toJson()));
    } catch (e) {
      debugPrint('保存用户数据失败: $e');
      rethrow;
    }
  }

  Future<UserData> loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_key);
      
      if (jsonStr == null) {
        return _createDefaultUserData();
      }
      
      return UserData.fromJson(jsonDecode(jsonStr));
    } catch (e) {
      debugPrint('加载用户数据失败: $e');
      return _createDefaultUserData();
    }
  }

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
} 
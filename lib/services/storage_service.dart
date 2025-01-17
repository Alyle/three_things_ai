import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/goal.dart';

class StorageService {
  static const _localStorageKey = 'goals_data';
  late SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<List<Goal>> loadGoals() async {
    try {
      final goalsJson = _prefs.getString(_localStorageKey);
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
      await _prefs.setString(_localStorageKey, goalsJson);
    } catch (e) {
      debugPrint('保存目标时出错: $e');
    }
  }
} 
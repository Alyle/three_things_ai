import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/goal.dart';
import '../services/storage_service.dart';
import '../core/utils/date_formatter.dart';

class GoalController extends GetxController {
  final StorageService _storage;
  final goals = <Goal>[].obs;
  final _deletedGoals = <Goal>[].obs;
  final _uuid = const Uuid();

  GoalController(this._storage);

  @override
  void onInit() {
    super.onInit();
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    final loadedGoals = await _storage.loadGoals();
    goals.assignAll(loadedGoals);
  }

  List<Goal> getGoalsByPeriod(GoalPeriod period) {
    return goals.where((goal) => goal.period == period).toList();
  }

  Future<void> addGoal(String title, String description, GoalPeriod period) async {
    final periodGoals = getGoalsByPeriod(period);
    if (periodGoals.length >= 3) {
      Get.snackbar(
        '提示',
        '${DateFormatter.getPeriodText(period)}最多只能添加三个目标',
        duration: const Duration(milliseconds: 1500),
      );
      return;
    }

    final goal = Goal(
      id: _uuid.v4(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
      period: period,
      isCompleted: false,
    );

    goals.add(goal);
    await _storage.saveGoals(goals);
  }

  Future<void> updateGoalStatus(String id) async {
    final index = goals.indexWhere((goal) => goal.id == id);
    if (index != -1) {
      goals[index].isCompleted = !goals[index].isCompleted;
      goals.refresh();
      await _storage.saveGoals(goals);
    }
  }

  Future<void> updateGoalDetails(String goalId, String title, String description) async {
    try {
      final goalIndex = goals.indexWhere((g) => g.id == goalId);
      if (goalIndex != -1) {
        goals[goalIndex].title = title;
        goals[goalIndex].description = description;
        goals.refresh();
        await _storage.saveGoals(goals);
        Get.snackbar(
          '成功',
          '目标更新成功',
          duration: const Duration(milliseconds: 1500),
        );
      }
    } catch (e) {
      debugPrint('更新目标失败: $e');
      Get.snackbar(
        '错误',
        '更新目标失败',
        duration: const Duration(milliseconds: 1500),
      );
    }
  }

  Future<void> deleteGoal(String id) async {
    try {
      final goalIndex = goals.indexWhere((g) => g.id == id);
      if (goalIndex != -1) {
        final deletedGoal = goals.removeAt(goalIndex);
        _deletedGoals.add(deletedGoal);
        await _storage.saveGoals(goals);
        Get.snackbar(
          '成功',
          '目标已删除',
          duration: const Duration(milliseconds: 1500),
        );
      }
    } catch (e) {
      debugPrint('删除目标失败: $e');
      Get.snackbar(
        '错误',
        '删除目标失败',
        duration: const Duration(milliseconds: 1500),
      );
    }
  }

  Future<void> undoDelete() async {
    try {
      if (_deletedGoals.isNotEmpty) {
        final goalToRestore = _deletedGoals.removeLast();
        goals.add(goalToRestore);
        await _storage.saveGoals(goals);
        Get.snackbar(
          '成功',
          '已撤销删除',
          duration: const Duration(milliseconds: 1500),
        );
      }
    } catch (e) {
      debugPrint('撤销删除失败: $e');
      Get.snackbar(
        '错误',
        '撤销删除失败',
        duration: const Duration(milliseconds: 1500),
      );
    }
  }

  bool get hasDeletedGoals => _deletedGoals.isNotEmpty;
} 
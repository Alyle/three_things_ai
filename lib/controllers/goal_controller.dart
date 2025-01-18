import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/goal.dart';
import '../services/storage_service.dart';
import '../core/utils/date_formatter.dart';
import '../core/constants/app_constants.dart';

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

  Future<void> addGoal({
    required String title,
    required String description,
    required GoalPeriod period,
    DateTime? deadline,
    List<String>? tags,
    int priority = GoalPriority.medium,
  }) async {
    try {
      final periodGoals = getGoalsByPeriod(period);
      if (periodGoals.length >= 3) {
        Get.snackbar(
          '提示',
          '${DateFormatter.getPeriodText(period)}最多只能添加三个目标',
          duration: AppConstants.snackBarDuration,
        );
        return;
      }

      final goal = Goal(
        id: _uuid.v4(),
        title: title,
        description: description,
        createdAt: DateTime.now(),
        period: period,
        deadline: deadline,
        tags: tags,
        priority: priority,
      );

      goals.add(goal);
      await _storage.saveGoals(goals);
      
      Get.snackbar(
        '成功',
        '目标添加成功',
        duration: AppConstants.snackBarDuration,
      );
    } catch (e) {
      debugPrint('添加目标失败: $e');
      Get.snackbar(
        '错误',
        '添加目标失败',
        duration: AppConstants.snackBarDuration,
      );
    }
  }

  Future<void> updateGoalStatus(String id) async {
    final index = goals.indexWhere((goal) => goal.id == id);
    if (index != -1) {
      goals[index].isCompleted = !goals[index].isCompleted;
      goals.refresh();
      await _storage.saveGoals(goals);
    }
  }

  Future<void> updateGoalDetails({
    required String goalId,
    String? title,
    String? description,
    DateTime? deadline,
    List<String>? tags,
    int? priority,
  }) async {
    try {
      final goalIndex = goals.indexWhere((g) => g.id == goalId);
      if (goalIndex != -1) {
        if (title != null) goals[goalIndex].title = title;
        if (description != null) goals[goalIndex].description = description;
        if (deadline != null) goals[goalIndex].deadline = deadline;
        if (tags != null) goals[goalIndex].tags = tags;
        if (priority != null) goals[goalIndex].priority = priority;
        
        goals.refresh();
        await _storage.saveGoals(goals);
        
        Get.snackbar(
          '成功',
          '目标更新成功',
          duration: AppConstants.snackBarDuration,
        );
      }
    } catch (e) {
      debugPrint('更新目标失败: $e');
      Get.snackbar(
        '错误',
        '更新目标失败',
        duration: AppConstants.snackBarDuration,
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
          duration: AppConstants.snackBarDuration,
        );
      }
    } catch (e) {
      debugPrint('删除目标失败: $e');
      Get.snackbar(
        '错误',
        '删除目标失败',
        duration: AppConstants.snackBarDuration,
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
          duration: AppConstants.snackBarDuration,
        );
      }
    } catch (e) {
      debugPrint('撤销删除失败: $e');
      Get.snackbar(
        '错误',
        '撤销删除失败',
        duration: AppConstants.snackBarDuration,
      );
    }
  }

  bool get hasDeletedGoals => _deletedGoals.isNotEmpty;
} 
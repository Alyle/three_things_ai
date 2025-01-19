import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:three_things_ai/core/utils/date_time_util.dart';
import 'package:uuid/uuid.dart';
import '../models/goal.dart';
import '../services/storage_service.dart';
import '../core/utils/date_formatter.dart';
import '../services/notification_service.dart';

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
    int? priority,
  }) async {
    try {
      if (getGoalsByPeriod(period).length >= 3) {
        NotificationService.info(
          '提示',
          '${DateFormatter.getPeriodText(period)}最多只能添加三个目标',
        );
        return;
      }

      final goal = Goal(
        id: _uuid.v4(),
        title: title,
        description: description,
        createdAt: DateTime.now(),
        period: period,
        deadline: DateTimeUtil.getEndOfPeriod(period) ,
        tags: tags ?? [],
        priority: priority ?? 0,
      );

      goals.add(goal);
      await _storage.saveGoals(goals);
      
      NotificationService.success('目标添加成功');
    } catch (e) {
      debugPrint('添加目标失败: $e');
      NotificationService.error('添加目标失败');
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
    List<String>? tags,
    int? priority,
  }) async {
    try {
      final goalIndex = goals.indexWhere((g) => g.id == goalId);
      if (goalIndex != -1) {
        goals[goalIndex] = goals[goalIndex].copyWith(
          title: title,
          description: description,
          tags: tags,
          priority: priority,
        );
        
        goals.refresh();
        await _storage.saveGoals(goals);
        NotificationService.success('目标更新成功');
      }
    } catch (e) {
      debugPrint('更新目标失败: $e');
      NotificationService.error('更新目标失败');
    }
  }

  Future<void> deleteGoal(String id) async {
    try {
      final goalIndex = goals.indexWhere((g) => g.id == id);
      if (goalIndex != -1) {
        final deletedGoal = goals.removeAt(goalIndex);
        _deletedGoals.add(deletedGoal);
        await _storage.saveGoals(goals);
        NotificationService.success('目标已删除');
      }
    } catch (e) {
      debugPrint('删除目标失败: $e');
      NotificationService.error('删除目标失败');
    }
  }

  Future<void> undoDelete() async {
    try {
      if (_deletedGoals.isNotEmpty) {
        final goalToRestore = _deletedGoals.removeLast();
        goals.add(goalToRestore);
        await _storage.saveGoals(goals);
        NotificationService.success('已撤销删除');
      }
    } catch (e) {
      debugPrint('撤销删除失败: $e');
      NotificationService.error('撤销删除失败');
    }
  }

  bool get hasDeletedGoals => _deletedGoals.isNotEmpty;

  /// 更新目标
  Future<void> updateGoal(
    String id, {
    String? title,
    String? description,
    DateTime? deadline,
    List<String>? tags,
    int? priority,
  }) async {
    try {
      final goalIndex = goals.indexWhere((goal) => goal.id == id);
      if (goalIndex != -1) {
        final updatedGoal = goals[goalIndex].copyWith(
          title: title,
          description: description,
          deadline: deadline,
          tags: tags,
          priority: priority,
        );
        goals[goalIndex] = updatedGoal;
        await _storage.saveGoals(goals);
        NotificationService.success('目标已更新');
      }
    } catch (e) {
      debugPrint('更新目标失败: $e');
      NotificationService.error('更新目标失败');
    }
  }
} 
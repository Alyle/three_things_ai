import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/chat_message.dart';
import '../services/ai_service.dart';
import '../models/goal.dart';
import '../controllers/goal_controller.dart';
import '../services/notification_service.dart';

class ChatController extends GetxController {
  final AIService _aiService = AIService();
  final messages = <ChatMessage>[].obs;
  final isLoading = false.obs;
  final currentResponse = ''.obs;
  
  // 存储建议选项
  final suggestions = <String>[].obs;
  // 存储目标操作数据
  Map<String, dynamic>? pendingGoalAction;

  /// 发送消息并处理响应
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    // 添加用户消息
    messages.add(ChatMessage(
      content: content,
      isUser: true,
    ));

    // 添加 AI 响应消息占位
    messages.add(ChatMessage(
      content: '',
      isUser: false,
      suggestions: [],
    ));

    isLoading.value = true;
    currentResponse.value = '';
    suggestions.clear();

    try {
      String fullResponse = '';
      bool jsonProcessed = false;

      await for (final chunk in _aiService.getChatResponseStream(content)) {
        fullResponse += chunk;
        currentResponse.value = fullResponse;
        
        // 只在完整接收到JSON响应且未处理过时处理
        if (!jsonProcessed && 
            fullResponse.trim().startsWith('{') && 
            fullResponse.trim().endsWith('}')) {
          try {
            final jsonResponse = jsonDecode(fullResponse);
            await _handleJsonResponse(jsonResponse);
            jsonProcessed = true;
          } catch (e) {
            debugPrint('JSON解析失败: $e');
          }
        }
        
        // 更新 AI 消息内容
        messages.last.content = currentResponse.value;
        messages.refresh();
      }
    } catch (e) {
      debugPrint('发送消息失败: $e');
      messages.last.content = '抱歉，发生了一些错误，请稍后重试。';
      messages.refresh();
    } finally {
      isLoading.value = false;
    }
  }

  /// 处理JSON格式的响应
  Future<void> _handleJsonResponse(Map<String, dynamic> jsonResponse) async {
    switch (jsonResponse['type']) {
      case 'goal_query':
        _handleGoalQuery(jsonResponse);
        break;
      case 'goal_action':
        await _handleGoalAction(jsonResponse);
        // 处理完目标操作后也要更新建议
        if (jsonResponse['suggestions'] != null) {
          final newSuggestions = List<String>.from(jsonResponse['suggestions']);
          messages.last.suggestions = newSuggestions;
          suggestions.assignAll(newSuggestions);
        }
        break;
    }
  }

  /// 处理目标查询响应
  void _handleGoalQuery(Map<String, dynamic> response) {
    currentResponse.value = response['answer'] ?? '';
    
    if (response['suggestions'] != null) {
      final newSuggestions = List<String>.from(response['suggestions']);
      messages.last.suggestions = newSuggestions;
      suggestions.assignAll(newSuggestions);
    }
  }

  /// 处理目标操作响应
  Future<void> _handleGoalAction(Map<String, dynamic> response) async {
    final actionNum = response['action_num'] as int;
    final actions = response['actions'] as List;
    final goalController = Get.find<GoalController>();
    var successCount = 0;
    
    try {
      for (var i = 0; i < actionNum; i++) {
        final action = actions[i];
        final data = action['data'];
        
        switch (action['action']) {
          case 'add':
            await _handleAddGoal(goalController, data);
            successCount++;
            break;
          case 'update':
            if (await _handleUpdateGoal(goalController, data)) {
              successCount++;
            }
            break;
          case 'delete':
            if (await _handleDeleteGoal(goalController, data)) {
              successCount++;
            }
            break;
        }
      }
      
      currentResponse.value = '已成功处理 $successCount/$actionNum 个目标操作';
    } catch (e) {
      debugPrint('处理目标操作失败: $e');
      currentResponse.value = '处理目标操作失败，请重试';
    }
  }

  /// 处理添加目标
  Future<void> _handleAddGoal(GoalController controller, Map<String, dynamic> data) async {
    if (controller.getGoalsByPeriod(_parsePeriod(data['period'])).length >= 3) {
      NotificationService.info(
        '提示',
        '${_getPeriodText(data['period'])}已有3个目标，无法添加更多',
      );
      throw Exception('目标数量已达上限');
    }
    
    await controller.addGoal(
      title: data['title'],
      description: data['description'],
      period: _parsePeriod(data['period']),
      deadline: data['deadline'] != null ? DateTime.parse(data['deadline']) : null,
      tags: List<String>.from(data['tags'] ?? []),
      priority: data['priority'] ?? 2,
    );
  }

  /// 处理更新目标
  Future<bool> _handleUpdateGoal(GoalController controller, Map<String, dynamic> data) async {
    final goals = controller.getGoalsByPeriod(_parsePeriod(data['period']));
    final goalToUpdate = goals.firstWhereOrNull((g) => g.title == data['old_title']);
    
    if (goalToUpdate == null) {
      NotificationService.info('提示', '未找到要更新的目标：${data['title']}');
      return false;
    }
    
    await controller.updateGoal(
      goalToUpdate.id,
      title: data['title'],
      description: data['description'],
      deadline: data['deadline'] != null ? DateTime.parse(data['deadline']) : null,
      tags: List<String>.from(data['tags'] ?? []),
      priority: data['priority'] ?? goalToUpdate.priority,
    );
    
    return true;
  }

  /// 处理删除目标
  Future<bool> _handleDeleteGoal(GoalController controller, Map<String, dynamic> data) async {
    final goals = controller.getGoalsByPeriod(_parsePeriod(data['period']));
    final goalToDelete = goals.firstWhereOrNull((g) => g.title == data['title']);
    
    if (goalToDelete == null) {
      NotificationService.info('提示', '未找到要删除的目标：${data['title']}');
      return false;
    }
    
    await controller.deleteGoal(goalToDelete.id);
    
    return true;
  }

  /// 处理建议选项点击
  void handleSuggestionTap(String suggestion) {
    sendMessage(suggestion);
  }

  /// 解析目标周期
  GoalPeriod _parsePeriod(String period) {
    switch (period) {
      case 'daily': return GoalPeriod.daily;
      case 'weekly': return GoalPeriod.weekly;
      case 'monthly': return GoalPeriod.monthly;
      case 'quarterly': return GoalPeriod.quarterly;
      case 'yearly': return GoalPeriod.yearly;
      default: return GoalPeriod.daily;
    }
  }

  /// 获取周期文本
  String _getPeriodText(String period) {
    switch (period) {
      case 'daily': return '今日';
      case 'weekly': return '本周';
      case 'monthly': return '本月';
      case 'quarterly': return '本季度';
      case 'yearly': return '今年';
      default: return '当前周期';
    }
  }
} 
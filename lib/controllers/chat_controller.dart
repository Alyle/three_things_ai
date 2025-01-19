import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/chat_message.dart';
import '../services/ai_service.dart';
import '../models/goal.dart';
import '../controllers/goal_controller.dart';
import '../services/notification_service.dart';
import '../core/utils/json_fixer.dart';
import '../core/config/app_config.dart';

/// 聊天控制器：负责管理AI对话的状态和业务逻辑
class ChatController extends GetxController {
  /// AI服务实例，用于处理与AI的通信
  final AIService _aiService = AIService();
  
  /// 聊天消息列表，使用Rx实现响应式更新
  final messages = <ChatMessage>[].obs;
  
  /// 加载状态标志
  final isLoading = false.obs;
  
  /// 当前AI响应的内容
  final currentResponse = ''.obs;
  
  /// 存储AI建议的选项列表
  final suggestions = <String>[].obs;
  
  /// 存储待处理的目标操作数据
  Map<String, dynamic>? pendingGoalAction;

  /// 发送消息并处理AI响应
  /// [content] 用户发送的消息内容
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    // 添加用户消息到列表
    messages.add(ChatMessage(
      content: content,
      isUser: true,
    ));

    // 添加AI响应的占位消息
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
      Duration? responseDuration;

      await for (final response in _aiService.getChatResponseStream(content)) {
        fullResponse += response['content'] as String;
        responseDuration = response['duration'] as Duration;
        
        // 根据配置决定是否进行JSON检查
        if (AppConfig.feature.enableJsonCheck && 
            !jsonProcessed && 
            fullResponse.trim().startsWith('{') && 
            fullResponse.trim().endsWith('}')) {
          try {
            final jsonResponse = JsonFixer.fixAndParseJson(fullResponse);
            if (jsonResponse != null) {
              await _handleJsonResponse(jsonResponse);
              jsonProcessed = true;
            }
          } catch (e) {
            debugPrint('JSON解析失败: $e');
          }
        }
        
        currentResponse.value = fullResponse;
        final stats = {
          'wordCount': fullResponse.length.toString().padLeft(4),
          'duration': (responseDuration.inMilliseconds / 1000).toStringAsFixed(2)
        };
        messages.last.content = currentResponse.value;
        messages.last.stats = stats;
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

  /// 处理JSON格式的AI响应
  /// [jsonResponse] AI返回的JSON数据
  Future<void> _handleJsonResponse(Map<String, dynamic> jsonResponse) async {
    switch (jsonResponse['type']) {
      case 'goal_query':  // 处理目标查询响应
        _handleGoalQuery(jsonResponse);
        break;
      case 'goal_action':  // 处理目标操作响应
        await _handleGoalAction(jsonResponse);
        break;
    }
  }

  /// 处理目标查询响应
  /// [response] 查询响应数据
  void _handleGoalQuery(Map<String, dynamic> response) {
    // 更新AI回复内容
    currentResponse.value = response['answer'] ?? '';
    
    // 更新建议选项
    if (response['suggestions'] != null) {
      final newSuggestions = List<String>.from(response['suggestions']);
      messages.last.suggestions = newSuggestions;
      suggestions.assignAll(newSuggestions);
    }
  }

  /// 处理目标操作响应（添加/更新/删除目标）
  /// [response] 操作响应数据
  Future<void> _handleGoalAction(Map<String, dynamic> response) async {
    try {
      final actionNum = response['action_num'] as int;  // 操作数量
      final actions = response['actions'] as List;      // 操作列表
      final goalController = Get.find<GoalController>();
      var successCount = 0;
      final operationResults = <String>[];

      // 处理每个操作
      for (final action in actions) {
        final data = action['data'] as Map<String, dynamic>;
        final period = _getPeriodText(data['period']);
        
        switch (action['action']) {
          case 'add':
            await _handleAddGoal(goalController, data);
            operationResults.add('添加$period目标：${data['title']}');
            successCount++;
            break;
          case 'update':
            if (await _handleUpdateGoal(goalController, data)) {
              operationResults.add('更新$period目标：${data['title']}');
              successCount++;
            }
            break;
          case 'delete':
            if (await _handleDeleteGoal(goalController, data)) {
              operationResults.add('删除$period目标：${data['title']}');
              successCount++;
            }
            break;
        }
      }
      
      // 更新操作结果消息
      currentResponse.value = 
          '已成功处理 $successCount/$actionNum 个目标操作：\n${operationResults.map((r) => ' - $r').join('\n')}';

      // 更新建议选项
      if (response['suggestions'] != null) {
        final newSuggestions = List<String>.from(response['suggestions']);
        messages.last.suggestions = newSuggestions;
        suggestions.assignAll(newSuggestions);
      }
    } catch (e) {
      debugPrint('处理目标操作失败: $e');
      currentResponse.value = '处理目标操作失败，请重试';
    }
  }

  /// 处理添加目标操作
  /// [controller] 目标控制器
  /// [data] 目标数据
  Future<void> _handleAddGoal(GoalController controller, Map<String, dynamic> data) async {
    // 检查目标数量限制
    if (controller.getGoalsByPeriod(_parsePeriod(data['period'])).length >= 3) {
      NotificationService.info(
        '提示',
        '${_getPeriodText(data['period'])}已有3个目标，无法添加更多',
      );
      throw Exception('目标数量已达上限');
    }
    
    // 添加新目标
    await controller.addGoal(
      title: data['title'],
      description: data['description'],
      period: _parsePeriod(data['period']),
      deadline: data['deadline'] != null ? DateTime.parse(data['deadline']) : null,
      tags: List<String>.from(data['tags'] ?? []),
      priority: data['priority'] ?? 2,
    );
  }

  /// 处理更新目标操作
  /// [controller] 目标控制器
  /// [data] 更新数据
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

  /// 处理删除目标操作
  /// [controller] 目标控制器
  /// [data] 删除数据
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
  /// [suggestion] 用户选择的建议内容
  void handleSuggestionTap(String suggestion) {
    sendMessage(suggestion);
  }

  /// 解析目标周期字符串为枚举值
  /// [period] 周期字符串
  GoalPeriod _parsePeriod(String period) {
    switch (period) {
      case 'day': return GoalPeriod.day;
      case 'week': return GoalPeriod.week;
      case 'month': return GoalPeriod.month;
      case 'quarter': return GoalPeriod.quarter;
      case 'year': return GoalPeriod.year;
      default: return GoalPeriod.day;
    }
  }

  /// 获取周期的中文显示文本
  /// [period] 周期字符串
  String _getPeriodText(String period) {
    switch (period) {
      case 'day': return '今日';
      case 'week': return '本周';
      case 'month': return '本月';
      case 'quarter': return '本季度';
      case 'year': return '今年';
      default: return '当前周期';
    }
  }
} 
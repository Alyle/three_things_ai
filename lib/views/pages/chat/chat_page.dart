import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/chat_controller.dart';
import '../../../models/chat_message.dart';
import '../../../core/theme/app_theme.dart';

/// 聊天页面组件
class ChatPage extends StatelessWidget {
  /// 聊天控制器
  final ChatController controller = Get.put(ChatController());
  
  /// 输入框控制器
  final TextEditingController _textController = TextEditingController();
  
  /// 滚动控制器，用于消息列表滚动
  final ScrollController _scrollController = ScrollController();

  ChatPage({super.key});

  /// 格式化时间戳
  String _formatTime(DateTime time) {
    return DateFormat('yyyy/MM/dd HH:mm').format(time);
  }

  /// 滚动到消息列表底部
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  /// 构建单条消息气泡
  Widget _buildMessage(BuildContext context, ChatMessage message) {
    return Column(
      // 根据消息发送者调整对齐方式
      crossAxisAlignment: message.isUser 
          ? CrossAxisAlignment.end 
          : CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          // 根据发送者设置不同背景色
          color: message.isUser 
              ? AppColors.chatUserBackground 
              : AppColors.chatAiBackground,
          child: Column(
            crossAxisAlignment: message.isUser 
                ? CrossAxisAlignment.end 
                : CrossAxisAlignment.start,
            children: [
              // 消息头部：发送者和时间
              Row(
                mainAxisAlignment: message.isUser 
                    ? MainAxisAlignment.end 
                    : MainAxisAlignment.start,
                children: [
                  Text(
                    message.isUser ? '我' : 'AI助手',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // 消息内容，支持选择文本
              SelectableText(
                message.content,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        // AI回复后显示建议按钮
        if (!message.isUser && message.suggestions?.isNotEmpty == true)
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              alignment: WrapAlignment.center,
              children: message.suggestions!.map((suggestion) => 
                ElevatedButton(
                  onPressed: () => controller.handleSuggestionTap(suggestion),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[50],
                    foregroundColor: Colors.blue[900],
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.blue[200]!),
                    ),
                  ),
                  child: Text(
                    suggestion,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ).toList(),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      // 顶部应用栏
      appBar: AppBar(
        title: const Text('AI 助手'),
        elevation: 0,
        backgroundColor: Colors.blue[50],
        foregroundColor: Colors.blue[900],
      ),
      body: Column(
        children: [
          // 消息列表区域
          Expanded(
            child: Obx(() {
              // 空消息提示
              if (controller.messages.isEmpty) {
                return Center(
                  child: Text(
                    '开始和AI助手对话吧！',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                );
              }
              
              // 每次构建后滚动到底部
              WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
              
              // 消息列表
              return ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                reverse: false,
                itemCount: controller.messages.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16.0),
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  return _buildMessage(context, message);
                },
              );
            }),
          ),
          // 加载指示器
          Obx(() {
            if (controller.isLoading.value) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[300]!),
                  strokeWidth: 2,
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          // 底部输入区域
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(50),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                // 输入框
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: '输入消息...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                    ),
                    onSubmitted: _handleSubmit,
                  ),
                ),
                const SizedBox(width: 8.0),
                // 发送按钮
                IconButton(
                  icon: Icon(
                    Icons.send_rounded,
                    color: Colors.blue[700],
                  ),
                  onPressed: () => _handleSubmit(_textController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 处理消息发送
  void _handleSubmit(String value) {
    if (value.trim().isNotEmpty) {
      controller.sendMessage(value);
      _textController.clear();
    }
  }
} 
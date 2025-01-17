import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';

class ChatPage extends StatelessWidget {
  final ChatController controller = Get.put(ChatController());
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  ChatPage({super.key});

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 助手'),
        backgroundColor: Colors.blue[100],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.messages.isEmpty) {
                return const Center(
                  child: Text(
                    '开始和AI助手对话吧！',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                );
              }
              
              // 当消息更新时，滚动到底部
              WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
              
              return ListView.builder(
                controller: _scrollController,
                reverse: false,
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    child: Align(
                      alignment: message.isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: message.isUser
                              ? Colors.blue[100]
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          message.content,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              );
            }
            return const SizedBox.shrink();
          }),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: '输入消息...',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        controller.sendMessage(value);
                        _textController.clear();
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_textController.text.trim().isNotEmpty) {
                      controller.sendMessage(_textController.text);
                      _textController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 
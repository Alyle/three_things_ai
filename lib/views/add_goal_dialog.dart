import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/goal_controller.dart';
import '../models/goal.dart';

class AddGoalDialog extends StatefulWidget {
  final GoalPeriod period;

  const AddGoalDialog({
    super.key,
    required this.period,
  });

  @override
  State<AddGoalDialog> createState() => _AddGoalDialogState();
}

class _AddGoalDialogState extends State<AddGoalDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _controller = Get.find<GoalController>();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      _controller.addGoal(
        _titleController.text,
        _descriptionController.text,
        widget.period,
      );
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blue[50],
      title: Text(
        '添加目标',
        style: TextStyle(color: Colors.blue[900]),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: '目标标题',
                hintText: '请输入目标标题',
                labelStyle: TextStyle(color: Colors.blue[700]),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[300]!),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入目标标题';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: '目标描述',
                hintText: '请输入目标描述',
                labelStyle: TextStyle(color: Colors.blue[700]),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[300]!),
                ),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('取消', style: TextStyle(color: Colors.blue[700])),
        ),
        ElevatedButton(
          onPressed: _handleSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[100],
            foregroundColor: Colors.blue[900],
          ),
          child: const Text('添加'),
        ),
      ],
    );
  }
} 
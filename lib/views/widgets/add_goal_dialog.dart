import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/goal_controller.dart';
import '../../models/goal.dart';

class AddGoalDialog extends StatefulWidget {
  const AddGoalDialog({super.key});

  @override
  _AddGoalDialogState createState() => _AddGoalDialogState();
}

class _AddGoalDialogState extends State<AddGoalDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  GoalPeriod _selectedPeriod = GoalPeriod.daily;
  final _controller = Get.find<GoalController>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('添加新目标'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '目标标题',
                hintText: '请输入目标标题',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入目标标题';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<GoalPeriod>(
              value: _selectedPeriod,
              decoration: const InputDecoration(
                labelText: '目标周期',
              ),
              items: GoalPeriod.values.map((period) {
                return DropdownMenuItem(
                  value: period,
                  child: Text(_getPeriodText(period)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPeriod = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text('添加'),
        ),
      ],
    );
  }

  String _getPeriodText(GoalPeriod period) {
    switch (period) {
      case GoalPeriod.daily:
        return '每日';
      case GoalPeriod.weekly:
        return '每周';
      case GoalPeriod.monthly:
        return '每月';
      case GoalPeriod.quarterly:
        return '季度';
      case GoalPeriod.yearly:
        return '年度';
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _controller.addGoal(
          _titleController.text,
          '', // description
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
} 
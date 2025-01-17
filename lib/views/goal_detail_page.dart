import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/goal_controller.dart';
import '../models/goal.dart';

class GoalDetailPage extends StatefulWidget {
  final Goal goal;

  const GoalDetailPage({super.key, required this.goal});

  @override
  State<GoalDetailPage> createState() => _GoalDetailPageState();
}

class _GoalDetailPageState extends State<GoalDetailPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _controller = Get.find<GoalController>();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.goal.title;
    _descriptionController.text = widget.goal.description;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      if (_isEditing) {
        // 保存更改
        _controller.updateGoalDetails(
          widget.goal.id,
          _titleController.text,
          _descriptionController.text,
        );
      }
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('目标详情'),
        centerTitle: true,
        backgroundColor: Colors.blue[50],
        foregroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Text(
              '目标标题',
              style: TextStyle(
                color: Colors.blue[900],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _isEditing
              ? TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                )
              : Text(
                  widget.goal.title,
                  style: const TextStyle(fontSize: 18),
                ),
            const SizedBox(height: 24),

            // 描述
            Text(
              '目标描述',
              style: TextStyle(
                color: Colors.blue[900],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _isEditing
              ? TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                )
              : Text(
                  widget.goal.description,
                  style: const TextStyle(fontSize: 16),
                ),
            const SizedBox(height: 24),

            // 创建时间
            Text(
              '创建时间',
              style: TextStyle(
                color: Colors.blue[900],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _formatDateTime(widget.goal.createdAt),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            // 完成状态
            Text(
              '完成状态',
              style: TextStyle(
                color: Colors.blue[900],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (_isEditing)
                  Checkbox(
                    value: widget.goal.isCompleted,
                    onChanged: (value) {
                      _controller.updateGoalStatus(widget.goal.id);
                    },
                    activeColor: Colors.blue[300],
                  ),
                Text(
                  widget.goal.isCompleted ? '已完成' : '未完成',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: 'edit',
        onPressed: _toggleEdit,
        backgroundColor: Colors.blue[100],
        child: Icon(
          _isEditing ? Icons.save : Icons.edit,
          color: Colors.blue[900],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}年${dateTime.month}月${dateTime.day}日 '
           '${dateTime.hour.toString().padLeft(2, '0')}:'
           '${dateTime.minute.toString().padLeft(2, '0')}';
  }
} 
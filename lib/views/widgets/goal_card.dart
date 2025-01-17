import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/goal_controller.dart';
import '../../views/goal_detail_page.dart';

class GoalCard extends StatelessWidget {
  final String goalId;
  final _controller = Get.find<GoalController>();

  GoalCard({Key? key, required this.goalId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final goal = _controller.goals.firstWhere((g) => g.id == goalId);
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue[50],
            child: Icon(
              goal.isCompleted ? Icons.check : Icons.hourglass_empty,
              color: Colors.blue[900],
            ),
          ),
          title: Text(
            goal.title,
            style: TextStyle(
              decoration: goal.isCompleted ? TextDecoration.lineThrough : null,
              color: goal.isCompleted ? Colors.grey : Colors.black87,
            ),
          ),
          subtitle: goal.description.isNotEmpty
            ? Text(
                goal.description,
                style: TextStyle(
                  color: goal.isCompleted ? Colors.grey : Colors.black54,
                ),
              )
            : null,
          trailing: Checkbox(
            value: goal.isCompleted,
            onChanged: (value) => _controller.updateGoalStatus(goal.id),
            activeColor: Colors.blue[300],
          ),
          onTap: () => Get.to(() => GoalDetailPage(goal: goal)),
        ),
      );
    });
  }
} 
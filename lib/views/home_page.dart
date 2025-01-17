import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../controllers/goal_controller.dart';
import 'add_goal_dialog.dart';
import 'goal_detail_page.dart';

class HomePage extends StatelessWidget {
  final GoalController controller;

  HomePage({super.key}) : controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('三件事'),
        centerTitle: true,
        backgroundColor: Colors.blue[50],
        foregroundColor: Colors.blue[900],
      ),
      body: _buildGoalList(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Obx(() => controller.hasDeletedGoals
            ? Padding(
                padding: const EdgeInsets.only(left: 30),
                child: FloatingActionButton(
                  heroTag: 'undo',
                  onPressed: () => controller.undoDelete(),
                  backgroundColor: Colors.blue[100],
                  child: Icon(Icons.undo, color: Colors.blue[900]),
                ),
              )
            : const SizedBox.shrink()
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () => Get.dialog(const AddGoalDialog()),
            backgroundColor: Colors.blue[100],
            child: Icon(Icons.add, color: Colors.blue[900]),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalList() {
    return Obx(() => ListView.builder(
      itemCount: controller.goals.length,
      itemBuilder: (context, index) {
        final goal = controller.goals[index];
        return Slidable(
          key: Key(goal.id),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.15,
            children: [
              CustomSlidableAction(
                backgroundColor: Colors.red[100]!,
                onPressed: (context) => controller.deleteGoal(goal.id),
                child: Icon(Icons.delete, color: Colors.red[900]),
              ),
            ],
          ),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue[50],
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(goal.title),
              subtitle: Text(goal.description),
              trailing: Checkbox(
                value: goal.isCompleted,
                onChanged: (value) => controller.updateGoalStatus(goal.id),
                activeColor: Colors.blue[300],
              ),
              onTap: () => Get.to(() => GoalDetailPage(goal: goal)),
            ),
          ),
        );
      },
    ));
  }
}
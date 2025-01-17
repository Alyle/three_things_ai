import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../controllers/goal_controller.dart';
import '../models/goal.dart';
import 'widgets/add_goal_dialog.dart';
import 'goal_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GoalController controller = Get.find();
  late GoalPeriod _currentPeriod;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _currentPeriod = GoalPeriod.daily;
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentPeriod = GoalPeriod.values[_tabController.index];
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('三件事AI助手'),
        centerTitle: true,
        backgroundColor: Colors.blue[50],
        foregroundColor: Colors.blue[900],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue[900],
          unselectedLabelColor: Colors.blue[200],
          indicatorColor: Colors.blue[900],
          tabs: const [
            Tab(text: '今日'),
            Tab(text: '本周'),
            Tab(text: '本月'),
            Tab(text: '本季'),
            Tab(text: '今年'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGoalList('daily'),
          _buildGoalList('weekly'),
          _buildGoalList('monthly'),
          _buildGoalList('quarterly'),
          _buildGoalList('yearly'),
        ],
      ),
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
            : const SizedBox.shrink(),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () => Get.dialog(AddGoalDialog(period: _currentPeriod)),
            backgroundColor: Colors.blue[100],
            child: Icon(Icons.add, color: Colors.blue[900]),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalList(String period) {
    final GoalPeriod goalPeriod = GoalPeriod.values.firstWhere(
      (e) => e.toString().split('.').last == period,
    );

    return Obx(() {
      final periodGoals = controller.getGoalsByPeriod(goalPeriod);
      return ListView.builder(
        itemCount: periodGoals.length,
        itemBuilder: (context, index) {
          final goal = periodGoals[index];
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
      );
    });
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../controllers/goal_controller.dart';
import '../../../models/goal.dart';
import '../../widgets/add_goal_dialog.dart';
import 'goal_detail_page.dart';
import '../../../core/theme/app_theme.dart';

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
    _currentPeriod = GoalPeriod.day;
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

  String _getPeriodText(GoalPeriod period) {
    switch (period) {
      case GoalPeriod.day:
        return '今日';
      case GoalPeriod.week:
        return '本周';
      case GoalPeriod.month:
        return '本月';
      case GoalPeriod.quarter:
        return '本季';
      case GoalPeriod.year:
        return '今年';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('三件事AI助手'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: theme.appBarTheme.foregroundColor,
          unselectedLabelColor: Colors.blue[200],
          indicatorColor: theme.appBarTheme.foregroundColor,
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
          _buildGoalList('day'),
          _buildGoalList('week'),
          _buildGoalList('month'),
          _buildGoalList('quarter'),
          _buildGoalList('year'),
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
                  child: const Icon(Icons.undo),
                ),
              )
            : const SizedBox.shrink(),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () {
              final periodGoals = controller.getGoalsByPeriod(_currentPeriod);
              if (periodGoals.length >= 3) {
                Get.snackbar(
                  '提示',
                  '${_getPeriodText(_currentPeriod)}最多只能添加三个目标',
                  duration: const Duration(milliseconds: 1500),
                );
                return;
              }
              Get.dialog(AddGoalDialog(period: _currentPeriod));
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalList(String period) {
    final theme = Theme.of(context);
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
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: AppTheme.cardDecoration,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.surface,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(goal.title),
                subtitle: Text(goal.description),
                trailing: Checkbox(
                  value: goal.isCompleted,
                  onChanged: (value) => controller.updateGoalStatus(goal.id),
                  activeColor: theme.colorScheme.primary,
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
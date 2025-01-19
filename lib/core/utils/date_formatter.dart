import 'package:intl/intl.dart';
import 'package:three_things_ai/models/goal.dart';

class DateFormatter {
  static String formatDateTime(DateTime time) {
    return DateFormat('yyyy/MM/dd HH:mm').format(time);
  }
  
  static String getPeriodText(GoalPeriod period) {
    switch (period) {
      case GoalPeriod.day: return '今日';
      case GoalPeriod.week: return '本周';
      case GoalPeriod.month: return '本月';
      case GoalPeriod.quarter: return '本季';
      case GoalPeriod.year: return '今年';
    }
  }
} 
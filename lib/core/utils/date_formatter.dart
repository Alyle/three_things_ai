import 'package:intl/intl.dart';
import 'package:three_things_ai/models/goal.dart';

class DateFormatter {
  static String formatDateTime(DateTime time) {
    return DateFormat('yyyy/MM/dd HH:mm').format(time);
  }
  
  static String getPeriodText(GoalPeriod period) {
    switch (period) {
      case GoalPeriod.daily: return '今日';
      case GoalPeriod.weekly: return '本周';
      case GoalPeriod.monthly: return '本月';
      case GoalPeriod.quarterly: return '本季';
      case GoalPeriod.yearly: return '今年';
    }
  }
} 
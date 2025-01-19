import 'package:three_things_ai/models/goal.dart';

/// 日期时间工具类
class DateTimeUtil {
  /// 获取当前时间
  static DateTime now() => DateTime.now();

  /// 获取今天的开始时间 (00:00:00)
  static DateTime startOfToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// 获取本周的开始时间 (周一 00:00:00)
  static DateTime startOfWeek() {
    final now = DateTime.now();
    final diff = now.weekday - 1;
    return DateTime(now.year, now.month, now.day - diff);
  }

  /// 获取本月的开始时间 (1号 00:00:00)
  static DateTime startOfMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }

  /// 获取本季度的开始时间 (本季度第一个月1号 00:00:00)
  static DateTime startOfQuarter() {
    final now = DateTime.now();
    final quarterMonth = ((now.month - 1) ~/ 3) * 3 + 1;
    return DateTime(now.year, quarterMonth, 1);
  }

  /// 获取本年的开始时间 (1月1号 00:00:00)
  static DateTime startOfYear() {
    final now = DateTime.now();
    return DateTime(now.year, 1, 1);
  }

  /// 获取目标的开始时间
  static DateTime getStartOfPeriod(GoalPeriod period) {
    switch (period) {
      case GoalPeriod.day: return startOfToday();
      case GoalPeriod.week: return startOfWeek();
      case GoalPeriod.month: return startOfMonth();
      case GoalPeriod.quarter: return startOfQuarter();
      case GoalPeriod.year: return startOfYear();
    }
  }

  /// 获取目标的结束时间
  static DateTime getEndOfPeriod(GoalPeriod period) {
    switch (period) {
      case GoalPeriod.day: return endOfToday();
      case GoalPeriod.week: return endOfWeek();
      case GoalPeriod.month: return endOfMonth();
      case GoalPeriod.quarter: return endOfQuarter();
      case GoalPeriod.year: return endOfYear();
    }
  }

  /// 获取今天的结束时间 (23:59:59.999)
  static DateTime endOfToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
  }

  /// 获取本周的结束时间 (周日 23:59:59.999)
  static DateTime endOfWeek() {
    final now = DateTime.now();
    final diff = 7 - now.weekday;
    return DateTime(now.year, now.month, now.day + diff, 23, 59, 59, 999);
  }

  /// 获取本月的结束时间 (月末 23:59:59.999)
  static DateTime endOfMonth() {
    final now = DateTime.now();
    final nextMonth = now.month < 12 ? now.month + 1 : 1;
    final year = now.month < 12 ? now.year : now.year + 1;
    return DateTime(year, nextMonth, 1).subtract(const Duration(milliseconds: 1));
  }

  /// 获取本季度的结束时间 (季末月末 23:59:59.999)
  static DateTime endOfQuarter() {
    final now = DateTime.now();
    final quarterEndMonth = ((now.month - 1) ~/ 3) * 3 + 3;
    final nextQuarterMonth = quarterEndMonth < 12 ? quarterEndMonth + 1 : 1;
    final year = quarterEndMonth < 12 ? now.year : now.year + 1;
    return DateTime(year, nextQuarterMonth, 1).subtract(const Duration(milliseconds: 1));
  }

  /// 获取本年的结束时间 (12月31日 23:59:59.999)
  static DateTime endOfYear() {
    final now = DateTime.now();
    return DateTime(now.year + 1, 1, 1).subtract(const Duration(milliseconds: 1));
  }

  /// 格式化日期时间为字符串 (yyyy-MM-dd HH:mm:ss)
  static String format(DateTime dateTime) {
    return '${dateTime.year}-'
        '${dateTime.month.toString().padLeft(2, '0')}-'
        '${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}:'
        '${dateTime.second.toString().padLeft(2, '0')}';
  }

  /// 格式化日期为字符串 (yyyy-MM-dd)
  static String formatDate(DateTime dateTime) {
    return '${dateTime.year}-'
        '${dateTime.month.toString().padLeft(2, '0')}-'
        '${dateTime.day.toString().padLeft(2, '0')}';
  }

  /// 格式化时间为字符串 (HH:mm:ss)
  static String formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}:'
        '${dateTime.second.toString().padLeft(2, '0')}';
  }

  /// 获取当前日期是一年中的第几天 (1-366)
  static int getDayOfYear() {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    return now.difference(startOfYear).inDays + 1;
  }

  /// 获取当前日期是一年中的第几周 (1-53)
  static int getWeekOfYear() {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    
    // 调整到第一周的周一
    final firstMonday = startOfYear.add(
      Duration(days: (8 - startOfYear.weekday) % 7)
    );
    
    if (now.isBefore(firstMonday)) {
      // 如果在第一个周一之前，说明是上一年的最后一周
      return getLastWeekOfYear(now.year - 1);
    }
    
    final diffDays = now.difference(firstMonday).inDays;
    return (diffDays / 7).floor() + 1;
  }

  /// 获取当前月份 (1-12)
  static int getMonthOfYear() {
    return DateTime.now().month;
  }

  /// 获取当前季度 (1-4)
  static int getQuarterOfYear() {
    return ((DateTime.now().month - 1) ~/ 3) + 1;
  }

  /// 获取指定年份的最后一周是第几周
  static int getLastWeekOfYear(int year) {
    final lastDay = DateTime(year, 12, 31);
    final startOfYear = DateTime(year, 1, 1);
    final firstMonday = startOfYear.add(
      Duration(days: (8 - startOfYear.weekday) % 7)
    );
    final diffDays = lastDay.difference(firstMonday).inDays;
    return (diffDays / 7).floor() + 1;
  }

  /// 获取当前日期在本月中的第几天 (1-31)
  static int getDayOfMonth() {
    return DateTime.now().day;
  }

  /// 获取当前日期在本周中的第几天 (1-7，周一为1)
  static int getDayOfWeek() {
    return DateTime.now().weekday;
  }

  /// 获取当前日期在本季度中的第几天 (1-92)
  static int getDayOfQuarter() {
    final now = DateTime.now();
    final startOfQuarter = DateTime(
      now.year,
      ((now.month - 1) ~/ 3) * 3 + 1,
      1
    );
    return now.difference(startOfQuarter).inDays + 1;
  }
} 
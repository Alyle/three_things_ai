import 'package:flutter/material.dart';

// 将所有颜色常量集中定义
class AppColors {
  static const MaterialColor primary = Colors.blue;
  static const Color surface = Color(0xFFF5F9FF);
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF34495E);
}

// 将字体相关配置集中
class AppFonts {
  static const String primaryFont = 'Roboto';
  static const List<String> fallbackFonts = [
    'Microsoft YaHei',
    'Heiti SC',
    'sans-serif'
  ];
} 
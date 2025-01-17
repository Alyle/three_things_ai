import 'package:flutter/material.dart';

class AppTheme {
  static const String _fontFamily = 'Roboto';
  static const List<String> _fontFamilyFallback = [
    'Microsoft YaHei',
    'Heiti SC',
    'sans-serif'
  ];

  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2196F3),  // Material Blue
      brightness: Brightness.light,
      surface: const Color(0xFFF5F9FF),    // 淡蓝色背景
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F9FF),
    useMaterial3: true,
    fontFamily: _fontFamily,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        fontFamilyFallback: _fontFamilyFallback,
        color: Color(0xFF2C3E50),          // 深灰蓝色文字
      ),
      bodyMedium: TextStyle(
        fontFamilyFallback: _fontFamilyFallback,
        color: Color(0xFF34495E),          // 稍浅的灰蓝色文字
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2196F3),   // 蓝色应用栏
      foregroundColor: Colors.white,        // 应用栏文字为白色
      elevation: 0,
    ),
  );
} 
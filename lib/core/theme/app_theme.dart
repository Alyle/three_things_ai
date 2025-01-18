import 'package:flutter/material.dart';

/// 应用主题配置
class AppTheme {
  /// 主题数据
  static ThemeData get theme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      surface: AppColors.surface,
    ),
    scaffoldBackgroundColor: AppColors.surface,
    useMaterial3: true,
    fontFamily: AppFonts.primary,
    textTheme: AppTextStyles.theme,
    appBarTheme: AppComponentStyles.appBarTheme,
    cardTheme: AppComponentStyles.cardTheme,
    checkboxTheme: AppComponentStyles.checkboxTheme,
    inputDecorationTheme: AppComponentStyles.inputTheme,
    iconTheme: AppComponentStyles.iconTheme,
  );

  /// Snackbar 主题配置
  static final snackbarTheme = {
    'success': const SnackbarConfig(
      backgroundColor: Color(0xFFE8F5E9),
      textColor: Color(0xFF1B5E20),
      icon: Icons.check_circle,
      iconColor: Color(0xFF1B5E20),
    ),
    'error': const SnackbarConfig(
      backgroundColor: Color(0xFFFFEBEE),
      textColor: Color(0xFFB71C1C),
      icon: Icons.error,
      iconColor: Color(0xFFB71C1C),
    ),
    'info': const SnackbarConfig(
      backgroundColor: Color(0xFFE3F2FD),
      textColor: Color(0xFF0D47A1),
      icon: Icons.info,
      iconColor: Color(0xFF0D47A1),
    ),
  };

  /// Snackbar 通用样式
  static const snackbarStyle = SnackbarStyle(
    margin: EdgeInsets.all(8),
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    borderRadius: 8.0,
    titleSize: 16.0,
    messageSize: 14.0,
    iconSize: 28.0,
    duration: Duration(seconds: 2),
  );
}

/// 应用颜色配置
class AppColors {
  static const MaterialColor primary = Colors.blue;
  static const Color surface = Color(0xFFF5F9FF);
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF34495E);
  static const Color cardBackground = Colors.white;
  static const Color chatUserBackground = Color(0xFFE3F2FD);
  static const Color chatAiBackground = Color(0xFFF5F5F5);
  static const Color iconColor = Color(0xFF2196F3);
  static const Color hintText = Colors.grey;
}

/// 字体配置
class AppFonts {
  static const String primary = 'Roboto';
  static const List<String> fallback = [
    'Microsoft YaHei',
    'Heiti SC',
    'sans-serif'
  ];
}

/// 文本样式配置
class AppTextStyles {
  static const TextTheme theme = TextTheme(
    bodyLarge: TextStyle(
      fontFamilyFallback: AppFonts.fallback,
      color: AppColors.textPrimary,
    ),
    bodyMedium: TextStyle(
      fontFamilyFallback: AppFonts.fallback,
      color: AppColors.textSecondary,
    ),
  );
}

/// 组件样式配置
abstract class AppComponentStyles {
  /// AppBar 样式
  static const appBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: true,
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
  );

  /// Card 样式
  static final cardTheme = CardTheme(
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    color: AppColors.cardBackground,
  );

  /// Checkbox 样式
  static final checkboxTheme = CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith<Color>((states) {
      return states.contains(WidgetState.selected)
          ? AppColors.primary
          : Colors.transparent;
    }),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
  );

  /// Input 样式
  static const inputTheme = InputDecorationTheme(
    border: InputBorder.none,
    hintStyle: TextStyle(color: AppColors.hintText),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );

  /// Icon 样式
  static const iconTheme = IconThemeData(
    color: AppColors.iconColor,
    size: 24,
  );
}

/// Snackbar 配置
class SnackbarConfig {
  final Color backgroundColor;
  final Color textColor;
  final IconData icon;
  final Color iconColor;

  const SnackbarConfig({
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
    required this.iconColor,
  });
}

/// Snackbar 通用样式配置
class SnackbarStyle {
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double borderRadius;
  final double titleSize;
  final double messageSize;
  final double iconSize;
  final Duration duration;

  const SnackbarStyle({
    required this.margin,
    required this.padding,
    required this.borderRadius,
    required this.titleSize,
    required this.messageSize,
    required this.iconSize,
    required this.duration,
  });
} 
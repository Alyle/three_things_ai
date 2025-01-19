import 'package:flutter/material.dart';

/// 应用主题配置
class AppTheme {
  /// 主题色
  static const Color primary = Color(0xFF1E88E5);
  static const Color primaryLight = Color(0xFFE3F2FD);
  static const Color primaryDark = Color(0xFF1565C0);
  
  /// 文本颜色
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textHint = Color(0xFF999999);
  
  /// 背景颜色
  static const Color background = Colors.white;
  static const Color cardBackground = Color(0xFFF5F5F5);
  static const Color chatUserBackground = Color(0xFFE3F2FD);
  static const Color chatAiBackground = Color(0xFFF5F5F5);
  
  /// 边框颜色
  static const Color border = Color(0xFFEEEEEE);
  
  /// 间距
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  
  /// 圆角
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  
  /// 字体大小
  static const double fontSizeXS = 12.0;
  static const double fontSizeS = 14.0;
  static const double fontSizeM = 16.0;
  static const double fontSizeL = 18.0;
  static const double fontSizeXL = 20.0;
  
  /// 卡片样式
  static final cardDecoration = BoxDecoration(
    color: background,
    borderRadius: BorderRadius.circular(radiusM),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withAlpha(13),  // 0.05 * 255 ≈ 13
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
  
  /// 按钮样式
  static final buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryLight,
    foregroundColor: primaryDark,
    elevation: 0,
    padding: const EdgeInsets.symmetric(
      horizontal: spacingM,
      vertical: spacingS,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusL),
      side: const BorderSide(color: primary),
    ),
  );
  
  /// 输入框样式
  static final inputDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusM),
      borderSide: const BorderSide(color: border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusM),
      borderSide: const BorderSide(color: border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusM),
      borderSide: const BorderSide(color: primary),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: spacingM,
      vertical: spacingS,
    ),
  );
  
  /// 聊天消息样式
  static const chatMessageStyle = TextStyle(
    fontSize: fontSizeM,
    color: textPrimary,
  );
  
  static const chatStatsStyle = TextStyle(
    fontSize: fontSizeXS,
    color: textSecondary,
  );
  
  /// 获取主题数据
  static ThemeData get theme => ThemeData(
    primaryColor: primary,
    scaffoldBackgroundColor: background,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryLight,
      foregroundColor: primaryDark,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: buttonStyle,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusM),
        borderSide: const BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusM),
        borderSide: const BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusM),
        borderSide: const BorderSide(color: primary),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacingM,
        vertical: spacingS,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        fontSize: fontSizeM,
        color: textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: fontSizeS,
        color: textSecondary,
      ),
      labelLarge: TextStyle(
        fontSize: fontSizeS,
        color: textPrimary,
        fontWeight: FontWeight.bold,
      ),
    ),
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
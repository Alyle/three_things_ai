import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get theme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      surface: AppColors.surface,
    ),
    scaffoldBackgroundColor: AppColors.surface,
    useMaterial3: true,
    fontFamily: AppFonts.primaryFont,
    textTheme: AppTextStyles.textTheme,
    appBarTheme: AppBarStyles.theme,
    cardTheme: AppCardStyles.theme,
    checkboxTheme: AppCheckboxStyles.theme,
    inputDecorationTheme: AppInputStyles.theme,
    iconTheme: AppIconStyles.theme,
  );
}

class AppColors {
  static const MaterialColor primary = Colors.blue;
  static const Color surface = Color(0xFFF5F9FF);
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF34495E);
  static const Color cardBackground = Colors.white;
  static const Color error = Colors.red;
  static const Color success = Colors.green;
  static const Color chatUserBackground = Color(0xFFE3F2FD);
  static const Color chatAiBackground = Color(0xFFF5F5F5);
  static const Color iconColor = Color(0xFF2196F3);
  static const Color hintText = Colors.grey;
}

class AppFonts {
  static const String primaryFont = 'Roboto';
  static const List<String> fallbackFonts = [
    'Microsoft YaHei',
    'Heiti SC',
    'sans-serif'
  ];
}

class AppTextStyles {
  static const TextTheme textTheme = TextTheme(
    bodyLarge: TextStyle(
      fontFamilyFallback: AppFonts.fallbackFonts,
      color: AppColors.textPrimary,
    ),
    bodyMedium: TextStyle(
      fontFamilyFallback: AppFonts.fallbackFonts,
      color: AppColors.textSecondary,
    ),
  );
}

class AppBarStyles {
  static const AppBarTheme theme = AppBarTheme(
    elevation: 0,
    centerTitle: true,
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
  );
}

class AppCardStyles {
  static final CardTheme theme = CardTheme(
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    color: AppColors.cardBackground,
  );
}

class AppCheckboxStyles {
  static final CheckboxThemeData theme = CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primary;
      }
      return Colors.transparent;
    }),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
  );
}

class AppInputStyles {
  static const InputDecorationTheme theme = InputDecorationTheme(
    border: InputBorder.none,
    hintStyle: TextStyle(color: AppColors.hintText),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );
}

class AppIconStyles {
  static const IconThemeData theme = IconThemeData(
    color: AppColors.iconColor,
    size: 24,
  );
} 
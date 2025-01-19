import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/app_theme.dart';

class NotificationService {
  static void success(String message) {
    final config = AppTheme.snackbarTheme['success']!;
    _showSnackbar(
      title: '成功',
      message: message,
      config: config,
    );
  }

  static void error(String message) {
    final config = AppTheme.snackbarTheme['error']!;
    _showSnackbar(
      title: '错误',
      message: message,
      config: config,
    );
  }

  static void info(String title, String message) {
    final config = AppTheme.snackbarTheme['info']!;
    _showSnackbar(
      title: title,
      message: message,
      config: config,
    );
  }

  static void _showSnackbar({
    required String title,
    required String message,
    required SnackbarConfig config,
  }) {
    const style = AppTheme.snackbarStyle;

    Get.rawSnackbar(
      title: title,
      message: message,
      duration: style.duration,
      backgroundColor: config.backgroundColor,
      barBlur: 0,
      overlayBlur: 0,
      snackStyle: SnackStyle.FLOATING,
      titleText: Text(
        title,
        style: TextStyle(
          color: config.textColor,
          fontWeight: FontWeight.bold,
          fontSize: style.titleSize,
        ),
      ),
      messageText: Text(
        message,
        style: TextStyle(
          color: config.textColor,
          fontSize: style.messageSize,
        ),
      ),
      snackPosition: SnackPosition.TOP,
      margin: style.margin,
      padding: style.padding,
      borderRadius: style.borderRadius,
      icon: Icon(
        config.icon,
        color: config.iconColor,
        size: style.iconSize,
      ),
    );
  }
} 
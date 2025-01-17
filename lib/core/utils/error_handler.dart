import 'package:get/get.dart';

class AppErrorHandler {
  static void handleError(dynamic error, {String? message}) {
    Get.snackbar(
      '错误',
      message ?? '操作失败，请稍后重试',
      duration: const Duration(seconds: 2),
    );
  }
} 
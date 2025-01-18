import '../../services/notification_service.dart';

class AppErrorHandler {
  static void handleError(dynamic error, {String? message}) {
    NotificationService.error(message ?? '操作失败，请稍后重试');
  }
} 
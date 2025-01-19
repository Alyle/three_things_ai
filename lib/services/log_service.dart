import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart';
import '../core/utils/date_time_util.dart';
import '../core/config/environment_config.dart';
import '../core/config/app_config.dart';

/// 日志服务：负责记录和管理应用程序日志
class LogService {
  static const String _logDir = 'logs';
  late final String _logPath;
  File? _currentLogFile;  // 改为可空
  
  /// 初始化日志服务
  Future<void> init(String documentsPath) async {
    try {
      if (EnvironmentConfig.isWeb) {
        _logPath = AppConfig.path.webLogsPath;
        // Web环境下不创建文件
        return;
      }

      // 原生平台创建日志文件
      _logPath = path.join(documentsPath, _logDir);
      final logDir = Directory(_logPath);
      if (!await logDir.exists()) {
        await logDir.create(recursive: true);
      }

      final today = DateTimeUtil.formatDate(DateTime.now());
      _currentLogFile = File(path.join(_logPath, '$today.log'));
      if (!await _currentLogFile!.exists()) {
        await _currentLogFile!.create();
      }

      // 记录启动日志
      info('应用程序启动');
    } catch (e) {
      debugPrint('初始化日志服务失败: $e');
    }
  }

  /// 记录信息日志
  Future<void> info(String message) async {
    await _writeLog('INFO', message);
  }

  /// 记录警告日志
  Future<void> warning(String message) async {
    await _writeLog('WARN', message);
  }

  /// 记录错误日志
  Future<void> error(String message, [dynamic error, StackTrace? stackTrace]) async {
    final errorMsg = error != null ? '$message\nError: $error' : message;
    final fullMsg = stackTrace != null ? '$errorMsg\n$stackTrace' : errorMsg;
    await _writeLog('ERROR', fullMsg);
  }

  /// 写入日志
  Future<void> _writeLog(String level, String message) async {
    if (EnvironmentConfig.isWeb) {
      // Web环境下使用console
      debugPrint('[$level] $message');
      return;
    }

    try {
      if (_currentLogFile != null) {
        final timestamp = DateTimeUtil.format(DateTime.now());
        final logEntry = '[$timestamp] $level: $message\n';
        await _currentLogFile!.writeAsString(
          logEntry,
          mode: FileMode.append,
        );
      }
    } catch (e) {
      debugPrint('写入日志失败: $e');
    }
  }

  /// 清理过期日志（保留最近30天）
  Future<void> cleanOldLogs() async {
    try {
      final logDir = Directory(_logPath);
      final files = await logDir.list().toList();
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));

      for (var file in files) {
        if (file is File) {
          final fileName = path.basename(file.path);
          final dateStr = fileName.replaceAll('.log', '');
          try {
            final fileDate = DateTime.parse(dateStr);
            if (fileDate.isBefore(thirtyDaysAgo)) {
              await file.delete();
              debugPrint('删除过期日志: ${file.path}');
            }
          } catch (e) {
            debugPrint('解析日志文件日期失败: $fileName');
          }
        }
      }
    } catch (e) {
      debugPrint('清理过期日志失败: $e');
    }
  }
} 
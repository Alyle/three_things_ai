import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart';
import 'package:idb_shim/idb_browser.dart' if (dart.library.io) 'package:idb_shim/idb_io.dart';
import '../core/utils/date_time_util.dart';
import '../core/config/environment_config.dart';

/// 日志服务：负责记录和管理应用程序日志
class LogService {
  static const String _logDir = 'logs';
  static const String _storeName = 'logs';
  late final String _logPath;
  File? _currentLogFile;
  
  // 引用已存在的数据库
  final Database? _db;
  
  LogService(this._db);  // 通过构造函数注入数据库实例

  /// 初始化日志服务
  Future<void> init(String documentsPath) async {
    try {
      if (EnvironmentConfig.isWeb) {
        // Web环境下不需要额外初始化，store已在数据库创建时设置
      } else {
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
      }

      await info('应用程序启动');
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
    final timestamp = DateTimeUtil.format(DateTime.now());
    final logEntry = '[$timestamp] $level: $message\n';

    try {
      if (EnvironmentConfig.isWeb) {
        if (_db != null) {
          final txn = _db.transaction(_storeName, 'readwrite');
          final store = txn.objectStore(_storeName);
          await store.add({
            'timestamp': timestamp,
            'level': level,
            'message': message,
            'entry': logEntry
          });
          await txn.completed;
        }
      } else if (_currentLogFile != null) {
        await _currentLogFile!.writeAsString(
          logEntry,
          mode: FileMode.append,
        );
      }
      debugPrint(logEntry);
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
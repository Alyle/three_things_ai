import 'dart:convert';
import 'package:flutter/foundation.dart';

/// JSON修正工具类：用于处理和修正AI返回的JSON字符串
class JsonFixer {
  /// 修正并解析JSON字符串
  /// 返回修正后的JSON对象，如果修正失败则返回null
  static Map<String, dynamic>? fixAndParseJson(String jsonString) {
    try {
      // 尝试直接解析
      return jsonDecode(jsonString);
    } catch (e) {
      debugPrint('开始修正JSON: $jsonString');
      var fixed = jsonString;
      
      // 1. 删除代码块标记
      fixed = fixed.replaceAll(RegExp(r'^```\w*\s*'), '');  // 删除开头的 ```json
      fixed = fixed.replaceAll(RegExp(r'\s*```$'), '');     // 删除结尾的 ```
      
      // 2. 删除注释
      fixed = fixed.replaceAll(RegExp(r'//.*'), '');  // 删除单行注释
      fixed = fixed.replaceAll(RegExp(r'/\*.*?\*/', dotAll: true), '');  // 删除多行注释
      
      // 3. 处理换行符和空白字符
      fixed = fixed.replaceAll(RegExp(r'\s*\n\s*'), ' ');  // 换行替换为空格
      fixed = fixed.replaceAll(RegExp(r'\s+'), ' ');      // 多个空白替换为单个
      
      // 4. 提取第一个完整的JSON对象
      final firstObjectStart = fixed.indexOf('{');
      final firstObjectEnd = fixed.lastIndexOf('}');
      if (firstObjectStart != -1 && firstObjectEnd != -1) {
        fixed = fixed.substring(firstObjectStart, firstObjectEnd + 1);
      }
      
      // 5. 最终清理
      fixed = fixed.trim();

      try {
        debugPrint('修正后的JSON: $fixed');
        return jsonDecode(fixed);
      } catch (e) {
        debugPrint('JSON修正失败: $e');
        return null;
      }
    }
  }
} 
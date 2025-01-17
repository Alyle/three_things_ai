// 导入必要的包
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/goal_controller.dart';
import 'views/main_navigation.dart';
import 'services/storage_service.dart';
import 'theme/app_theme.dart';  // 新增主题配置文件

// 应用程序入口点
Future<void> main() async {
  try {
    // 确保 Flutter 绑定初始化
    WidgetsFlutterBinding.ensureInitialized();
    
    // 初始化服务
    final StorageService storageService = await StorageService().init();
    
    // 初始化控制器
    Get.put<GoalController>(GoalController(storageService));
    
    // 启动应用程序
    runApp(const MyApp());
  } catch (error) {
    debugPrint('应用程序初始化失败: $error');
    rethrow;
  }
}

// 应用程序根组件
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '三件事AI助手',
      theme: AppTheme.lightTheme,  // 只使用浅色主题
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fade,
      home: MainNavigation(),
    );
  }
} 
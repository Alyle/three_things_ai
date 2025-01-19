// 导入必要的包
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/goal_controller.dart';
import 'views/navigation/main_navigation.dart';
import 'services/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'core/config/app_config.dart';
import 'controllers/user_controller.dart';


// 应用程序入口点
Future<void> main() async {
  try {
    // 确保 Flutter 绑定初始化
    WidgetsFlutterBinding.ensureInitialized();
    
    // 初始化存储服务
    final storageService = StorageService();
    await storageService.init();
    
    // 初始化日志服务
    final logService = storageService.logService;
    Get.put(logService);  // 注入日志服务以供全局访问
    
    // 记录应用启动日志
    if (AppConfig.features.enableLogging) {
      await logService.info('应用程序启动');
    }
    
    // 初始化控制器
    Get.put<UserController>(UserController(storageService));
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
      theme: AppTheme.theme,  // 使用新的 theme getter
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fade,
      home: MainNavigation(),
    );
  }
} 
// 导入必要的包
import 'package:flutter/material.dart';      // Flutter Material Design 组件
import 'package:get/get.dart';              // GetX 状态管理
import 'controllers/goal_controller.dart';   // 目标管理控制器
import 'views/main_navigation.dart';        // 主导航页面
import 'services/storage_service.dart';

// 应用程序入口点
void main() async {
  // 确保 Flutter 绑定初始化，这对于平台通道和异步操作是必需的
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化服务
  final storageService = await StorageService().init();

  
  // 初始化控制器
  Get.put(GoalController(storageService));
 

  // 启动应用程序，MyApp 作为根组件
  runApp(const MyApp());
}

// 应用程序根组件
class MyApp extends StatelessWidget {
  // 构造函数，使用 super.key 传递键值给父类
  const MyApp({super.key});

  // 构建应用程序的用户界面
  @override
  Widget build(BuildContext context) {
    // 返回 GetMaterialApp，这是 GetX 版本的 MaterialApp
    return GetMaterialApp(
      title: '三件事AI助手',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontFamilyFallback: ['Microsoft YaHei', 'Heiti SC', 'sans-serif'],
          ),
          bodyMedium: TextStyle(
            fontFamilyFallback: ['Microsoft YaHei', 'Heiti SC', 'sans-serif'],
          ),
        ),
      ),
      home: MainNavigation(),
    );
  }
} 
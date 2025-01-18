import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../pages/home/home_page.dart';
import '../pages/chat/chat_page.dart';
import '../../controllers/navigation_controller.dart';

class MainNavigation extends StatelessWidget {
  MainNavigation({super.key}) {
    Get.put(NavigationController());
  }

  final _pages = [
    const HomePage(),
    ChatPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavigationController>(
      builder: (controller) => Scaffold(
        body: IndexedStack(
          index: controller.currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentIndex,
          onTap: controller.changePage,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline),
              label: '目标',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: 'AI助手',
            ),
          ],
          selectedItemColor: Colors.blue[900],
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }
} 
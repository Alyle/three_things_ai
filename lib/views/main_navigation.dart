import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_page.dart';
import 'chat_page.dart';

class MainNavigation extends StatelessWidget {
  final _currentIndex = 0.obs;
  final _pages = [
    HomePage(),
    ChatPage(),
  ];

  MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _pages[_currentIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: _currentIndex.value,
          onTap: (index) => _currentIndex.value = index,
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
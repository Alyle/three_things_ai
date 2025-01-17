import 'package:get/get.dart';

class NavigationController extends GetxController {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void changePage(int index) {
    _currentIndex = index;
    update();
  }
} 
import 'package:get/get.dart';

class NavigationController extends GetxController {
  int currentIndex = 0;

  void changePage(int index) {
    currentIndex = index;
    update();
  }
} 
// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.


import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:three_things_ai/main.dart';
import 'package:three_things_ai/controllers/goal_controller.dart';
import 'package:three_things_ai/services/storage_service.dart';

void main() {
  testWidgets('App test', (WidgetTester tester) async {
    final storageService = await StorageService().init();
    Get.put(GoalController(storageService));
    await tester.pumpWidget(const MyApp());
    
    expect(find.text('三件事'), findsOneWidget);
  });
}

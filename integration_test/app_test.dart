import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'test_main.dart' as test_app;

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => null);

  testWidgets(
    'Creating task',
    (widgetTester) async {
      test_app.main();
      await widgetTester.pumpAndSettle();
      await widgetTester.pumpAndSettle(const Duration(seconds: 3));
      await widgetTester.tap(find.text('Download list from backend').last);
      await widgetTester.pumpAndSettle();
      await widgetTester.pumpAndSettle(const Duration(seconds: 3));
      await widgetTester.tap(find.text('Add').last);
      await widgetTester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 3));
      await widgetTester.enterText(find.byType(TextField), 'Unique testing task');
      await widgetTester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 3));
      await widgetTester.tap(find.text('Save'));
      await widgetTester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 3));
      expect(find.text('Unique testing task'), findsWidgets);
    },
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tipcalcpro/main.dart';

void main() {
  // Setup mock SharedPreferences
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Initial app renders correctly', (WidgetTester tester) async {
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(TipCalcPro(prefs: prefs, darkMode: false));

    expect(find.text('TipCalcPro+'), findsOneWidget);
    expect(find.text('Total Per Person'), findsOneWidget);
    expect(find.text('\$0.00'), findsOneWidget); // Initial total per person
    expect(find.text('Bill Amount'), findsOneWidget);
  });

  testWidgets('Bill amount input updates calculation', (WidgetTester tester) async {
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(TipCalcPro(prefs: prefs, darkMode: false));

    await tester.enterText(find.byType(TextField), '100');
    await tester.pump();

    expect(find.text('\$115.00'), findsOneWidget); // Total per person
    expect(find.text('\$15.00'), findsOneWidget); // Tip amount
  });

  testWidgets('Changing tip percentage updates calculation', (WidgetTester tester) async {
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(TipCalcPro(prefs: prefs, darkMode: false));

    await tester.enterText(find.byType(TextField), '100');
    await tester.pump();

    await tester.tap(find.text('20%'));
    await tester.pump();

    expect(find.text('\$120.00'), findsOneWidget); // Total per person with 20% tip
  });

  testWidgets('Changing split count updates calculation', (WidgetTester tester) async {
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(TipCalcPro(prefs: prefs, darkMode: false));

    await tester.enterText(find.byType(TextField), '100');
    await tester.pump();

    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pump();

    expect(find.text('\$38.33'), findsOneWidget); // Total per person (115 / 3)
  });
}

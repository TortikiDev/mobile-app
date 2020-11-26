import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../make_testable_widget.dart';
import 'test_bottom_navigation_constoller_factory.dart';

void main() {
  testWidgets('Bottom navigation controller smoke test', (tester) async {
    final bottomNavControllerFactory = TestBottomNaigationControllerFactory();
    await tester.pumpWidget(
        makeTestableWidget(child: bottomNavControllerFactory.createWidget()));
    await tester.pumpAndSettle();
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    await tester.tap(find.byIcon(Icons.location_pin));
    await tester.tap(find.byIcon(Icons.bookmark));
    await tester.tap(find.byIcon(Icons.account_circle));
    await tester.tap(find.byKey(ValueKey('cherry icon')));
  });
}

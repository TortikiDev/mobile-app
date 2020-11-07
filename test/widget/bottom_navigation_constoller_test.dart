import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:tortiki/ui/bottom_navigation/bottom_navigation_controller.dart';
import 'make_testable_widget.dart';

void main() {
  testWidgets('Bottom navigation controller smoke test', (tester) async {
    await tester
        .pumpWidget(makeTestableWidget(child: BottomNaigationController()));
    await tester.pumpAndSettle();
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    await tester.tap(find.byIcon(Icons.location_pin));
    await tester.tap(find.byIcon(Icons.bookmark));
    await tester.tap(find.byIcon(Icons.account_circle));
    await tester.tap(find.byKey(ValueKey('cherry icon')));
  });
}

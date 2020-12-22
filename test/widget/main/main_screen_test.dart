import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:tortiki/app_localizations.dart';
import '../make_testable_widget.dart';
import 'test_main_screen_factory.dart';

void main() {
  testWidgets('Main screen smoke test', (tester) async {
    final localizations = AppLocalizations('en');
    final mainScreen = TestMainScreenFactory().createWidget();
    await tester.pumpWidget(makeTestableWidget(child: mainScreen));
    await tester.pumpAndSettle();
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(TabBar), findsOneWidget);
    await tester.tap(find.text(localizations.recipes.toUpperCase()));
    await tester.tap(find.text(localizations.feed.toUpperCase()));
    expect(find.byType(ListView), findsOneWidget);
  });
}

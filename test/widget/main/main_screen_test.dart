import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:tortiki/app_localizations.dart';
import 'package:tortiki/ui/reusable/in_develop_screen_factory.dart';
import 'package:tortiki/ui/screens/main/main_screen.dart';
import '../make_testable_widget.dart';
import 'test_feed_screen_factory.dart';

void main() {
  testWidgets('Main screen smoke test', (tester) async {
    final localizations = AppLocalizations('en');
    // TODO: use actual factory for recipesScreenFactory
    final mainScreen = MainScreen(
        feedScreenFactory: TestFeedScreenFactory(),
        recipesScreenFactory: InDevelopWidgetFactory());
    await tester.pumpWidget(makeTestableWidget(child: mainScreen));
    await tester.pumpAndSettle();
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(TabBar), findsOneWidget);
    await tester.tap(find.text(localizations.recipes.toUpperCase()));
    await tester.tap(find.text(localizations.feed.toUpperCase()));
    expect(find.byType(ListView), findsOneWidget);
  });
}

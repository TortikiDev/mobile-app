import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:tortiki/ui/reusable/search_bar.dart';
import 'package:tortiki/ui/screens/main/feed/feed_screen.dart';
import 'package:tortiki/ui/screens/main/recipes/recipes_screen.dart';
import 'package:tortiki/ui/screens/main/search_recipes/search_recipes_screen.dart';
import '../make_testable_widget.dart';
import 'test_main_screen_factory.dart';

void main() {
  testWidgets('Main screen smoke test', (tester) async {
    final localizations = AppLocalizationsEn();
    final mainScreen = TestMainScreenFactory().createWidget();
    await tester.pumpWidget(makeTestableWidget(child: mainScreen));
    await tester.pumpAndSettle();
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(TabBar), findsOneWidget);

    expect(find.byType(FeedScreen), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    await tester.tap(find.text(localizations.recipes.toUpperCase()));
    await tester.pumpAndSettle();
    expect(find.byType(RecipesScreen), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    await tester.tap(find.text(localizations.feed.toUpperCase()));
    await tester.pumpAndSettle();

    await tester.tap(find.text(localizations.recipes.toUpperCase()));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('Search recipes')));
    await tester.pumpAndSettle();
    expect(find.byType(SearchRecipesScreen), findsOneWidget);
    expect(find.byType(SearchBar), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);

    await tester.tap(find.byKey(Key('Back button')));
    await tester.pumpAndSettle();
    expect(find.byType(RecipesScreen), findsOneWidget);
  });
}

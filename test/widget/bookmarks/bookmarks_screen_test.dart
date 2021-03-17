import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:tortiki/ui/screens/main/recipes/recipe/recipe_view.dart';
import '../make_testable_widget.dart';
import 'test_bookmarks_screen_factory.dart';

void main() {
  testWidgets('Bookmarks screen smoke test', (tester) async {
    final bookmarksScreenFactory = TestBookmarksScreenFactory();
    await tester.pumpWidget(
        makeTestableWidget(child: bookmarksScreenFactory.createWidget()));
    await tester.pumpAndSettle();
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(RecipeView), findsNWidgets(2));
  });
}

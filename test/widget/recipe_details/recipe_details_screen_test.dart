import 'package:flutter_test/flutter_test.dart';
import 'package:tortiki/ui/screens/recipe_details/recipe_header/recipe_header.dart';
import 'package:tortiki/ui/screens/recipe_details/vote_widget.dart';
import '../make_testable_widget.dart';
import 'test_recipe_details_screen_factory.dart';

void main() {
  testWidgets('Recipe details screen smoke test', (tester) async {
    final bookmarksScreenFactory = TestRecipeDetailsScreeFactory();
    await tester.pumpWidget(
        makeTestableWidget(child: bookmarksScreenFactory.createWidget()));
    await tester.pumpAndSettle();
    expect(find.byType(RecipeHeader), findsOneWidget);
    expect(find.byType(VoteWidget), findsOneWidget);
  });
}

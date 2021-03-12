import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import '../../make_testable_widget.dart';
import 'test_create_recipe_screen_factory.dart';

void main() {
  testWidgets('Create recipe smoke test', (tester) async {
    final localizations = AppLocalizationsEn();
    await tester.pumpWidget(makeTestableWidget(
        child: TestCreateRecipeScreenFactory().createWidget()));
    await tester.pumpAndSettle();

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(TabBar), findsNothing);
    expect(find.text(localizations.newRecipe), findsOneWidget);
    expect(find.text(localizations.name), findsOneWidget);
    expect(find.text(localizations.complexityAndDescription), findsOneWidget);
    expect(find.text(localizations.ingredients), findsOneWidget);
    expect(find.text(localizations.cooking), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, '123');
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import '../../make_testable_widget.dart';
import 'test_create_post_screen_factory.dart';

void main() {
  testWidgets('Create post smoke test', (tester) async {
    final localizations = AppLocalizationsEn();
    await tester.pumpWidget(makeTestableWidget(
        child: TestCreatePostScreenFactory().createWidget()));
    await tester.pumpAndSettle();

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(TabBar), findsNothing);
    expect(find.text(localizations.newPost), findsOneWidget);
    expect(find.text(localizations.photo), findsOneWidget);
    expect(find.text(localizations.description), findsOneWidget);
    await tester.enterText(find.byType(TextField), '123');
  });
}

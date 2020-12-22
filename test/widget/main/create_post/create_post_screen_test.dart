import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:tortiki/app_localizations.dart';
import '../../make_testable_widget.dart';
import 'test_create_post_screen_factory.dart';

void main() {
  testWidgets('Create post smoke test', (tester) async {
    final localizations = AppLocalizations('en');
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

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:tortiki/data/http_client/responses/responses.dart';
import 'package:tortiki/ui/reusable/image_views/avatar.dart';
import 'package:tortiki/ui/screens/profile/external_confectioner_profile/external_confectioner_profile_screen_factory.dart';
import '../make_testable_widget.dart';
import 'test_external_confectioner_profile_screen_factory.dart';

void main() {
  testWidgets('Exteranl confectioner profile screen smoke test',
      (tester) async {
    final screenFactory = TestExternalConfectionerProfileScreenFactory();
    final screenData = ExternalConfectionerProfileScreenFactoryData(
      confectionerId: 123,
      confectionerName: 'name',
      confectionerGender: Gender.male,
    );
    await tester.pumpWidget(makeTestableWidget(
        child: screenFactory.createWidget(data: screenData)));
    final localizations = AppLocalizationsEn();
    await tester.pumpAndSettle();
    expect(find.byType(CustomScrollView), findsOneWidget);
    expect(find.byType(Avatar), findsOneWidget);
    expect(find.text(localizations.publications), findsOneWidget);
    expect(find.text(localizations.recipes), findsOneWidget);
  });
}

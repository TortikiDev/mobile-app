import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../app_localizations.dart';
import 'app_theme.dart';
import 'bottom_navigation/bottom_navigation_controller.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tortiki',
      theme: appTheme,
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('ru'),
      ],
      // TODO: use device locale
      home: BottomNaigationController(localizations: AppLocalizations('ru')),
    );
  }
}

import 'package:flutter/material.dart';

import '../app_localizations.dart';
import 'app_theme.dart';
import 'bottom_navigation/bottom_navigation_controller.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tortiki',
      theme: appTheme,
      home: BottomNaigationController(localizations: AppLocalizations('ru')),
    );
  }
}

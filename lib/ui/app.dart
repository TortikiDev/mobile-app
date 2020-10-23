import 'package:flutter/material.dart';

import '../app_localizations.dart';
import 'bottom_navigation/bottom_navigation_controller.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tortiki',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedItemColor: Colors.deepOrange[200],
              unselectedItemColor: Colors.amber[200])),
      home: BottomNaigationController(localizations: AppLocalizations('ru')),
    );
  }
}

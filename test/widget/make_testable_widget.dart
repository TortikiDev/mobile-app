import 'package:tortiki/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tortiki/ui/app_theme.dart';

Widget makeTestableWidget({ Widget child }) {
  return MediaQuery(
    data: MediaQueryData(),
    child: MaterialApp(
      theme: appTheme,
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en')
      ],
      home: child,
    ),
  );
}
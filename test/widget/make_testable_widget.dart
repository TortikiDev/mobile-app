import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:tortiki/ui/app_theme.dart';

Widget makeTestableWidget({Widget? child}) {
  return MediaQuery(
    data: MediaQueryData(),
    child: MaterialApp(
      theme: appTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: [Locale('en')],
      home: child,
    ),
  );
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'l10n/messages_all.dart';

//
// https://pub.dev/packages/intl - package used to localize strings.
// To add localized strings:
//
// 1. Add newlines here to app_localizations.dart (as described
// in intl documentation)
//
// 2. Run the command in the terminal to generate a template file .abr:
//
//    flutter pub run intl_translation:extract_to_arb \
//      --output-dir=lib/l10n lib/app_localizations.dart
//
// 3. Add new translations according to the generated template
// to intl _ *. Arb files for each language.
//
// 4. Run the command in the terminal to generate localizations:
//
// flutter pub run intl_translation:generate_from_arb \
//     --output-dir=lib/l10n --no-use-deferred-loading \
//     lib/app_localizations.dart lib/l10n/intl_*.arb
//

class AppLocalizations {
  AppLocalizations(this.localeName);

  static Future<AppLocalizations> load(Locale locale) {
    final name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      return AppLocalizations(localeName);
    });
  }

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations);

  final String localeName;

  // region General

  String get ok => Intl.message('OK', name: 'ok', locale: localeName);

  String get error => Intl.message('Error', name: 'error', locale: localeName);

  // endregion

  // region Errors

  String get somethingWentWrong => Intl.message('Something went wrong',
      name: 'somethingWentWrong', locale: localeName);

  String get serverIsNotAvailable => Intl.message('Server is not available',
      name: 'serverIsNotAvailable', locale: localeName);

  String get connectionTimeout => Intl.message('Connection timeout',
      name: 'connectionTimeout', locale: localeName);

  String get connectionError => Intl.message('Connection error',
      name: 'connectionError', locale: localeName);

  String get apiResponseParsingError =>
      Intl.message('Response parsing error. Please contact support',
          name: 'apiResponseParsingError', locale: localeName);

  String get badRequest =>
      Intl.message('Bad request', name: 'badRequest', locale: localeName);

  String get authorizationError => Intl.message('Authorization error',
      name: 'authorizationError', locale: localeName);

  String get forbidder =>
      Intl.message('Forbidden', name: 'forbidder', locale: localeName);

  String get resourceNotFound => Intl.message('Resource not found',
      name: 'resourceNotFound', locale: localeName);

  String get methodNotAllowed => Intl.message('Method Not Allowed',
      name: 'methodNotAllowed', locale: localeName);

  String get internalServerError => Intl.message('Internal server error',
      name: 'internalServerError', locale: localeName);

  String get badGateway =>
      Intl.message('Bad Gateway', name: 'badGateway', locale: localeName);

  // endregion
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ru'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

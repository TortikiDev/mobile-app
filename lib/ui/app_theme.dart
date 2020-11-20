import 'package:flutter/material.dart';

final appTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: _colorScheme,
    accentColor: _colorScheme.onPrimary,
    canvasColor: _colorScheme.primary,
    textTheme: _textTheme,
    fontFamily: 'Rubik',
    visualDensity: VisualDensity.adaptivePlatformDensity,
    highlightColor: Colors.transparent,
    splashColor: Colors.white30,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme:
        AppBarTheme(color: _colorScheme.primary, brightness: Brightness.light),
    tabBarTheme: TabBarTheme(
        indicator: UnderlineTabIndicator(
            borderSide: BorderSide(width: 2.0, color: _colorScheme.onPrimary)),
        labelColor: _colorScheme.onPrimary,
        unselectedLabelColor: _colorScheme.primaryVariant,
        labelStyle: _textTheme.button),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: _colorScheme.onPrimary,
        unselectedItemColor: _colorScheme.primaryVariant,
        backgroundColor: _colorScheme.primary));

final _colorScheme = ColorScheme(
    primary: Color(0xFFFEDBD0),
    primaryVariant: Color(0xFFCAA99F),
    secondary: Color(0xFFFEEAE6),
    secondaryVariant: Color(0xFFCBB8B4),
    surface: Colors.white,
    background: Colors.white,
    error: Colors.red,
    onPrimary: Color(0xFFB2404F),
    onSecondary: Color(0xFFB2404F),
    onSurface: Color(0xFF989898),
    onBackground: Colors.black,
    onError: Colors.white,
    brightness: Brightness.light);

final _textTheme = TextTheme(
  headline1: TextStyle(
      fontWeight: FontWeight.w300, fontSize: 96, color: _colorScheme.onPrimary),
  headline2: TextStyle(
      fontWeight: FontWeight.w300, fontSize: 60, color: _colorScheme.onPrimary),
  headline3: TextStyle(
      fontWeight: FontWeight.w400, fontSize: 48, color: _colorScheme.onPrimary),
  headline4: TextStyle(
      fontWeight: FontWeight.w300, fontSize: 30, color: _colorScheme.onPrimary),
  headline5: TextStyle(
      fontWeight: FontWeight.w400, fontSize: 24, color: _colorScheme.onPrimary),
  headline6: TextStyle(
      fontWeight: FontWeight.w500, fontSize: 20, color: _colorScheme.onPrimary),
  subtitle1: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 16,
      color: _colorScheme.onBackground),
  subtitle2: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: _colorScheme.onBackground),
  bodyText1: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 18,
      color: _colorScheme.onBackground),
  bodyText2: TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 14,
      color: _colorScheme.onBackground),
  caption: TextStyle(
      fontWeight: FontWeight.w400, fontSize: 12, color: _colorScheme.onSurface),
  button: TextStyle(
      fontWeight: FontWeight.w500, fontSize: 14, color: _colorScheme.onPrimary),
  overline: TextStyle(
      fontWeight: FontWeight.w500, fontSize: 10, color: _colorScheme.onPrimary),
);

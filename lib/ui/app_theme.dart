import 'package:flutter/material.dart';

final appTheme = ThemeData(
    colorScheme: _colorScheme,
    canvasColor: _colorScheme.primary,
    visualDensity: VisualDensity.adaptivePlatformDensity,
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
    onSurface: Colors.black,
    onBackground: Color(0xFF989898),
    onError: Colors.white,
    brightness: Brightness.light);

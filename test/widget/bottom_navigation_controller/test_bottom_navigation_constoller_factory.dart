import 'package:flutter/material.dart';
import 'package:tortiki/ui/bottom_navigation/bottom_navigation_controller.dart';
import 'package:widget_factory/widget_factory.dart';
import 'package:mocktail/mocktail.dart';

class _MockMainScreenFactory extends Mock implements WidgetFactory {}

class _MockMapScreenFactory extends Mock implements WidgetFactory {}

class _MockBookmarksScreenFactory extends Mock implements WidgetFactory {}

class _MockProfileScreenFactory extends Mock implements WidgetFactory {}

class TestBottomNaigationControllerFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    final mainScreenFactory = _MockMainScreenFactory();
    final mapScreenFactory = _MockMapScreenFactory();
    final bookmarksScreenFactory = _MockBookmarksScreenFactory();
    final profileScreenFactory = _MockProfileScreenFactory();

    when(mainScreenFactory.createWidget).thenReturn(Container());
    when(mapScreenFactory.createWidget).thenReturn(Container());
    when(bookmarksScreenFactory.createWidget).thenReturn(Container());

    return BottomNavigationController(
      mainScreenFactory: mainScreenFactory,
      mapScreenFactory: mapScreenFactory,
      bookmarksScreenFactory: bookmarksScreenFactory,
      profileScreenFactory: profileScreenFactory,
    );
  }
}

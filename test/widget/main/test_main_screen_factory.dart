import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:tortiki/bloc/main/index.dart';
import 'package:widget_factory/widget_factory.dart';
import 'package:tortiki/ui/screens/main/main_screen.dart';

import 'test_feed_screen_factory.dart';
import 'test_recipes_screen_factory.dart';
import 'test_search_recipes_screen_factory.dart';

class _MockMainBloc extends MockBloc<MainState> implements MainBloc {}

class TestMainScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    final mainBloc = _MockMainBloc();
    final mainInitialState = MainState.initial();
    when(mainBloc.state).thenReturn(mainInitialState);
    whenListen(mainBloc, Stream<MainState>.value(mainInitialState));

    return BlocProvider<MainBloc>(
      create: (context) => mainBloc,
      child: MainScreen(
        feedScreenFactory: TestFeedScreenFactory(),
        recipesScreenFactory: TestRecipesScreenFactory(),
        searchRecipesScreenFactory: TestSearchRecipesScreenFactory(),
      ),
    );
  }
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:tortiki/bloc/bottom_navigation_bloc/index.dart';
import 'package:tortiki/bloc/main/index.dart';
import 'package:tortiki/ui/reusable/widget_factory.dart';
import 'package:tortiki/ui/screens/main/main_screen.dart';

import 'test_feed_screen_factory.dart';
import 'test_recipes_screen_factory.dart';
import 'test_search_recipes_screen_factory.dart';

class _MockMainBloc extends MockBloc<MainState> implements MainBloc {}

class _MockBottomNavigationBloc extends MockBloc<BottomNavigationState>
    implements BottomNavigationBloc {}

class TestMainScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    final mainBloc = _MockMainBloc();
    final mainInitialState = MainState.initial();
    when(mainBloc.state).thenReturn(mainInitialState);
    whenListen(mainBloc, Stream<MainState>.value(mainInitialState));

    final bottomNavigationBloc = _MockBottomNavigationBloc();
    final bottomNavigationState = BottomNavigationState.initial();
    when(bottomNavigationBloc.state).thenReturn(bottomNavigationState);
    whenListen(bottomNavigationBloc,
        Stream<BottomNavigationState>.value(bottomNavigationState));

    return MultiBlocProvider(
      providers: [
        BlocProvider<MainBloc>(create: (context) => mainBloc),
        BlocProvider<BottomNavigationBloc>(
            create: (context) => bottomNavigationBloc)
      ],
      child: MainScreen(
        feedScreenFactory: TestFeedScreenFactory(),
        recipesScreenFactory: TestRecipesScreenFactory(),
        searchRecipesScreenFactory: TestSearchRecipesScreenFactory(),
      ),
    );
  }
}

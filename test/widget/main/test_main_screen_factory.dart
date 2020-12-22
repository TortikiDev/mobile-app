import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:tortiki/bloc/main/index.dart';
import 'package:tortiki/ui/reusable/in_develop_screen_factory.dart';
import 'package:tortiki/ui/reusable/widget_factory.dart';
import 'package:tortiki/ui/screens/main/main_screen.dart';

import 'test_feed_screen_factory.dart';

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
      // TODO: use actual factory for recipesScreenFactory
      child: MainScreen(
          feedScreenFactory: TestFeedScreenFactory(),
          recipesScreenFactory: InDevelopWidgetFactory()),
    );
  }
}

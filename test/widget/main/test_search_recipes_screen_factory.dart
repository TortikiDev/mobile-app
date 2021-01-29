import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:tortiki/bloc/search_recipes/index.dart';
import 'package:tortiki/ui/reusable/widget_factory.dart';
import 'package:tortiki/ui/screens/main/search_recipes/search_recipes_screen.dart';

class _MockSearchRecipesBloc extends MockBloc<SearchRecipesState>
    implements SearchRecipesBloc {}

class TestSearchRecipesScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    final feedBloc = _MockSearchRecipesBloc();
    final feedInitialState = SearchRecipesState.initial();
    when(feedBloc.state).thenReturn(feedInitialState);
    whenListen(feedBloc, Stream<SearchRecipesState>.value(feedInitialState));

    return BlocProvider<SearchRecipesBloc>(
      create: (context) => feedBloc,
      child: SearchRecipesScreen(),
    );
  }
}

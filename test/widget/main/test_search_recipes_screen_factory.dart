import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:tortiki/bloc/search_recipes/index.dart';
import 'package:widget_factory/widget_factory.dart';
import 'package:tortiki/ui/screens/main/search_recipes/search_recipes_screen.dart';

class _MockSearchRecipesBloc extends Mock implements SearchRecipesBloc {}

class _MockRecipeDetailsScreenFactory extends Mock implements WidgetFactory {}

class TestSearchRecipesScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    final feedBloc = _MockSearchRecipesBloc();
    final feedInitialState = SearchRecipesState.initial();
    when(feedBloc.state).thenReturn(feedInitialState);
    when(feedBloc.stream).thenAnswer(
        (realInvocation) => Stream<SearchRecipesState>.value(feedInitialState));

    final recipeDetailsScreenFactory = _MockRecipeDetailsScreenFactory();

    return BlocProvider<SearchRecipesBloc>(
      create: (context) => feedBloc,
      child: SearchRecipesScreen(
        recipeDetailsScreenFactory: recipeDetailsScreenFactory,
      ),
    );
  }
}

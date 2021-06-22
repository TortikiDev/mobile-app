import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tortiki/bloc/search_recipes/index.dart';
import 'package:widget_factory/widget_factory.dart';
import 'package:tortiki/ui/screens/main/search_recipes/search_recipes_screen.dart';

class _MockSearchRecipesBloc
    extends MockBloc<SearchRecipesEvent, SearchRecipesState>
    implements SearchRecipesBloc {}

class _MockRecipeDetailsScreenFactory extends Mock implements WidgetFactory {}

class TestSearchRecipesScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    final searchInitialState = SearchRecipesState.initial();
    registerFallbackValue(searchInitialState);
    registerFallbackValue(BlocInit());
    final feedBloc = _MockSearchRecipesBloc();
    when(() => feedBloc.state).thenReturn(searchInitialState);

    final recipeDetailsScreenFactory = _MockRecipeDetailsScreenFactory();

    return BlocProvider<SearchRecipesBloc>(
      create: (context) => feedBloc,
      child: SearchRecipesScreen(
        recipeDetailsScreenFactory: recipeDetailsScreenFactory,
      ),
    );
  }
}

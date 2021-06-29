import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tortiki/bloc/recipes/index.dart';
import 'package:widget_factory/widget_factory.dart';
import 'package:tortiki/ui/screens/main/recipes/recipes_screen.dart';

class _MockRecipesBloc extends MockBloc<RecipesEvent, RecipesState>
    implements RecipesBloc {}

class _MockScreenFactory extends Mock implements WidgetFactory {}

class TestRecipesScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    final feedInitialState = RecipesState.initial();
    registerFallbackValue(feedInitialState);
    registerFallbackValue(BlocInit());
    final feedBloc = _MockRecipesBloc();
    when(() => feedBloc.state).thenReturn(feedInitialState);

    final recipeDetailsScreenFactory = _MockScreenFactory();

    return BlocProvider<RecipesBloc>(
      create: (context) => feedBloc,
      child: RecipesScreen(
        recipeDetailsScreenFactory: recipeDetailsScreenFactory,
      ),
    );
  }
}

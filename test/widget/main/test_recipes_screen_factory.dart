import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tortiki/bloc/recipes/index.dart';
import 'package:widget_factory/widget_factory.dart';
import 'package:tortiki/ui/screens/main/recipes/recipes_screen.dart';

class _MockRecipesBloc extends Mock implements RecipesBloc {}

class _MockScreenFactory extends Mock implements WidgetFactory {}

class TestRecipesScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    final feedBloc = _MockRecipesBloc();
    final feedInitialState = RecipesState.initial();
    when(() => feedBloc.state).thenReturn(feedInitialState);
    when(() => feedBloc.stream).thenAnswer(
        (realInvocation) => Stream<RecipesState>.value(feedInitialState));

    final recipeDetailsScreenFactory = _MockScreenFactory();

    return BlocProvider<RecipesBloc>(
      create: (context) => feedBloc,
      child: RecipesScreen(
        recipeDetailsScreenFactory: recipeDetailsScreenFactory,
      ),
    );
  }
}

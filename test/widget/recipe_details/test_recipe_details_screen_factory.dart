import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tortiki/bloc/recipe_details/index.dart';
import 'package:tortiki/data/http_client/responses/responses.dart';
import 'package:tortiki/ui/screens/recipe_details/recipe_details_screen.dart';
import 'package:widget_factory/widget_factory.dart';

class _MockRecipeDetailsBloc extends Mock implements RecipeDetailsBloc {}

class _MockScreenFactory extends Mock implements WidgetFactory {}

class TestRecipeDetailsScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    final recipe = RecipeResponse(
      id: 1,
      title: '1',
      complexity: 4,
      imageUrls: null,
    );

    final recipeDetailsBloc = _MockRecipeDetailsBloc();
    final recipeDetailsState =
        RecipeDetailsState.initial(recipe: recipe, isInBookmarks: false);
    when(recipeDetailsBloc.state).thenReturn(recipeDetailsState);
    when(recipeDetailsBloc.stream).thenAnswer((realInvocation) =>
        Stream<RecipeDetailsState>.value(recipeDetailsState));

    final confectionerProfileScreenFactory = _MockScreenFactory();

    return BlocProvider<RecipeDetailsBloc>(
      create: (context) => recipeDetailsBloc,
      child: RecipeDetailsScreen(
          confectionerProfileScreenFactory: confectionerProfileScreenFactory),
    );
  }
}

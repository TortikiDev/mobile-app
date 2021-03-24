import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widget_factory/widget_factory.dart';

import '../../../../bloc/error_handling/index.dart';
import '../../../../bloc/recipes/index.dart';
import '../../../../data/repositories/repositories.dart';
import '../../recipe_details/recipe_details_screen_factory.dart';
import 'recipes_screen.dart';

class RecipesScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    final recipeDetailsScreenFactory = RecipeDetailsScreenFactory();

    return BlocProvider(
      create: (context) {
        return RecipesBloc(
            recipesRepository:
                RepositoryProvider.of<RecipesRepository>(context),
            bookmarkedRecipesRepository:
                RepositoryProvider.of<BookmarkedRecipesRepository>(context),
            errorHandlingBloc: BlocProvider.of<ErrorHandlingBloc>(context))
          ..add(BlocInit());
      },
      child: RecipesScreen(
        recipeDetailsScreenFactory: recipeDetailsScreenFactory,
      ),
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widget_factory/widget_factory.dart';

import '../../../bloc/bookmarks/index.dart';
import '../../../bloc/error_handling/index.dart';
import '../../../data/repositories/bookmarked_recipes_repository.dart';
import '../recipe_details/recipe_details_screen_factory.dart';
import 'bookmarks_screen.dart';

class BookmarksScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    final recipeDetailsScreenFactory = RecipeDetailsScreenFactory();

    return BlocProvider(
      create: (context) {
        return BookmarksBloc(
          bookmarksRepository:
              RepositoryProvider.of<BookmarkedRecipesRepository>(context),
          errorHandlingBloc: BlocProvider.of<ErrorHandlingBloc>(context),
        )..add(BlocInit());
      },
      child: BookmarksScreen(
        recipeDetailsScreenFactory: recipeDetailsScreenFactory,
      ),
    );
  }
}

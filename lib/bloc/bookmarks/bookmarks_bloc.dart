import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/database/models/recipe_db_model.dart';
import '../../data/repositories/repositories.dart';
import '../../ui/screens/main/recipes/recipe/recipe_view_model.dart';
import '../base_bloc.dart';
import '../error_handling/index.dart';
import 'index.dart';

class BookmarksBloc extends BaseBloc<BookmarksEvent, BookmarksState> {
  // region Properties

  final BookmarkedRecipesRepository bookmarksRepository;

  // endregion

  // region Lifecycle

  BookmarksBloc(
      {@required this.bookmarksRepository,
      @required ErrorHandlingBloc errorHandlingBloc})
      : super(
            initialState: BookmarksState.initial(),
            errorHandlingBloc: errorHandlingBloc);

  @override
  Stream<BookmarksState> mapEventToState(BookmarksEvent event) async* {
    if (event is BlocInit) {
      yield state.copy(loading: true);
      final dbRecipes = await bookmarksRepository.getRecipes();
      final recipes = dbRecipes.map(_mapRecipeResponseToViewModel);
      yield state.copy(listItems: recipes, loading: false);
    } else if (event is RemoveFromBookmarks) {
      bookmarksRepository.deleteRecipe(event.recipe.id);
      final currentRecipes = state.listItems;
      currentRecipes.remove(event.recipe);
      yield state.copy(listItems: currentRecipes);
    }
  }

  // endregion

  // region Private methods

  RecipeViewModel _mapRecipeResponseToViewModel(RecipeDbModel response) =>
      RecipeViewModel(
        id: response.id,
        title: response.title,
        complexity: response.complexity,
        imageUrl: response.imageUrl,
        isInBookmarks: true,
      );

  // endregion
}

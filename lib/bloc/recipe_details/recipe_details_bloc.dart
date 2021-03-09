import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/database/models/models.dart';
import '../../data/http_client/responses/responses.dart';
import '../../data/repositories/repositories.dart';
import '../../ui/screens/recipe_details/recipe_header/recipe_header_view_model.dart';
import '../base_bloc.dart';
import '../error_handling/index.dart';
import 'index.dart';

class RecipeDetailsBloc
    extends BaseBloc<RecipeDetailsEvent, RecipeDetailsState> {
  // region Properties

  final RecipesRepository recipesRepository;
  final BookmarkedRecipesRepository bookmarkedRecipesRepository;

  // endregion

  // region Lifecycle

  RecipeDetailsBloc({
    @required RecipeResponse recipe,
    @required this.recipesRepository,
    @required this.bookmarkedRecipesRepository,
    @required ErrorHandlingBloc errorHandlingBloc,
  }) : super(
          initialState: RecipeDetailsState.initial(recipe: recipe),
          errorHandlingBloc: errorHandlingBloc,
        );

  @override
  Stream<RecipeDetailsState> mapEventToState(RecipeDetailsEvent event) async* {
    if (event is BlocInit) {
      yield state.copy(loading: true);
      var recipe = state.recipe;
      try {
        recipe = await recipesRepository.getRecipe(state.recipe.id);
      } on Exception catch (e) {
        errorHandlingBloc.add(ExceptionRaised(e));
      }
      final headerViewModel = RecipeHeaderViewModel(
        title: recipe.title,
        complexity: recipe.complexity,
        authorAvatarUrl: recipe.userAvaratUrl,
        authorName: recipe.userName,
      );
      yield state.copy(
        recipe: recipe,
        loading: false,
        headerViewModel: headerViewModel,
      );
    } else if (event is Bookmarks) {
      final isInBookmarks = !event.recipe.isInBookmarks;
      final updatedRecipe = event.recipe.copy(isInBookmarks: isInBookmarks);
      yield state.copy(headerViewModel: updatedRecipe);
      _updateBookmarkedRecipeInDb();
    }
  }

  // endregion

  // region Private methods

  Future<void> _updateBookmarkedRecipeInDb() async {
    if (state.headerViewModel.isInBookmarks) {
      final recipeDbModel = RecipeDbModel(
        id: state.recipe.id,
        title: state.recipe.title,
        complexity: state.recipe.complexity,
        imageUrls: state.recipe.imageUrls,
      );
      try {
        await bookmarkedRecipesRepository.addRecipe(recipeDbModel);
      } on Exception catch (e) {
        errorHandlingBloc.add(ExceptionRaised(e));
      }
    } else {
      try {
        await bookmarkedRecipesRepository.deleteRecipe(state.recipe.id);
      } on Exception catch (e) {
        errorHandlingBloc.add(ExceptionRaised(e));
      }
    }
  }

  // endregion
}

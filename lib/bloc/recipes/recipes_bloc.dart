import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/database/models/recipe_db_model.dart';
import '../../data/http_client/responses/responses.dart';
import '../../data/repositories/repositories.dart';
import '../../ui/reusable/list_items/progress_indicator_item.dart';
import '../../ui/screens/main/recipes/recipe/recipe_view_model.dart';
import '../base_bloc.dart';
import '../error_handling/index.dart';
import 'index.dart';

class RecipesBloc extends BaseBloc<RecipesEvent, RecipesState> {
  // region Properties

  final RecipesRepository recipesRepository;
  final BookmarkedRecipesRepository bookmarkedRecipesRepository;

  // endregion

  // region Lifecycle

  RecipesBloc(
      {@required this.recipesRepository,
      @required this.bookmarkedRecipesRepository,
      @required ErrorHandlingBloc errorHandlingBloc})
      : super(
            initialState: RecipesState.initial(),
            errorHandlingBloc: errorHandlingBloc);

  @override
  Stream<RecipesState> mapEventToState(RecipesEvent event) async* {
    if (event is BlocInit) {
      yield state.copy(loadingFirstPage: true);
      final recipes = await _getRecipesFirstPage();
      yield state.copy(listItems: recipes, loadingFirstPage: false);
    } else if (event is PullToRefresh) {
      final recipes = await _getRecipesFirstPage();
      yield state.copy(listItems: recipes);
      event.onComplete();
    } else if (event is LoadNextPage) {
      final initialListItems = List.of(state.listItems);
      final liatItemsOnLoad = initialListItems + [ProgressIndicatorItem()];
      yield state.copy(loadingNextPage: true, listItems: liatItemsOnLoad);
      final recipesNextPage = await _getRecipesNextPage();
      final updatedListItems = initialListItems + recipesNextPage;
      yield state.copy(loadingNextPage: false, listItems: updatedListItems);
    } else if (event is Bookmarks) {
      final updatedRecipe =
          event.recipe.copy(isInBookmarks: !event.recipe.isInBookmarks);
      _updateBookmarkedRecipeInDb(updatedRecipe);
      final updatedListItems = List.of(state.listItems);
      final recipeIndex = updatedListItems.indexOf(event.recipe);
      updatedListItems
          .replaceRange(recipeIndex, recipeIndex + 1, [updatedRecipe]);
      yield state.copy(listItems: updatedListItems);
    }
  }

  // endregion

  // region Private methods

  Future<List<RecipeViewModel>> _getRecipesFirstPage() async {
    List<RecipeShortResponse> firstPageResponse;
    try {
      firstPageResponse = await recipesRepository.getRecipes();
    } on Exception catch (e) {
      errorHandlingBloc.add(ExceptionRaised(e));
      return null;
    }
    final result =
        firstPageResponse.map(_mapRecipeResponseToViewModel).toList();
    return result;
  }

  Future<List<RecipeViewModel>> _getRecipesNextPage() async {
    final lastItem = state.listItems.lastWhere((e) => e is RecipeViewModel)
        as RecipeViewModel;
    final lastId = lastItem.id;
    List<RecipeShortResponse> nextPageResponse;
    try {
      nextPageResponse = await recipesRepository.getRecipes(lastId: lastId);
    } on Exception catch (e) {
      errorHandlingBloc.add(ExceptionRaised(e));
      nextPageResponse = [];
    }
    final result = nextPageResponse.map(_mapRecipeResponseToViewModel).toList();
    return result;
  }

  RecipeViewModel _mapRecipeResponseToViewModel(RecipeShortResponse response) =>
      RecipeViewModel(
        id: response.id,
        title: response.title,
        complexity: response.complexity,
        imageUrl: response.imageUrl,
      );

  Future<void> _updateBookmarkedRecipeInDb(
      RecipeViewModel updatedRecipe) async {
    if (updatedRecipe.isInBookmarks) {
      final recipeDbModel = _mapRecipeViewModelToDbModel(updatedRecipe);
      await bookmarkedRecipesRepository.addRecipe(recipeDbModel);
    } else {
      await bookmarkedRecipesRepository.deleteRecipe(updatedRecipe.id);
    }
  }

  RecipeDbModel _mapRecipeViewModelToDbModel(RecipeViewModel model) =>
      RecipeDbModel(
        id: model.id,
        title: model.title,
        complexity: model.complexity,
        imageUrl: model.imageUrl,
      );

  // endregion
}

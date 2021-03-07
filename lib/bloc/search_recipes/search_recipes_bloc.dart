import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/database/models/models.dart';
import '../../data/http_client/responses/responses.dart';
import '../../data/repositories/repositories.dart';
import '../../ui/reusable/list_items/progress_indicator_item.dart';
import '../../ui/screens/main/recipes/recipe/recipe_view_model.dart';
import '../base_bloc.dart';
import '../error_handling/index.dart';
import 'index.dart';

class SearchRecipesBloc
    extends BaseBloc<SearchRecipesEvent, SearchRecipesState> {
  // region Properties

  final RecipesRepository recipesRepository;
  final BookmarkedRecipesRepository bookmarkedRecipesRepository;

  // endregion

  // region Lifecycle

  SearchRecipesBloc(
      {@required this.recipesRepository,
      @required this.bookmarkedRecipesRepository,
      @required ErrorHandlingBloc errorHandlingBloc})
      : super(
            initialState: SearchRecipesState.initial(),
            errorHandlingBloc: errorHandlingBloc);

  @override
  Stream<SearchRecipesState> mapEventToState(SearchRecipesEvent event) async* {
    if (event is BlocInit) {
      final bookmarkedRecipesIds = await _getBookmarkedRecipesIds();
      yield state.copy(bookmarkedRecipesIds: bookmarkedRecipesIds);
    } else if (event is SearchQueryChanged) {
      if (event.query.length > 2) {
        yield state.copy(loadingFirstPage: true, searchQuery: event.query);
        final recipes = await _getRecipesFirstPage(searchQuery: event.query);
        yield state.copy(
          listItems: recipes,
          loadingFirstPage: false,
        );
      } else {
        yield state.copy(listItems: [], setSearchQueryToNull: true);
      }
    } else if (event is LoadNextPage) {
      final initialListItems = state.listItems;
      final liatItemsOnLoad = initialListItems + [ProgressIndicatorItem()];
      yield state.copy(loadingNextPage: true, listItems: liatItemsOnLoad);
      final recipesNextPage =
          await _getRecipesNextPage(searchQuery: state.searchQuery);
      final updatedListItems = initialListItems + recipesNextPage;
      yield state.copy(loadingNextPage: false, listItems: updatedListItems);
    } else if (event is Bookmarks) {
      final isInBookmarks = !event.recipe.isInBookmarks;
      final updatedRecipe = event.recipe.copy(isInBookmarks: isInBookmarks);
      _updateBookmarkedRecipeInDb(updatedRecipe);
      final updatedListItems = state.listItems;
      final recipeIndex = updatedListItems.indexOf(event.recipe);
      updatedListItems
          .replaceRange(recipeIndex, recipeIndex + 1, [updatedRecipe]);
      final updatedBookmarkedRecipesIds = state.bookmarkedRecipesIds;
      if (isInBookmarks) {
        updatedBookmarkedRecipesIds.add(event.recipe.id);
      } else {
        updatedBookmarkedRecipesIds.remove(event.recipe.id);
      }
      yield state.copy(
        listItems: updatedListItems,
        bookmarkedRecipesIds: updatedBookmarkedRecipesIds,
      );
    }
  }

  // endregion

  // region Private methods

  Future<List<RecipeViewModel>> _getRecipesFirstPage(
      {@required String searchQuery}) async {
    List<RecipeShortResponse> firstPageResponse;
    try {
      firstPageResponse =
          await recipesRepository.getRecipes(searchQuery: searchQuery);
    } on Exception catch (e) {
      errorHandlingBloc.add(ExceptionRaised(e));
      return null;
    }
    final result =
        firstPageResponse.map(_mapRecipeResponseToViewModel).toList();
    return result;
  }

  Future<List<RecipeViewModel>> _getRecipesNextPage(
      {@required String searchQuery}) async {
    final lastItem = state.listItems.lastWhere((e) => e is RecipeViewModel)
        as RecipeViewModel;
    final lastId = lastItem.id;
    List<RecipeShortResponse> nextPageResponse;
    try {
      nextPageResponse = await recipesRepository.getRecipes(
        searchQuery: searchQuery,
        lastId: lastId,
      );
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
        imageUrls: response.imageUrls,
        isInBookmarks: state.bookmarkedRecipesIds.contains(response.id),
      );

  Future<Set<int>> _getBookmarkedRecipesIds() async {
    final recipes = await bookmarkedRecipesRepository.getRecipes();
    return recipes.map((e) => e.id).toSet();
  }

  Future<void> _updateBookmarkedRecipeInDb(
      RecipeViewModel updatedRecipe) async {
    if (updatedRecipe.isInBookmarks) {
      final recipeDbModel = _mapRecipeViewModelToDbModel(updatedRecipe);
      try {
        await bookmarkedRecipesRepository.addRecipe(recipeDbModel);
      } on Exception catch (e) {
        errorHandlingBloc.add(ExceptionRaised(e));
      }
    } else {
      try {
        await bookmarkedRecipesRepository.deleteRecipe(updatedRecipe.id);
      } on Exception catch (e) {
        errorHandlingBloc.add(ExceptionRaised(e));
      }
    }
  }

  RecipeDbModel _mapRecipeViewModelToDbModel(RecipeViewModel model) =>
      RecipeDbModel(
        id: model.id,
        title: model.title,
        complexity: model.complexity,
        imageUrls: model.imageUrls,
      );

  // endregion
}

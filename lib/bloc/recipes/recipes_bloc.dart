import 'dart:async';

import 'package:flutter/foundation.dart';

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

  // endregion

  // region Lifecycle

  RecipesBloc(
      {@required this.recipesRepository,
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
    } else if (event is AddToBookmarks) {
      // TODO: handle add to bookmarks
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

  // endregion
}

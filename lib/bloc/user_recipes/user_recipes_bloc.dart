import 'dart:async';

import '../../data/database/models/models.dart';
import '../../data/http_client/responses/responses.dart';
import '../../data/repositories/repositories.dart';
import '../../ui/reusable/list_items/progress_indicator_item.dart';
import '../../ui/screens/main/recipes/recipe/recipe_view_model.dart';
import '../base_bloc.dart';
import '../error_handling/index.dart';
import 'index.dart';

class UserRecipesBloc extends BaseBloc<UserRecipesEvent, UserRecipesState> {
  // region Properties

  final RecipesRepository recipesRepository;
  final BookmarkedRecipesRepository bookmarkedRecipesRepository;

  // endregion

  // region Lifecycle

  UserRecipesBloc({
    bool isMyRecipes = false,
    required int userId,
    required this.recipesRepository,
    required this.bookmarkedRecipesRepository,
    required ErrorHandlingBloc errorHandlingBloc,
  }) : super(
            initialState: UserRecipesState.initial(
              isMyRecipes: isMyRecipes,
              userId: userId,
            ),
            errorHandlingBloc: errorHandlingBloc);

  @override
  Stream<UserRecipesState> mapEventToState(UserRecipesEvent event) async* {
    if (event is BlocInit) {
      yield state.copy(loadingFirstPage: true);
      final bookmarkedRecipesIds = await _getBookmarkedRecipesIds();
      yield state.copy(bookmarkedRecipesIds: bookmarkedRecipesIds);
      final recipes = await _getRecipesFirstPage();
      yield state.copy(
        listItems: recipes,
        loadingFirstPage: false,
      );
    } else if (event is PullToRefresh) {
      final recipes = await _getRecipesFirstPage();
      yield state.copy(listItems: recipes);
      event.onComplete();
    } else if (event is LoadNextPage) {
      final initialListItems = state.listItems;
      final listItemsOnLoad = initialListItems + [ProgressIndicatorItem()];
      yield state.copy(loadingNextPage: true, listItems: listItemsOnLoad);
      final recipesNextPage = await _getRecipesNextPage();
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
    } else if (event is UpdateIsInBookmarks) {
      final updatedBookmarkedRecipesIds = await _getBookmarkedRecipesIds();
      final updatedIsInBookmarks =
          updatedBookmarkedRecipesIds.contains(event.recipe.id);
      if (event.recipe.isInBookmarks != updatedIsInBookmarks) {
        final updatedRecipe =
            event.recipe.copy(isInBookmarks: updatedIsInBookmarks);
        final updatedListItems = state.listItems;
        final recipeIndex = updatedListItems.indexOf(event.recipe);
        updatedListItems
            .replaceRange(recipeIndex, recipeIndex + 1, [updatedRecipe]);
        yield state.copy(
          listItems: updatedListItems,
          bookmarkedRecipesIds: updatedBookmarkedRecipesIds,
        );
      }
    }
  }

  // endregion

  // region Private methods

  Future<List<RecipeViewModel>> _getRecipesFirstPage() async {
    List<RecipeShortResponse> firstPageResponse;
    final request = state.isMyRecipes
        ? recipesRepository.getMyRecipes()
        : recipesRepository.getRecipesOfUser(userId: state.userId);
    try {
      firstPageResponse = await request;
    } on Exception catch (e) {
      errorHandlingBloc.add(ExceptionRaised(e));
      return [];
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
    final request = state.isMyRecipes
        ? recipesRepository.getMyRecipes(lastId: lastId)
        : recipesRepository.getRecipesOfUser(
            userId: state.userId,
            lastId: lastId,
          );
    try {
      nextPageResponse = await request;
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

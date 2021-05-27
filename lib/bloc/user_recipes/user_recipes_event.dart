import 'package:equatable/equatable.dart';

import '../../ui/screens/main/recipes/recipe/recipe_view_model.dart';

abstract class UserRecipesEvent extends Equatable {}

class BlocInit extends UserRecipesEvent {
  @override
  List<Object> get props => [];
}

class Bookmarks extends UserRecipesEvent {
  final RecipeViewModel recipe;

  Bookmarks(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class UpdateIsInBookmarks extends UserRecipesEvent {
  final RecipeViewModel recipe;

  UpdateIsInBookmarks(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class PullToRefresh extends UserRecipesEvent {
  final Function onComplete;

  PullToRefresh(this.onComplete);

  @override
  List<Object> get props => [];
}

class LoadNextPage extends UserRecipesEvent {
  @override
  List<Object> get props => [];
}

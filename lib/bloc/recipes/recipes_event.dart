import 'package:equatable/equatable.dart';

import '../../ui/screens/main/recipes/recipe/recipe_view_model.dart';

abstract class RecipesEvent extends Equatable {}

class BlocInit extends RecipesEvent {
  @override
  List<Object> get props => [];
}

class Bookmarks extends RecipesEvent {
  final RecipeViewModel recipe;

  Bookmarks(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class PullToRefresh extends RecipesEvent {
  final Function onComplete;

  PullToRefresh(this.onComplete);

  @override
  List<Object> get props => [];
}

class LoadNextPage extends RecipesEvent {
  @override
  List<Object> get props => [];
}

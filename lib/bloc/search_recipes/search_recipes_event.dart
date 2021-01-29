import 'package:equatable/equatable.dart';

import '../../ui/screens/main/recipes/recipe/recipe_view_model.dart';

abstract class SearchRecipesEvent extends Equatable {}

class BlocInit extends SearchRecipesEvent {
  @override
  List<Object> get props => [];
}

class Bookmarks extends SearchRecipesEvent {
  final RecipeViewModel recipe;

  Bookmarks(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class SearchQueryChanged extends SearchRecipesEvent {
  final String query;

  SearchQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}

class LoadNextPage extends SearchRecipesEvent {
  @override
  List<Object> get props => [];
}

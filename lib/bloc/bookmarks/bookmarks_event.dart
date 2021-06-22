import 'package:equatable/equatable.dart';

import '../../ui/screens/main/recipes/recipe/recipe_view_model.dart';

abstract class BookmarksEvent extends Equatable {}

class BlocInit extends BookmarksEvent {
  @override
  List<Object?> get props => [];
}

class RemoveFromBookmarks extends BookmarksEvent {
  final RecipeViewModel recipe;

  RemoveFromBookmarks(this.recipe);

  @override
  List<Object?> get props => [recipe];
}

class UpdateIsInBookmarks extends BookmarksEvent {
  final RecipeViewModel recipe;

  UpdateIsInBookmarks(this.recipe);

  @override
  List<Object?> get props => [recipe];
}

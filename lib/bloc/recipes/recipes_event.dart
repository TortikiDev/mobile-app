import 'package:equatable/equatable.dart';

abstract class RecipesEvent extends Equatable {}

class BlocInit extends RecipesEvent {
  @override
  List<Object> get props => [];
}

abstract class SingleRecipeEvent extends RecipesEvent {
  final int recipeId;

  SingleRecipeEvent(this.recipeId);

  @override
  List<Object> get props => [recipeId];
}

class AddToBookmarks extends SingleRecipeEvent {
  AddToBookmarks(int recipeId) : super(recipeId);
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

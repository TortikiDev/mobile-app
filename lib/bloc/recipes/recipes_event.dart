import 'package:equatable/equatable.dart';

abstract class RecipesEvent extends Equatable {}

class BlocInit extends RecipesEvent {
  @override
  List<Object> get props => [];
}

class AddToBookmarks extends RecipesEvent {
  final int recipeId;

  AddToBookmarks(this.recipeId);

  @override
  List<Object> get props => [recipeId];
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

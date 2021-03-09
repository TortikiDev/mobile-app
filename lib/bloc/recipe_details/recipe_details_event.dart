import 'package:equatable/equatable.dart';

import '../../ui/screens/recipe_details/recipe_header/recipe_header_view_model.dart';

abstract class RecipeDetailsEvent extends Equatable {}

class BlocInit extends RecipeDetailsEvent {
  @override
  List<Object> get props => [];
}

class Bookmarks extends RecipeDetailsEvent {
  final RecipeHeaderViewModel recipe;

  Bookmarks(this.recipe);

  @override
  List<Object> get props => [recipe];
}

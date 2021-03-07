import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../data/http_client/responses/responses.dart';

class RecipeDetailsState extends Equatable {
  final RecipeResponse recipe;
  final bool loading;

  const RecipeDetailsState({
    this.recipe,
    this.loading = false,
  });

  factory RecipeDetailsState.initial({@required RecipeResponse recipe}) =>
      RecipeDetailsState(recipe: recipe);

  RecipeDetailsState copy({
    RecipeResponse recipe,
    bool loading,
  }) =>
      RecipeDetailsState(
        recipe: recipe ?? this.recipe,
        loading: loading ?? this.loading,
      );

  @override
  List<Object> get props => [
        recipe,
        loading,
      ];
}

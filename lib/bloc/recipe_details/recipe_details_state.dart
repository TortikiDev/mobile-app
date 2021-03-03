import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../data/http_client/responses/responses.dart';

class RecipeDetailsState extends Equatable {
  final int recipeId;
  final RecipeResponse recipe;
  final bool loading;

  const RecipeDetailsState({
    @required this.recipeId,
    this.recipe,
    this.loading = false,
  });

  factory RecipeDetailsState.initial({@required int recipeId}) =>
      RecipeDetailsState(recipeId: recipeId);

  RecipeDetailsState copy({
    int recipeId,
    RecipeResponse recipe,
    bool loading,
  }) =>
      RecipeDetailsState(
        recipeId: recipeId ?? this.recipeId,
        recipe: recipe ?? this.recipe,
        loading: loading ?? this.loading,
      );

  @override
  List<Object> get props => [
        recipe,
        loading,
      ];
}

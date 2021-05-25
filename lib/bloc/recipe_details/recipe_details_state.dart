import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../data/http_client/responses/responses.dart';
import '../../ui/screens/recipe_details/recipe_header/recipe_header_view_model.dart';

class RecipeDetailsState extends Equatable {
  final RecipeResponse recipe;
  final bool loading;
  final RecipeHeaderViewModel headerViewModel;

  const RecipeDetailsState({
    this.recipe,
    this.loading = false,
    this.headerViewModel,
  });

  factory RecipeDetailsState.initial({
    @required RecipeResponse recipe,
    @required bool isInBookmarks,
  }) =>
      RecipeDetailsState(
        recipe: recipe,
        headerViewModel: RecipeHeaderViewModel(
          title: recipe.title,
          complexity: recipe.complexity,
          authorAvatarUrl: recipe.userAvaratUrl,
          authorName: recipe.userName ?? '',
          authorGender: recipe.userGender,
          authorId: recipe.userId,
          isInBookmarks: isInBookmarks,
        ),
      );

  RecipeDetailsState copy({
    RecipeResponse recipe,
    bool loading,
    RecipeHeaderViewModel headerViewModel,
  }) =>
      RecipeDetailsState(
        recipe: recipe ?? this.recipe,
        loading: loading ?? this.loading,
        headerViewModel: headerViewModel ?? this.headerViewModel,
      );

  @override
  List<Object> get props => [
        recipe,
        loading,
        headerViewModel,
      ];
}

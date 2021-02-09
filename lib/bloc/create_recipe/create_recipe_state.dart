import 'package:equatable/equatable.dart';

class CreateRecipeState extends Equatable {
  final String title;
  final bool canCreateRecipe;
  final bool creatingRecipe;
  final bool recipeSuccessfulyCreated;

  const CreateRecipeState({
    this.title = '',
    this.canCreateRecipe = false,
    this.creatingRecipe = false,
    this.recipeSuccessfulyCreated = false,
  });

  factory CreateRecipeState.initial() => CreateRecipeState();

  CreateRecipeState copy({
    String title,
    bool canCreateRecipe,
    bool creatingRecipe,
    bool recipeSuccessfulyCreated,
  }) =>
      CreateRecipeState(
        title: title ?? this.title,
        canCreateRecipe: canCreateRecipe ?? this.canCreateRecipe,
        creatingRecipe: creatingRecipe ?? this.creatingRecipe,
        recipeSuccessfulyCreated:
            recipeSuccessfulyCreated ?? this.recipeSuccessfulyCreated,
      );

  @override
  List<Object> get props => [
        title,
        canCreateRecipe,
        creatingRecipe,
        recipeSuccessfulyCreated,
      ];
}

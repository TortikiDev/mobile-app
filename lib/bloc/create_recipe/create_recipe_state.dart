import 'dart:io';

import 'package:equatable/equatable.dart';

class CreateRecipeState extends Equatable {
  final String title;
  final double complexity;
  final String description;
  final List<String> _ingredients;
  final String cookingSteps;
  final List<File> _photos;
  final bool canCreateRecipe;
  final bool creatingRecipe;
  final bool recipeSuccessfulyCreated;

  List<String> get ingredients => List.of(_ingredients);
  List<File> get photos => List.of(_photos);

  const CreateRecipeState({
    this.title = '',
    this.description = '',
    this.complexity = 3.0,
    List<String> ingredients = const [],
    this.cookingSteps = '',
    List<File> photos = const [],
    this.canCreateRecipe = false,
    this.creatingRecipe = false,
    this.recipeSuccessfulyCreated = false,
  })  : _ingredients = ingredients,
        _photos = photos;

  factory CreateRecipeState.initial() => CreateRecipeState();

  CreateRecipeState copy({
    String? title,
    String? description,
    double? complexity,
    List<String>? ingredients,
    String? cookingSteps,
    List<File>? photos,
    bool? canCreateRecipe,
    bool? creatingRecipe,
    bool? recipeSuccessfulyCreated,
  }) =>
      CreateRecipeState(
        title: title ?? this.title,
        description: description ?? this.description,
        complexity: complexity ?? this.complexity,
        ingredients: ingredients ?? _ingredients,
        cookingSteps: cookingSteps ?? this.cookingSteps,
        photos: photos ?? _photos,
        canCreateRecipe: canCreateRecipe ?? this.canCreateRecipe,
        creatingRecipe: creatingRecipe ?? this.creatingRecipe,
        recipeSuccessfulyCreated:
            recipeSuccessfulyCreated ?? this.recipeSuccessfulyCreated,
      );

  @override
  List<Object?> get props => [
        title,
        description,
        complexity,
        ingredients,
        cookingSteps,
        photos,
        canCreateRecipe,
        creatingRecipe,
        recipeSuccessfulyCreated,
      ];

  @override
  bool get stringify => true;
}

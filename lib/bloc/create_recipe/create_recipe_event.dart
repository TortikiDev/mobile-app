import 'package:equatable/equatable.dart';

abstract class CreateRecipeEvent extends Equatable {}

class BlocInit extends CreateRecipeEvent {
  @override
  List<Object> get props => [];
}

class TitleChanged extends CreateRecipeEvent {
  final String text;

  TitleChanged(this.text);

  @override
  List<Object> get props => [text];
}

class PlusComplexity extends CreateRecipeEvent {
  @override
  List<Object> get props => [];
}

class MinusComplexity extends CreateRecipeEvent {
  @override
  List<Object> get props => [];
}

class DescriptionChanged extends CreateRecipeEvent {
  final String text;

  DescriptionChanged(this.text);

  @override
  List<Object> get props => [text];
}

class IngredientsChanged extends CreateRecipeEvent {
  final List<String> ingredients;

  IngredientsChanged(this.ingredients);

  @override
  List<Object> get props => [ingredients];
}

class CookingStepsChanged extends CreateRecipeEvent {
  final String text;

  CookingStepsChanged(this.text);

  @override
  List<Object> get props => [text];
}

class CreateRecipe extends CreateRecipeEvent {
  @override
  List<Object> get props => [];
}

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

class DescritpionChanged extends CreateRecipeEvent {
  final String text;

  DescritpionChanged(this.text);

  @override
  List<Object> get props => [text];
}

class CreateRecipe extends CreateRecipeEvent {
  @override
  List<Object> get props => [];
}

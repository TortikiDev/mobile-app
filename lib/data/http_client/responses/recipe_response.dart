import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class RecipeShortResponse extends Equatable {
  final int id;
  final String title;
  final double complexity;
  final List<String> _imageUrls;
  final String userAvaratUrl;
  final String userName;
  final String description;
  final List<String> _ingredients;
  final String cookingSteps;

  List<String> get imageUrls => List.of(_imageUrls);
  List<String> get ingredients => List.of(_ingredients);

  RecipeShortResponse({
    @required this.id,
    @required this.title,
    @required this.complexity,
    @required List<String> imageUrls,
    @required this.userAvaratUrl,
    @required this.userName,
    @required this.description,
    @required List<String> ingredients,
    @required this.cookingSteps,
  })  : _imageUrls = imageUrls,
        _ingredients = ingredients;

  RecipeShortResponse copy({
    int id,
    String title,
    double complexity,
    List<String> imageUrls,
    String userAvaratUrl,
    String userName,
    String description,
    List<String> ingredients,
    String cookingSteps,
  }) =>
      RecipeShortResponse(
        id: id ?? this.id,
        title: title ?? this.title,
        complexity: complexity ?? this.complexity,
        imageUrls: imageUrls ?? _imageUrls,
        userAvaratUrl: userAvaratUrl ?? this.userAvaratUrl,
        userName: userName ?? this.userName,
        description: description ?? this.description,
        ingredients: ingredients ?? _ingredients,
        cookingSteps: cookingSteps ?? this.cookingSteps,
      );

  @override
  List<Object> get props => [
        id,
        title,
        complexity,
        _imageUrls,
        userAvaratUrl,
        userName,
        description,
        _ingredients,
        cookingSteps,
      ];

  @override
  bool get stringify => true;
}

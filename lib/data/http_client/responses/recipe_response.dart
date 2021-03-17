import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class RecipeResponse extends Equatable {
  final int id;
  final String title;
  final double complexity;
  final List<String> _imageUrls;
  final String userAvaratUrl;
  final String userName;
  final String description;
  final List<String> _ingredients;
  final String cookingSteps;

  /// Value from [VoteResult]
  final int myVote;

  List<String> get imageUrls => List.of(_imageUrls ?? []);
  List<String> get ingredients => List.of(_ingredients ?? []);

  RecipeResponse({
    @required this.id,
    @required this.title,
    @required this.complexity,
    @required List<String> imageUrls,
    this.userAvaratUrl,
    this.userName,
    this.description,
    List<String> ingredients,
    this.cookingSteps,
    this.myVote,
  })  : _imageUrls = imageUrls,
        _ingredients = ingredients;

  RecipeResponse copy({
    int id,
    String title,
    double complexity,
    List<String> imageUrls,
    String userAvaratUrl,
    String userName,
    String description,
    List<String> ingredients,
    String cookingSteps,
    int myVote,
  }) =>
      RecipeResponse(
        id: id ?? this.id,
        title: title ?? this.title,
        complexity: complexity ?? this.complexity,
        imageUrls: imageUrls ?? _imageUrls,
        userAvaratUrl: userAvaratUrl ?? this.userAvaratUrl,
        userName: userName ?? this.userName,
        description: description ?? this.description,
        ingredients: ingredients ?? _ingredients,
        cookingSteps: cookingSteps ?? this.cookingSteps,
        myVote: myVote ?? this.myVote,
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
        myVote,
      ];

  @override
  bool get stringify => true;
}

mixin VoteResult {
  static const unvoted = 0;
  static const votedUp = 1;
  static const votedDown = 2;
}

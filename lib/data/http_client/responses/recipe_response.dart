import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class RecipeResponse extends Equatable {
  final int id;
  final String title;
  final double complexity;
  final List<String> _imageUrls;
  final String userAvaratUrl;
  final String userName;
  final int userId;
  /// From [Gender]
  final int userGender;
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
    this.userId,
    this.userGender,
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
    int userId,
    int userGender,
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
        userId: userId ?? this.userId,
        userGender: userGender ?? this.userGender,
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
        userId,
        userGender,
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

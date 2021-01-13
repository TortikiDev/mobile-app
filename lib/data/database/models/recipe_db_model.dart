import 'package:flutter/foundation.dart';

class RecipeDbModel {
  final int id;
  final String title;
  final double complexity;
  final String imageUrl;

  RecipeDbModel({
    @required this.id,
    @required this.title,
    @required this.complexity,
    @required this.imageUrl,
  });

  factory RecipeDbModel.fromMap(Map<String, dynamic> map) => RecipeDbModel(
        id: map['id'],
        title: map['title'],
        complexity: map['complexity'],
        imageUrl: map['imageUrl'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'complexity': complexity,
        'imageUrl': imageUrl,
      };
}

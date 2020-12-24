import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class RecipeShortResponse extends Equatable {
  final int id;
  final String title;
  final double complexity;
  final String imageUrl;

  RecipeShortResponse({
    @required this.id,
    @required this.title,
    @required this.complexity,
    @required this.imageUrl,
  });

  RecipeShortResponse copy({
    int id,
    String title,
    double complexity,
    String imageUrl,
  }) =>
      RecipeShortResponse(
        id: id ?? this.id,
        title: title ?? this.title,
        complexity: complexity ?? this.complexity,
        imageUrl: imageUrl ?? this.imageUrl,
      );

  @override
  List<Object> get props => [
        id,
        title,
        complexity,
        imageUrl,
      ];

  @override
  bool get stringify => true;
}

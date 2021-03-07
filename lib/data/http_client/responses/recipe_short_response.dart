import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class RecipeShortResponse extends Equatable {
  final int id;
  final String title;
  final double complexity;
  final List<String> imageUrls;

  RecipeShortResponse({
    @required this.id,
    @required this.title,
    @required this.complexity,
    @required this.imageUrls,
  });

  RecipeShortResponse copy({
    int id,
    String title,
    double complexity,
    List<String> imageUrls,
  }) =>
      RecipeShortResponse(
        id: id ?? this.id,
        title: title ?? this.title,
        complexity: complexity ?? this.complexity,
        imageUrls: imageUrls ?? this.imageUrls,
      );

  @override
  List<Object> get props => [
        id,
        title,
        complexity,
        imageUrls,
      ];

  @override
  bool get stringify => true;
}

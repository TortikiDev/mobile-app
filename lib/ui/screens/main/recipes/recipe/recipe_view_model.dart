import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../../reusable/list_items/list_item.dart';

class RecipeViewModel extends Equatable implements ListItem {
  final int id;
  final String title;
  final double complexity;
  final List<String> _imageUrls;
  final bool isInBookmarks;

  List<String> get imageUrls => List.of(_imageUrls);

  RecipeViewModel({
    @required this.id,
    @required this.title,
    @required this.complexity,
    @required List<String> imageUrls,
    this.isInBookmarks = false,
  }) : _imageUrls = imageUrls;

  RecipeViewModel copy({
    int id,
    String title,
    double complexity,
    List<String> imageUrls,
    bool isInBookmarks,
  }) =>
      RecipeViewModel(
        id: id ?? this.id,
        title: title ?? this.title,
        complexity: complexity ?? this.complexity,
        imageUrls: imageUrls ?? this.imageUrls,
        isInBookmarks: isInBookmarks ?? this.isInBookmarks,
      );

  @override
  List<Object> get props => [
        id,
        title,
        complexity,
        imageUrls,
        isInBookmarks,
      ];

  @override
  bool get stringify => true;
}

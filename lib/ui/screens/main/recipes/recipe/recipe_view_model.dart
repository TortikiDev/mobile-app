import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../../reusable/list_items/list_item.dart';

class RecipeViewModel extends Equatable implements ListItem {
  final int id;
  final String title;
  final double complexity;
  final String imageUrl;
  final bool isInBookmarks;

  RecipeViewModel({
    @required this.id,
    @required this.title,
    @required this.complexity,
    @required this.imageUrl,
    this.isInBookmarks = false,
  });

  RecipeViewModel copy({
    int id,
    String title,
    double complexity,
    String imageUrl,
    bool isInBookmarks,
  }) =>
      RecipeViewModel(
        id: id ?? this.id,
        title: title ?? this.title,
        complexity: complexity ?? this.complexity,
        imageUrl: imageUrl ?? this.imageUrl,
        isInBookmarks: isInBookmarks ?? this.isInBookmarks,
      );

  @override
  List<Object> get props => [
        id,
        title,
        complexity,
        imageUrl,
        isInBookmarks,
      ];

  @override
  bool get stringify => true;
}
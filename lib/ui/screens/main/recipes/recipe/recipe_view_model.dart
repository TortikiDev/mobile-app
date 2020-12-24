import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../../reusable/list_items/list_item.dart';

class RecipeViewModel extends Equatable implements ListItem {
  final int id;
  final String title;
  final double complexity;
  final String imageUrl;

  RecipeViewModel({
    @required this.id,
    @required this.title,
    @required this.complexity,
    @required this.imageUrl,
  });

  RecipeViewModel copy({
    int id,
    String title,
    double complexity,
    String imageUrl,
  }) =>
      RecipeViewModel(
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

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class RecipeHeaderViewModel extends Equatable {
  final int id;
  final String title;
  final double complexity;
  final bool isInBookmarks;
  final String authorAvatarUrl;
  final String authorName;

  RecipeHeaderViewModel({
    @required this.id,
    @required this.title,
    @required this.complexity,
    this.isInBookmarks = false,
    @required this.authorAvatarUrl,
    @required this.authorName,
  });

  RecipeHeaderViewModel copy({
    int id,
    String title,
    double complexity,
    bool isInBookmarks,
    String authorAvatarUrl,
    String authorName,
  }) =>
      RecipeHeaderViewModel(
        id: id ?? this.id,
        title: title ?? this.title,
        complexity: complexity ?? this.complexity,
        isInBookmarks: isInBookmarks ?? this.isInBookmarks,
        authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
        authorName: authorName ?? this.authorName,
      );

  @override
  List<Object> get props => [
        id,
        title,
        complexity,
        isInBookmarks,
        authorAvatarUrl,
        authorName,
      ];

  @override
  bool get stringify => true;
}

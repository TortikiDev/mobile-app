import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class RecipeHeaderViewModel extends Equatable {
  final String title;
  final double complexity;
  final bool isInBookmarks;
  final String authorAvatarUrl;
  final String authorName;
  final int authorId;

  RecipeHeaderViewModel({
    @required this.title,
    @required this.complexity,
    this.isInBookmarks = false,
    @required this.authorAvatarUrl,
    @required this.authorName,
    @required this.authorId,
  });

  RecipeHeaderViewModel copy({
    String title,
    double complexity,
    bool isInBookmarks,
    String authorAvatarUrl,
    String authorName,
    String authorId,
  }) =>
      RecipeHeaderViewModel(
        title: title ?? this.title,
        complexity: complexity ?? this.complexity,
        isInBookmarks: isInBookmarks ?? this.isInBookmarks,
        authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
        authorName: authorName ?? this.authorName,
        authorId: authorId ?? this.authorId,
      );

  @override
  List<Object> get props => [
        title,
        complexity,
        isInBookmarks,
        authorAvatarUrl,
        authorName,
        authorId,
      ];

  @override
  bool get stringify => true;
}

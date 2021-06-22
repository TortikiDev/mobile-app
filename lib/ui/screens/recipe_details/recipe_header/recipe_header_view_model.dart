import 'package:equatable/equatable.dart';

import '../../../../data/http_client/responses/responses.dart';

class RecipeHeaderViewModel extends Equatable {
  final String title;
  final double complexity;
  final bool isInBookmarks;
  final String? authorAvatarUrl;

  /// From [Gender]
  final int authorGender;
  final String authorName;
  final int? authorId;

  RecipeHeaderViewModel({
    required this.title,
    required this.complexity,
    this.isInBookmarks = false,
    required this.authorAvatarUrl,
    required this.authorGender,
    required this.authorName,
    required this.authorId,
  });

  RecipeHeaderViewModel copy({
    String? title,
    double? complexity,
    bool? isInBookmarks,
    String? authorAvatarUrl,
    int? authorGender,
    String? authorName,
    int? authorId,
  }) =>
      RecipeHeaderViewModel(
        title: title ?? this.title,
        complexity: complexity ?? this.complexity,
        isInBookmarks: isInBookmarks ?? this.isInBookmarks,
        authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
        authorGender: authorGender ?? this.authorGender,
        authorName: authorName ?? this.authorName,
        authorId: authorId ?? this.authorId,
      );

  @override
  List<Object?> get props => [
        title,
        complexity,
        isInBookmarks,
        authorAvatarUrl,
        authorGender,
        authorName,
        authorId,
      ];

  @override
  bool get stringify => true;
}

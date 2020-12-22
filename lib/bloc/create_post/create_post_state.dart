import 'dart:io';

import 'package:equatable/equatable.dart';

class CreatePostState extends Equatable {
  final File photo;
  final String description;
  final bool canCreatePost;
  final bool creatingPost;
  final bool postSuccessfulyCreated;

  const CreatePostState(
      {this.photo,
      this.description = '',
      this.canCreatePost = false,
      this.creatingPost = false,
      this.postSuccessfulyCreated = false});

  factory CreatePostState.initial() => CreatePostState();

  CreatePostState copy(
          {File photo,
          String description,
          bool canCreatePost,
          bool creatingPost,
          bool postSuccessfulyCreated}) =>
      CreatePostState(
          photo: photo ?? this.photo,
          description: description ?? this.description,
          canCreatePost: canCreatePost ?? this.canCreatePost,
          creatingPost: creatingPost ?? this.creatingPost,
          postSuccessfulyCreated:
              postSuccessfulyCreated ?? this.postSuccessfulyCreated);

  @override
  List<Object> get props =>
      [photo, description, canCreatePost, creatingPost, postSuccessfulyCreated];
}

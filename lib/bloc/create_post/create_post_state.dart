import 'dart:io';

import 'package:equatable/equatable.dart';

class CreatePostState extends Equatable {
  final File photo;
  final String description;
  final bool canCreatePost;
  final bool creatingPost;

  const CreatePostState(
      {this.photo,
      this.description = '',
      this.canCreatePost = false,
      this.creatingPost = false});

  factory CreatePostState.initial() => CreatePostState();

  CreatePostState copy(
          {File photo,
          String description,
          bool canCreatePost,
          bool creatingPost}) =>
      CreatePostState(
          photo: photo ?? this.photo,
          description: description ?? this.description,
          canCreatePost: canCreatePost ?? this.canCreatePost,
          creatingPost: creatingPost ?? this.creatingPost);

  @override
  List<Object> get props => [photo, description, canCreatePost, creatingPost];
}

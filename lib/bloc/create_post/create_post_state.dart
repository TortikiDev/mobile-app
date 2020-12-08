import 'dart:io';

import 'package:equatable/equatable.dart';

class CreatePostState extends Equatable {
  final File photo;
  final String description;

  const CreatePostState({this.photo, this.description = ''});

  factory CreatePostState.initial() => CreatePostState();

  CreatePostState copy({File photo, String description}) =>
      CreatePostState(photo: photo, description: description);

  @override
  List<Object> get props => [photo, description];
}

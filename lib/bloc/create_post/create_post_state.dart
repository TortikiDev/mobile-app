import 'dart:io';

import 'package:equatable/equatable.dart';

class CreatePostState extends Equatable {
  final File photo;
  final String description;

  const CreatePostState({this.photo, this.description = ''});

  factory CreatePostState.initial() => CreatePostState();

  @override
  List<Object> get props => [photo, description];
}

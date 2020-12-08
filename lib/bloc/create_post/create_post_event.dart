import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class CreatePostEvent extends Equatable {}

class BlocInit extends CreatePostEvent {
  @override
  List<Object> get props => [];
}

class PhotoPicked extends CreatePostEvent {
  final File photo;

  PhotoPicked(this.photo);

  @override
  List<Object> get props => [photo];
}

class DescriptionChanged extends CreatePostEvent {
  final String text;

  DescriptionChanged(this.text);

  @override
  List<Object> get props => [text];
}
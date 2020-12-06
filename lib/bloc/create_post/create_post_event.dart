import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class CreatePostEvent extends Equatable {}

class BlocInit extends CreatePostEvent {
  @override
  List<Object> get props => [];
}

class ImagePicked extends CreatePostEvent {
  final File image;

  ImagePicked(this.image);

  @override
  List<Object> get props => [image];
}

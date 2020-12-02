import 'package:equatable/equatable.dart';

abstract class CreatePostEvent extends Equatable {}

class BlocInit extends CreatePostEvent {
  @override
  List<Object> get props => [];
}

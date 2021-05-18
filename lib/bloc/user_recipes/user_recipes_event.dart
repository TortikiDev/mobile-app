import 'package:equatable/equatable.dart';

abstract class UserRecipesEvent extends Equatable {}

class BlocInit extends UserRecipesEvent {
  @override
  List<Object> get props => [];
}

import 'package:equatable/equatable.dart';

abstract class RecipeDetailsEvent extends Equatable {}

class BlocInit extends RecipeDetailsEvent {
  @override
  List<Object> get props => [];
}

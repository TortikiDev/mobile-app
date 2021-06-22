import 'package:equatable/equatable.dart';

abstract class MainEvent extends Equatable {}

class BlocInit extends MainEvent {
  @override
  List<Object?> get props => [];
}

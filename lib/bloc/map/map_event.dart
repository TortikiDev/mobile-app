import 'package:equatable/equatable.dart';

abstract class MapEvent extends Equatable {}

class BlocInit extends MapEvent {
  @override
  List<Object> get props => [];
}

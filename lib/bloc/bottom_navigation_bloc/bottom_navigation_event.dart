import 'package:equatable/equatable.dart';

abstract class BottomNavigationEvent extends Equatable {}

class BlocInit extends BottomNavigationEvent {
  @override
  List<Object> get props => [];
}

class HideNavigationBar extends BottomNavigationEvent {
  @override
  List<Object> get props => [];
}

class ShowNavigationBar extends BottomNavigationEvent {
  @override
  List<Object> get props => [];
}
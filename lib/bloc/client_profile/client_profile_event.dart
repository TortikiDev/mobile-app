import 'package:equatable/equatable.dart';

abstract class ClientProfileEvent extends Equatable {}

class BlocInit extends ClientProfileEvent {
  @override
  List<Object> get props => [];
}

class Logout extends ClientProfileEvent {
  @override
  List<Object> get props => [];
}

class PickCity extends ClientProfileEvent {
  final String city;

  PickCity(this.city);

  @override
  List<Object> get props => [city];
}

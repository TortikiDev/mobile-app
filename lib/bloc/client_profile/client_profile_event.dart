import 'package:equatable/equatable.dart';

abstract class ClientProfileEvent extends Equatable {}

class BlocInit extends ClientProfileEvent {
  @override
  List<Object> get props => [];
}

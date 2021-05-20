import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {}

abstract class PostEvent extends AuthEvent {
  final String phoneNumber;

  PostEvent(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

class BlocInit extends AuthEvent {
  @override
  List<Object> get props => [];
}

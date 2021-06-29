import 'package:equatable/equatable.dart';

abstract class ErrorHandlingEvent extends Equatable {}

class ExceptionRaised extends ErrorHandlingEvent {
  final Exception exception;

  ExceptionRaised(this.exception);

  @override
  List<Object?> get props => [exception];
}

class DismissErrorDialog extends ErrorHandlingEvent {
  @override
  List<Object?> get props => [];
}

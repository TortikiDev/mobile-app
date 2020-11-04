import 'package:equatable/equatable.dart';

import 'error_dialog_message.dart';

abstract class ErrorHandlingState extends Equatable {}

class NoError extends ErrorHandlingState {
  @override
  List<Object> get props => [];
}

class ShowDialog extends ErrorHandlingState {
  final ErrorDialogMessage message;

  ShowDialog({this.message});

  @override
  List<Object> get props => [message];
}

class ShowApiErrorDialog extends ErrorHandlingState {
  final String title;
  final String correlationId;
  final String message;

  ShowApiErrorDialog(this.title, this.correlationId, this.message);

  @override
  List<Object> get props => [title, correlationId, message];
}

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'error_dialog_message.dart';
import 'index.dart';

class ErrorHandlingBloc extends Bloc<ErrorHandlingEvent, ErrorHandlingState> {
  ErrorHandlingBloc() : super(NoError());

  @override
  Stream<ErrorHandlingState> mapEventToState(ErrorHandlingEvent event) async* {
    if (event is ExceptionRaised && state is NoError) {
      debugPrint(event.exception.toString());
      final exception = event.exception;
      var dialogMessage = ErrorDialogMessage.somethingWentWrong;

      if (exception is TimeoutException) {
        dialogMessage = ErrorDialogMessage.connectionTimeout;
      } else if (exception is DioError) {
        switch (exception.type) {
          case DioErrorType.SEND_TIMEOUT:
          case DioErrorType.CONNECT_TIMEOUT:
          case DioErrorType.RECEIVE_TIMEOUT:
            dialogMessage = ErrorDialogMessage.connectionTimeout;
            break;
          case DioErrorType.RESPONSE:
            switch (exception.response.statusCode) {
              case 400:
                dialogMessage = ErrorDialogMessage.badRequest;
                break;
              case 401:
                dialogMessage = ErrorDialogMessage.authorizationError;
                break;
              case 403:
                dialogMessage = ErrorDialogMessage.forbidden;
                break;
              case 404:
                dialogMessage = ErrorDialogMessage.resourceNotFound;
                break;
              case 405:
                dialogMessage = ErrorDialogMessage.methodNotAllowed;
                break;
              case 500:
                dialogMessage = ErrorDialogMessage.internalServerError;
                break;
              case 502:
                dialogMessage = ErrorDialogMessage.badGateway;
                break;
            }
            break;
          case DioErrorType.DEFAULT:
            dialogMessage = ErrorDialogMessage.connectionError;
            break;
          case DioErrorType.CANCEL:
            return;
        }
      }
      yield ShowDialog(message: dialogMessage);
    } else if (event is DismissErrorDialog) {
      yield NoError();
    }
  }
}

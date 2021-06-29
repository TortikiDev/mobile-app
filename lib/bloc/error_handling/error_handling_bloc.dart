import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../pick_city/null_location_exception.dart';
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
      } else if (exception is NullLocationException) {
        dialogMessage = ErrorDialogMessage.failedToGetLocation;
      } else if (exception is DioError) {
        switch (exception.type) {
          case DioErrorType.sendTimeout:
          case DioErrorType.connectTimeout:
          case DioErrorType.receiveTimeout:
            dialogMessage = ErrorDialogMessage.connectionTimeout;
            break;
          case DioErrorType.response:
            switch (exception.response?.statusCode) {
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
          case DioErrorType.other:
            dialogMessage = ErrorDialogMessage.connectionError;
            break;
          case DioErrorType.cancel:
            return;
        }
      }
      yield ShowDialog(message: dialogMessage);
    } else if (event is DismissErrorDialog) {
      yield NoError();
    }
  }
}

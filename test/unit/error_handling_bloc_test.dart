@Timeout(Duration(seconds: 10))
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tortiki/bloc/error_handling/index.dart';

void main() {
  ErrorHandlingBloc sut;
  final initialState = NoError();

  setUp(() {
    sut = ErrorHandlingBloc();
  });

  tearDown(() {
    sut?.close();
  });

  test('initial state is correct', () {
    expect(sut.state, initialState);
  });

  test('close does not emit new states', () {
    sut.close();
    expectLater(
      sut,
      emitsDone,
    );
  });

  test('raise possible exceptions and dismiss dialogs after each', () {
    // given
    final exceptions = <Exception>[
      TimeoutException('123'),
      DioError(type: DioErrorType.SEND_TIMEOUT),
      DioError(type: DioErrorType.CONNECT_TIMEOUT),
      DioError(type: DioErrorType.RECEIVE_TIMEOUT),
      DioError(
          type: DioErrorType.RESPONSE, response: Response(statusCode: 400)),
      DioError(
          type: DioErrorType.RESPONSE, response: Response(statusCode: 401)),
      DioError(
          type: DioErrorType.RESPONSE, response: Response(statusCode: 403)),
      DioError(
          type: DioErrorType.RESPONSE, response: Response(statusCode: 404)),
      DioError(
          type: DioErrorType.RESPONSE, response: Response(statusCode: 405)),
      DioError(
          type: DioErrorType.RESPONSE, response: Response(statusCode: 500)),
      DioError(
          type: DioErrorType.RESPONSE, response: Response(statusCode: 502)),
      DioError(type: DioErrorType.DEFAULT),
      DioError(type: DioErrorType.CANCEL),
      Exception()
    ];

    // when
    for (final exception in exceptions) {
      sut.add(ExceptionRaised(exception));
      sut.add(DismissErrorDialog());
    }

    // then
    expectLater(
      sut,
      emitsInOrder([
        ShowDialog(message: ErrorDialogMessage.connectionTimeout),
        NoError(),
        ShowDialog(message: ErrorDialogMessage.connectionTimeout),
        NoError(),
        ShowDialog(message: ErrorDialogMessage.connectionTimeout),
        NoError(),
        ShowDialog(message: ErrorDialogMessage.connectionTimeout),
        NoError(),
        ShowDialog(message: ErrorDialogMessage.badRequest),
        NoError(),
        ShowDialog(message: ErrorDialogMessage.authorizationError),
        NoError(),
        ShowDialog(message: ErrorDialogMessage.forbidden),
        NoError(),
        ShowDialog(message: ErrorDialogMessage.resourceNotFound),
        NoError(),
        ShowDialog(message: ErrorDialogMessage.methodNotAllowed),
        NoError(),
        ShowDialog(message: ErrorDialogMessage.internalServerError),
        NoError(),
        ShowDialog(message: ErrorDialogMessage.badGateway),
        NoError(),
        ShowDialog(message: ErrorDialogMessage.connectionError),
        NoError(),
        ShowDialog(message: ErrorDialogMessage.somethingWentWrong),
        NoError()
      ]),
    );
  });

  test(
      'will take first exception from multiple raised exceptions'
      ' until dismiss dialog', () {
    // given
    final exceptions = <Exception>[
      TimeoutException('123'),
      DioError(type: DioErrorType.SEND_TIMEOUT),
      DioError(type: DioErrorType.CONNECT_TIMEOUT),
    ];

    // when
    for (final exception in exceptions) {
      sut.add(ExceptionRaised(exception));
    }
    sut.add(DismissErrorDialog());
    sut.add(ExceptionRaised(DioError(type: DioErrorType.DEFAULT)));

    // then
    expectLater(
      sut,
      emitsInOrder([
        ShowDialog(message: ErrorDialogMessage.connectionTimeout),
        NoError(),
        ShowDialog(message: ErrorDialogMessage.connectionError)
      ]),
    );
  });
}

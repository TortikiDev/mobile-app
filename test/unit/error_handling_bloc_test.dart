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
      sut.stream,
      emitsDone,
    );
  });

  test('raise possible exceptions and dismiss dialogs after each', () {
    // given
    final options = RequestOptions(path: '/');
    final exceptions = <Exception>[
      TimeoutException('123'),
      DioError(requestOptions: options, type: DioErrorType.sendTimeout),
      DioError(requestOptions: options, type: DioErrorType.connectTimeout),
      DioError(requestOptions: options, type: DioErrorType.receiveTimeout),
      DioError(
          requestOptions: options,
          type: DioErrorType.response,
          response: Response(requestOptions: options, statusCode: 400)),
      DioError(
          requestOptions: options,
          type: DioErrorType.response,
          response: Response(requestOptions: options, statusCode: 401)),
      DioError(
          requestOptions: options,
          type: DioErrorType.response,
          response: Response(requestOptions: options, statusCode: 403)),
      DioError(
          requestOptions: options,
          type: DioErrorType.response,
          response: Response(requestOptions: options, statusCode: 404)),
      DioError(
          requestOptions: options,
          type: DioErrorType.response,
          response: Response(requestOptions: options, statusCode: 405)),
      DioError(
          requestOptions: options,
          type: DioErrorType.response,
          response: Response(requestOptions: options, statusCode: 500)),
      DioError(
          requestOptions: options,
          type: DioErrorType.response,
          response: Response(requestOptions: options, statusCode: 502)),
      DioError(requestOptions: options, type: DioErrorType.other),
      DioError(requestOptions: options, type: DioErrorType.cancel),
      Exception()
    ];

    // when
    for (final exception in exceptions) {
      sut.add(ExceptionRaised(exception));
      sut.add(DismissErrorDialog());
    }

    // then
    expectLater(
      sut.stream,
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
      DioError(
        requestOptions: RequestOptions(path: '/'),
        type: DioErrorType.sendTimeout,
      ),
      DioError(
        requestOptions: RequestOptions(path: '/'),
        type: DioErrorType.connectTimeout,
      ),
    ];

    // when
    for (final exception in exceptions) {
      sut.add(ExceptionRaised(exception));
    }
    sut.add(DismissErrorDialog());
    sut.add(ExceptionRaised(DioError(
      requestOptions: RequestOptions(path: '/'),
      type: DioErrorType.other,
    )));

    // then
    expectLater(
      sut.stream,
      emitsInOrder([
        ShowDialog(message: ErrorDialogMessage.connectionTimeout),
        NoError(),
        ShowDialog(message: ErrorDialogMessage.connectionError)
      ]),
    );
  });
}

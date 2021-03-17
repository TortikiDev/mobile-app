import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'error_handling/index.dart';

abstract class BaseBloc<Event, State> extends Bloc<Event, State> {
  final ErrorHandlingBloc errorHandlingBloc;

  BaseBloc({@required State initialState, @required this.errorHandlingBloc})
      : super(initialState);

  Future<T> invokeWithErrorCatching<T>(Future<T> Function() target) async {
    T result;
    try {
      result = await target();
    } on Exception catch (e) {
      errorHandlingBloc.add(ExceptionRaised(e));
    }
    return result;
  }
}

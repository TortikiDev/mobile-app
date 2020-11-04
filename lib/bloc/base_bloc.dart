import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'error_handling/index.dart';

abstract class BaseBloc<Event, State> extends Bloc<Event, State> {
  final ErrorHandlingBloc errorHandlingBloc;

  BaseBloc({@required State initialState, @required this.errorHandlingBloc})
      : super(initialState);
}

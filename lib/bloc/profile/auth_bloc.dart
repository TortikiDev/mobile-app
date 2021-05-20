import 'package:flutter/material.dart';
import 'package:tortiki/bloc/base_bloc.dart';
import 'package:tortiki/bloc/error_handling/index.dart';
import 'package:tortiki/bloc/profile/auth_event.dart';
import 'package:tortiki/bloc/profile/auth_state.dart';

import 'index.dart';
import '../base_bloc.dart';

class AuthBloc extends BaseBloc<AuthEvent, AuthState> {
  final AuthParts authParts;

  AuthBloc(
      {@required this.authParts, @required ErrorHandlingBloc errorHandlingBloc})
      : super(
            initialState: AuthState.initial(),
            errorHandlingBloc: errorHandlingBloc);

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) {
    if (event is BlocInit) {
      state.authParts.toString();
      print('work this');
      errorHandlingBloc.add(ExceptionRaised(Exception()));
    }
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }
}

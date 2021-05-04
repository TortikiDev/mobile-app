import 'dart:async';

import 'package:flutter/foundation.dart';

import '../base_bloc.dart';
import '../error_handling/index.dart';
import 'index.dart';

class ExternalConfectionerProfileBloc extends BaseBloc<
    ExternalConfectionerProfileEvent, ExternalConfectionerProfileState> {
  // region Properties

  // endregion

  // region Lifecycle

  ExternalConfectionerProfileBloc(
      {@required ErrorHandlingBloc errorHandlingBloc})
      : super(
            initialState: ExternalConfectionerProfileState.initial(),
            errorHandlingBloc: errorHandlingBloc);

  @override
  Stream<ExternalConfectionerProfileState> mapEventToState(
      ExternalConfectionerProfileEvent event) async* {
    // TODO: implement event to state mapping
  }

  // endregion
}

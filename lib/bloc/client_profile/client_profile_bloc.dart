import 'dart:async';

import 'package:flutter/foundation.dart';

import '../base_bloc.dart';
import '../error_handling/index.dart';
import 'index.dart';

class ClientProfileBloc extends BaseBloc<ClientProfileEvent, ClientProfileState> {
  // region Properties

  // endregion

  // region Lifecycle

  ClientProfileBloc({@required ErrorHandlingBloc errorHandlingBloc})
      : super(
            initialState: ClientProfileState.initial(), 
            errorHandlingBloc: errorHandlingBloc);

  @override
  Stream<ClientProfileState> mapEventToState(ClientProfileEvent event) async* {
    // TODO: implement event to state mapping
  }

  // endregion
}

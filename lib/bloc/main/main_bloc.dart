import 'dart:async';

import 'package:flutter/foundation.dart';

import '../base_bloc.dart';
import '../error_handling/index.dart';
import 'index.dart';

class MainBloc extends BaseBloc<MainEvent, MainState> {
  // region Properties

  // endregion

  // region Lifecycle

  MainBloc({@required ErrorHandlingBloc errorHandlingBloc})
      : super(initialState: MainState(), errorHandlingBloc: errorHandlingBloc);

  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    // TODO: implement event to state mapping
  }

  // endregion
}

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../base_bloc.dart';
import '../error_handling/index.dart';
import 'index.dart';

class MapBloc extends BaseBloc<MapEvent, MapState> {
  // region Properties

  // endregion

  // region Lifecycle

  MapBloc({@required ErrorHandlingBloc errorHandlingBloc})
      : super(
            initialState: MapState.initial(), 
            errorHandlingBloc: errorHandlingBloc);

  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {
    // TODO: implement event to state mapping
  }

  // endregion
}

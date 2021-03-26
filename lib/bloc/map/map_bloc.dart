import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:tortiki/data/http_client/requests/lat_long.dart';

import '../../data/repositories/repositories.dart';
import '../base_bloc.dart';
import '../error_handling/index.dart';
import 'index.dart';

class MapBloc extends BaseBloc<MapEvent, MapState> {
  // region Properties

  final ConfectionersRepository confectionersRepository;

  // endregion

  // region Lifecycle

  MapBloc({
    @required this.confectionersRepository,
    @required ErrorHandlingBloc errorHandlingBloc,
  }) : super(
          initialState: MapState.initial(),
          errorHandlingBloc: errorHandlingBloc,
        );

  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {
    if (event is UpdateMapCenter) {
      final mapCenter = LatLong(
        event.coordinate.latitude,
        event.coordinate.latitude,
      );
      
      yield state.copy(mapCenter: mapCenter, loading: true);
      final confectioners = await confectionersRepository.getConfectioners(
        mapCenter: mapCenter,
      );
      yield state.copy(confectioners: confectioners, loading: false);
    }
  }

  // endregion
}

import 'package:equatable/equatable.dart';

import '../../data/http_client/requests/requests.dart';

abstract class MapEvent extends Equatable {}

class BlocInit extends MapEvent {
  @override
  List<Object> get props => [];
}

class UpdateMapCenter extends MapEvent {
  final LatLong coordinate;

  UpdateMapCenter(this.coordinate);

  @override
  List<Object> get props => [coordinate];
}

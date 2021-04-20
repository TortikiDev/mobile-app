import 'package:equatable/equatable.dart';
import 'package:latlong/latlong.dart';

abstract class MapEvent extends Equatable {}

class BlocInit extends MapEvent {
  @override
  List<Object> get props => [];
}

class UpdateMapCenter extends MapEvent {
  final LatLng coordinate;

  UpdateMapCenter(this.coordinate);

  @override
  List<Object> get props => [coordinate];
}

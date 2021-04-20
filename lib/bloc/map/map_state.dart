import 'package:equatable/equatable.dart';

import '../../data/http_client/requests/requests.dart';
import '../../data/http_client/responses/responses.dart';

class MapState extends Equatable {
  final LatLong mapCenter;
  final List<ConfectionerShortResponse> _confectioners;
  final bool loading;

  List<ConfectionerShortResponse> get confectioners => List.of(_confectioners);

  const MapState({
    this.mapCenter,
    List<ConfectionerShortResponse> confectioners = const [],
    this.loading = false,
  }) : _confectioners = confectioners;

  factory MapState.initial() => MapState();

  MapState copy({
    LatLong mapCenter,
    List<ConfectionerShortResponse> confectioners,
    bool loading,
  }) =>
      MapState(
        mapCenter: mapCenter ?? this.mapCenter,
        confectioners: confectioners ?? _confectioners,
        loading: loading ?? this.loading,
      );

  @override
  List<Object> get props => [
        mapCenter,
        _confectioners,
        loading,
      ];

  @override
  bool get stringify => true;
}

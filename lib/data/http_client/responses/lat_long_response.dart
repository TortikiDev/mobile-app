import 'package:equatable/equatable.dart';

class LatLongResponse extends Equatable {
  final double lat;
  final double long;

  LatLongResponse(this.lat, this.long);

  LatLongResponse copy({
    double lat,
    double long,
  }) =>
      LatLongResponse(
        lat ?? this.lat,
        long ?? this.long,
      );

  @override
  List<Object> get props => [lat, long];

  @override
  bool get stringify => true;
}

import 'package:equatable/equatable.dart';

class LatLong extends Equatable {
  final double lat;
  final double long;

  LatLong(this.lat, this.long);

  LatLong copy({
    double? lat,
    double? long,
  }) =>
      LatLong(
        lat ?? this.lat,
        long ?? this.long,
      );

  @override
  List<Object?> get props => [lat, long];

  @override
  bool get stringify => true;
}

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../lat_long_response.dart';

class ConfectionerShortResponse extends Equatable {
  final int id;
  final String name;
  final String address;

  /// Confectioner's gender from [Gender]
  final int gender;
  final String avatarUrl;
  final LatLongResponse coordinate;

  /// Star type from [ConfectionerRatingStarType]
  final int starType;
  final int rating;

  ConfectionerShortResponse({
    @required this.id,
    @required this.name,
    @required this.address,
    @required this.gender,
    @required this.avatarUrl,
    @required this.starType,
    @required this.rating,
    @required this.coordinate,
  });

  ConfectionerShortResponse copy({
    int id,
    String name,
    String address,
    int gender,
    String avatarUrl,
    int starType,
    int rating,
    LatLongResponse coordinate,
  }) =>
      ConfectionerShortResponse(
        id: id ?? this.id,
        name: name ?? this.name,
        address: address ?? this.address,
        gender: gender ?? this.gender,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        starType: starType ?? this.starType,
        rating: rating ?? this.rating,
        coordinate: coordinate ?? this.coordinate,
      );

  @override
  List<Object> get props => [
        id,
        name,
        address,
        gender,
        avatarUrl,
        starType,
        rating,
        coordinate,
      ];

  @override
  bool get stringify => true;
}

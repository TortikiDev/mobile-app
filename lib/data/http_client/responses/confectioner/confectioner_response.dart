import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../lat_long_response.dart';

class ConfectionerResponse extends Equatable {
  final int id;
  final String name;
  final String address;
  final String about;

  /// Confectioner's gender from [Gender]
  final int gender;
  final String avatarUrl;
  final LatLongResponse coordinate;

  /// Star type from [ConfectionerRatingStarType]
  final int starType;
  final int rating;

  ConfectionerResponse({
    @required this.id,
    @required this.name,
    @required this.address,
    @required this.about,
    @required this.gender,
    @required this.avatarUrl,
    @required this.starType,
    @required this.rating,
    @required this.coordinate,
  });

  ConfectionerResponse copy({
    int id,
    String name,
    String address,
    String about,
    int gender,
    String avatarUrl,
    int starType,
    int rating,
    LatLongResponse coordinate,
  }) =>
      ConfectionerResponse(
        id: id ?? this.id,
        name: name ?? this.name,
        address: address ?? this.address,
        about: about ?? this.about,
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
        about,
        gender,
        avatarUrl,
        starType,
        rating,
        coordinate,
      ];

  @override
  bool get stringify => true;
}

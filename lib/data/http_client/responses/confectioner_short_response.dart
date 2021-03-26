import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class ConfectionerShortResponse extends Equatable {
  final String name;
  final String address;
  final String avatarUrl;
  final double lat;
  final double long;

  /// Star type from [ConfectionerRatingStarType]
  final int starType;
  final int rating;

  ConfectionerShortResponse({
    @required this.name,
    @required this.address,
    @required this.avatarUrl,
    @required this.starType,
    @required this.rating,
    @required this.lat,
    @required this.long,
  });

  ConfectionerShortResponse copy({
    String name,
    String address,
    String avatarUrl,
    int starType,
    int rating,
    double lat,
    double long,
  }) =>
      ConfectionerShortResponse(
        name: name ?? this.name,
        address: address ?? this.address,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        starType: starType ?? this.starType,
        rating: rating ?? this.rating,
        lat: lat ?? this.lat,
        long: long ?? this.long,
      );

  @override
  List<Object> get props => [
        name,
        address,
        avatarUrl,
        starType,
        rating,
        lat,
        long,
      ];

  @override
  bool get stringify => true;
}

class ConfectionerRatingStarType {
  static const none = 0;
  static const bronze = 1;
  static const silver = 2;
  static const gold = 3;
}

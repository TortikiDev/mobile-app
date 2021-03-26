import 'package:flutter/foundation.dart';

import '../http_client/responses/responses.dart';

class ConfectionersRepository {
  Future<List<ConfectionerShortResponse>> getConfectioners({
    @required double userLat,
    @required double userLong,
    String searchQuery,
    int limit = 24,
    int lastId,
  }) async {
    await Future.delayed(Duration(seconds: 2));
    return [
      ConfectionerShortResponse(
        name: 'Мила Кунис',
        address: 'ул. Островского, 26а',
        avatarUrl:
            'https://images.unsplash.com/photo-1510616022132-9976466385a8',
        starType: ConfectionerRatingStarType.silver,
        rating: 56,
        lat: 54.652,
        long: 39.862,
      ),
      ConfectionerShortResponse(
        name: 'Билли',
        address: 'ул. Островского, 27а',
        avatarUrl:
            'https://images.unsplash.com/photo-1486427944299-d1955d23e34d',
        starType: ConfectionerRatingStarType.none,
        rating: 1,
        lat: 54.600,
        long: 39.842,
      ),
      ConfectionerShortResponse(
        name: 'Михаил Круг',
        address: 'ул. Островского, 28а',
        avatarUrl:
            'https://images.unsplash.com/photo-1510616022132-9976466385a8',
        starType: ConfectionerRatingStarType.gold,
        rating: 433,
        lat: 54.595,
        long: 39.862,
      ),
    ];
  }
}

import 'package:flutter/material.dart';

import '../data/http_client/responses/confectioner_short_response.dart';

/// Returns color for confecctioner's rating star
/// [ratingStarType] - value from [ConfectionerRatingStarType]
Color getRatignStarColor(int ratingStarType) {
  switch (ratingStarType) {
    case ConfectionerRatingStarType.bronze:
      return Color(0xFFBcd7f32);
    case ConfectionerRatingStarType.silver:
      return Color(0xFFBDBDBD);
    case ConfectionerRatingStarType.gold:
      return Color(0xFFFFC107);
    default:
      return Colors.transparent;
  }
}

import 'package:equatable/equatable.dart';

import '../../../../../data/http_client/responses/responses.dart';
import '../../../../reusable/list_items/list_item.dart';

class ConfectionerViewModel extends Equatable implements ListItem {
  final int id;
  final String name;
  final String address;
  final int gender;
  final String? avatarUrl;
  final LatLongResponse coordinate;

  /// Star type from [ConfectionerRatingStarType]
  final int starType;
  final int rating;

  ConfectionerViewModel({
    required this.id,
    required this.name,
    required this.address,
    required this.gender,
    required this.avatarUrl,
    required this.coordinate,
    required this.starType,
    required this.rating,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        gender,
        avatarUrl,
        coordinate,
        starType,
        rating,
      ];

  @override
  bool get stringify => true;
}

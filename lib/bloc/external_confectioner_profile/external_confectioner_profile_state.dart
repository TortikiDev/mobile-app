import 'package:equatable/equatable.dart';

import '../../data/http_client/responses/responses.dart';

class ExternalConfectionerProfileState extends Equatable {
  final ConfectionerResponse confectioner;
  final bool loading;

  const ExternalConfectionerProfileState({
    this.confectioner,
    this.loading = false,
  });

  factory ExternalConfectionerProfileState.initial() =>
      ExternalConfectionerProfileState(
          confectioner: ConfectionerResponse(
        id: 3,
        name: 'Михаил Круг',
        gender: Gender.male,
        address: 'ул. Островского, 28а',
        about: 'Люблю готовить тортики 🎂. По любым вопросам'
            ' пишите мне в соцсетях или или на почту',
        avatarUrl:
            'https://images.unsplash.com/photo-1510616022132-9976466385a8',
        starType: ConfectionerRatingStarType.gold,
        rating: 433,
        coordinate: LatLongResponse(54.602, 39.863),
      ));

  @override
  List<Object> get props => [confectioner, loading];
}

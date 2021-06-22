import '../http_client/requests/requests.dart';
import '../http_client/responses/lat_long_response.dart';
import '../http_client/responses/responses.dart';

// TODO: get actual data from server
class ConfectionersRepository {
  Future<List<ConfectionerShortResponse>> getConfectioners({
    required LatLong mapCenter,
    String? searchQuery,
    int limit = 24,
    int? lastId,
  }) async {
    await Future.delayed(Duration(seconds: 2));
    return [
      ConfectionerShortResponse(
        id: 1,
        name: 'Мила Кунис',
        address: 'ул. Островского, 26а',
        gender: Gender.female,
        avatarUrl:
            'https://images.unsplash.com/photo-1510616022132-9976466385a8',
        starType: ConfectionerRatingStarType.silver,
        rating: 56,
        coordinate: LatLongResponse(54.605, 39.862),
      ),
      ConfectionerShortResponse(
        id: 2,
        name: 'Билли',
        address: 'ул. Островского, 27а',
        gender: Gender.none,
        avatarUrl:
            'https://images.unsplash.com/photo-1486427944299-d1955d23e34d',
        starType: ConfectionerRatingStarType.none,
        rating: 1,
        coordinate: LatLongResponse(54.601, 39.863),
      ),
      ConfectionerShortResponse(
        id: 3,
        name: 'Михаил Круг',
        gender: Gender.male,
        address: 'ул. Островского, 28а',
        avatarUrl:
            null, //https://images.unsplash.com/photo-1510616022132-9976466385a8',
        starType: ConfectionerRatingStarType.gold,
        rating: 433,
        coordinate: LatLongResponse(54.602, 39.863),
      ),
    ];
  }

  Future<ConfectionerResponse> getConfectionerDetails({required int id}) async {
    await Future.delayed(Duration(seconds: 2));
    return ConfectionerResponse(
      id: 3,
      name: 'Михаил Круг',
      gender: Gender.male,
      address: 'ул. Островского, 28а',
      about: 'Люблю готовить тортики 🎂. По любым вопросам'
          ' пишите мне в соцсетях или или на почту',
      avatarUrl:
          null, //'https://images.unsplash.com/photo-1510616022132-9976466385a8',
      starType: ConfectionerRatingStarType.gold,
      rating: 433,
      coordinate: LatLongResponse(54.602, 39.863),
    );
  }
}

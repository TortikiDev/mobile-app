@Timeout(Duration(seconds: 10))
import 'package:flutter_test/flutter_test.dart';
import 'package:tortiki/bloc/error_handling/index.dart';
import 'package:tortiki/bloc/search_confectioners/index.dart';
import 'package:tortiki/data/http_client/requests/requests.dart';
import 'package:tortiki/data/http_client/responses/responses.dart';
import 'package:tortiki/data/repositories/repositories.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tortiki/ui/reusable/list_items/list_item.dart';
import 'package:tortiki/ui/reusable/list_items/progress_indicator_item.dart';
import 'package:tortiki/ui/screens/map/search_confectioners/confectioner/confectioner_view_model.dart';

class _MockErrorHandlingBloc extends Mock implements ErrorHandlingBloc {}

class _MockConfectionersRepository extends Mock
    implements ConfectionersRepository {}

void main() {
  late SearchConfectionersBloc sut;
  late _MockErrorHandlingBloc errorHandlingBloc;
  late _MockConfectionersRepository confectionersRepository;

  final mapCenter = LatLong(50.5, 30.7);
  final initialState = SearchConfectionersState.initial(mapCenter: mapCenter);

  setUp(() {
    confectionersRepository = _MockConfectionersRepository();
    errorHandlingBloc = _MockErrorHandlingBloc();

    sut = SearchConfectionersBloc(
      mapCenter: mapCenter,
      confectionersRepository: confectionersRepository,
      errorHandlingBloc: errorHandlingBloc,
    );
  });

  tearDown(() {
    sut.close();
  });

  test('initial state is correct', () {
    expect(sut.state, initialState);
  });

  test('close does not emit new states', () {
    sut.close();
    expectLater(
      sut.stream,
      emitsDone,
    );
  });

  test('SearchQueryChanged loades recipes with search query', () async {
    // given
    final expectedState1 =
        initialState.copy(loadingFirstPage: true, searchQuery: 'Max');
    final expectedState2 = expectedState1.copy(
      listItems: [
        ConfectionerViewModel(
          id: 21,
          name: 'Maximus',
          address: '123 Baker street',
          gender: Gender.male,
          coordinate: LatLongResponse(51, 30.5),
          starType: ConfectionerRatingStarType.gold,
          rating: 500,
          avatarUrl: 'http://url0.png',
        ),
        ConfectionerViewModel(
          id: 22,
          name: 'Maximal',
          address: '124 Baker street',
          gender: Gender.female,
          coordinate: LatLongResponse(52, 30.5),
          starType: ConfectionerRatingStarType.none,
          rating: 5,
          avatarUrl: 'http://url1.png',
        ),
      ],
      loadingFirstPage: false,
    );
    // when
    when(() => confectionersRepository.getConfectioners(
        searchQuery: 'Max', mapCenter: mapCenter)).thenAnswer(
      (realInvocation) => Future.value([
        ConfectionerShortResponse(
          id: 21,
          name: 'Maximus',
          address: '123 Baker street',
          gender: Gender.male,
          coordinate: LatLongResponse(51, 30.5),
          starType: ConfectionerRatingStarType.gold,
          rating: 500,
          avatarUrl: 'http://url0.png',
        ),
        ConfectionerShortResponse(
          id: 22,
          name: 'Maximal',
          address: '124 Baker street',
          gender: Gender.female,
          coordinate: LatLongResponse(52, 30.5),
          starType: ConfectionerRatingStarType.none,
          rating: 5,
          avatarUrl: 'http://url1.png',
        ),
      ]),
    );
    sut.add(SearchQueryChanged('Max'));
    // then
    expectLater(
      sut.stream,
      emitsInOrder([
        expectedState1,
        expectedState2,
      ]),
    );
  });

  test('LoadNextPage loads recipes next page', () {
    // given
    final initialItems = <ListItem>[
      ConfectionerViewModel(
        id: 21,
        name: 'Maximus',
        address: '123 Baker street',
        gender: Gender.male,
        coordinate: LatLongResponse(51, 30.5),
        starType: ConfectionerRatingStarType.gold,
        rating: 500,
        avatarUrl: 'http://url0.png',
      ),
    ];
    final recipesNextPageResponse = [
      ConfectionerShortResponse(
        id: 22,
        name: 'Maximus',
        address: '1234 Baker street',
        gender: Gender.male,
        coordinate: LatLongResponse(51, 30.5),
        starType: ConfectionerRatingStarType.gold,
        rating: 500,
        avatarUrl: 'http://url1.png',
      ),
      ConfectionerShortResponse(
        id: 23,
        name: 'Maximus',
        address: '1235 Baker street',
        gender: Gender.male,
        coordinate: LatLongResponse(51, 30.5),
        starType: ConfectionerRatingStarType.silver,
        rating: 50,
        avatarUrl: 'http://url2.png',
      ),
      ConfectionerShortResponse(
        id: 4,
        name: 'Maximus',
        address: '1236 Baker street',
        gender: Gender.male,
        coordinate: LatLongResponse(51, 30.5),
        starType: ConfectionerRatingStarType.bronze,
        rating: 5,
        avatarUrl: 'http://url3.png',
      ),
    ];

    final baseState = initialState.copy(listItems: initialItems);
    final expectedState1 = baseState.copy(
      listItems: initialItems + [ProgressIndicatorItem()],
      loadingNextPage: true,
    );
    final expectedState2 = expectedState1.copy(
      listItems: [
        ConfectionerViewModel(
          id: 21,
          name: 'Maximus',
          address: '123 Baker street',
          gender: Gender.male,
          coordinate: LatLongResponse(51, 30.5),
          starType: ConfectionerRatingStarType.gold,
          rating: 500,
          avatarUrl: 'http://url0.png',
        ),
        ConfectionerViewModel(
          id: 22,
          name: 'Maximus',
          address: '1234 Baker street',
          gender: Gender.male,
          coordinate: LatLongResponse(51, 30.5),
          starType: ConfectionerRatingStarType.gold,
          rating: 500,
          avatarUrl: 'http://url1.png',
        ),
        ConfectionerViewModel(
          id: 23,
          name: 'Maximus',
          address: '1235 Baker street',
          gender: Gender.male,
          coordinate: LatLongResponse(51, 30.5),
          starType: ConfectionerRatingStarType.silver,
          rating: 50,
          avatarUrl: 'http://url2.png',
        ),
        ConfectionerViewModel(
          id: 4,
          name: 'Maximus',
          address: '1236 Baker street',
          gender: Gender.male,
          coordinate: LatLongResponse(51, 30.5),
          starType: ConfectionerRatingStarType.bronze,
          rating: 5,
          avatarUrl: 'http://url3.png',
        ),
      ],
      loadingNextPage: false,
    );
    // when
    when(() => confectionersRepository.getConfectioners(
            mapCenter: mapCenter, lastId: 21))
        .thenAnswer((realInvocation) => Future.value(recipesNextPageResponse));
    sut.emit(baseState);
    sut.add(LoadNextPage());
    // then
    expect(
      sut.stream,
      emitsInOrder([
        expectedState1,
        expectedState2,
      ]),
    );
  });
}

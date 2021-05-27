@Timeout(Duration(seconds: 10))
import 'package:flutter_test/flutter_test.dart';
import 'package:tortiki/bloc/error_handling/index.dart';
import 'package:tortiki/bloc/map/index.dart';
import 'package:tortiki/data/http_client/requests/requests.dart';
import 'package:tortiki/data/http_client/responses/responses.dart';
import 'package:latlong/latlong.dart';
import 'package:tortiki/data/repositories/repositories.dart';
import 'package:mockito/mockito.dart';
import 'package:tortiki/ui/constants.dart';

class _MockErrorHandlingBloc extends Mock implements ErrorHandlingBloc {}

class _MockConfectionersRepository extends Mock
    implements ConfectionersRepository {}

void main() {
  MapBloc sut;
  _MockErrorHandlingBloc errorHandlingBloc;
  _MockConfectionersRepository confectionersRepository;

  final initialState = MapState.initial();

  setUp(() {
    confectionersRepository = _MockConfectionersRepository();
    errorHandlingBloc = _MockErrorHandlingBloc();

    sut = MapBloc(
      confectionersRepository: confectionersRepository,
      errorHandlingBloc: errorHandlingBloc,
    );
  });

  tearDown(() {
    sut?.close();
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

  test('BlocInit loads confectioners', () {
    // given
    final mapCenter = LatLong(
      Constants.defaultMapCenter.latitude,
      Constants.defaultMapCenter.longitude,
    );
    final confectionersStub = [
      ConfectionerShortResponse(
        id: 123,
        name: '123',
        address: '321',
        avatarUrl: null,
        gender: 1,
        starType: 2,
        rating: 32,
        coordinate: LatLongResponse(54, 36),
      ),
      ConfectionerShortResponse(
        id: 124,
        name: 'rbwt',
        address: 'ewf 43',
        avatarUrl: 'http://avatar.png',
        gender: 2,
        starType: 1,
        rating: 0,
        coordinate: LatLongResponse(54, 36),
      )
    ];

    final expectedState1 =
        initialState.copy(mapCenter: mapCenter, loading: true);
    final expectedState2 =
        expectedState1.copy(confectioners: confectionersStub, loading: false);
    // when
    when(confectionersRepository.getConfectioners(mapCenter: mapCenter))
        .thenAnswer((realInvocation) => Future.value(confectionersStub));
    sut.add(BlocInit());
    // then
    expectLater(
      sut.stream,
      emitsInOrder([expectedState1, expectedState2]),
    );
  });

  test('UpdateMapCenter loads confectioners', () async {
    // given
    final confectionersStub = [
      ConfectionerShortResponse(
        id: 123,
        name: '123',
        address: '321',
        avatarUrl: null,
        gender: 1,
        starType: 2,
        rating: 32,
        coordinate: LatLongResponse(54, 36),
      ),
      ConfectionerShortResponse(
        id: 124,
        name: 'rbwt',
        address: 'ewf 43',
        avatarUrl: 'http://avatar.png',
        gender: 2,
        starType: 1,
        rating: 0,
        coordinate: LatLongResponse(54, 36),
      )
    ];

    final expectedState1 =
        initialState.copy(mapCenter: LatLong(57, 34), loading: true);
    final expectedState2 =
        expectedState1.copy(confectioners: confectionersStub, loading: false);
    // when
    when(confectionersRepository.getConfectioners(mapCenter: LatLong(57, 34)))
        .thenAnswer((realInvocation) => Future.value(confectionersStub));
    sut.add(UpdateMapCenter(LatLng(57, 34)));
    // then
    expectLater(
      sut.stream,
      emitsInOrder([expectedState1, expectedState2]),
    );
  });
}

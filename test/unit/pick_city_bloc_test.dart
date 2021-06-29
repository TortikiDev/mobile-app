@Timeout(Duration(seconds: 10))
import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart';
import 'package:tortiki/bloc/error_handling/index.dart';
import 'package:tortiki/bloc/pick_city/index.dart';
import 'package:tortiki/data/repositories/repositories.dart';
import 'package:mocktail/mocktail.dart';

class _MockErrorHandlingBloc extends Mock implements ErrorHandlingBloc {}

class _MockCitiesRepository extends Mock implements CitiesRepository {}

class _MockLocationService extends Mock implements Location {}

class _MockGeocodingSevice extends Mock implements geocoding.GeocodingPlatform {
}

void main() {
  late PickCityBloc sut;
  late _MockErrorHandlingBloc errorHandlingBloc;
  late _MockCitiesRepository citiesRepository;
  late _MockLocationService locationService;
  late _MockGeocodingSevice geocodingService;

  final selectedCity = 'Rzn';
  final initialState = PickCityState.initial(selectedCity: selectedCity);

  setUp(() {
    citiesRepository = _MockCitiesRepository();
    locationService = _MockLocationService();
    geocodingService = _MockGeocodingSevice();
    errorHandlingBloc = _MockErrorHandlingBloc();

    sut = PickCityBloc(
      selectedCity: selectedCity,
      citiesRepository: citiesRepository,
      locationService: locationService,
      geocodingService: geocodingService,
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

  test('BlocInit emits all cities', () {
    // given
    final cities = ['Msc', 'Rzn'];
    final excpectedState = initialState.copy(
      allCities: cities,
      citiesToShow: cities,
    );
    // when
    when(() => citiesRepository.getCities()).thenAnswer(
      (invocation) => Future.value(cities),
    );
    sut.add(BlocInit());
    // then
    expect(
      sut.stream,
      emits(excpectedState),
    );
  });

  test('SearchQueryChanged emits state with filtered cities', () {
    // given
    final cities = ['Msc', 'Rzn'];
    final baseState = initialState.copy(
      allCities: cities,
      citiesToShow: cities,
    );
    final expectedState = baseState.copy(
      searchQuery: 'MS',
      citiesToShow: ['Msc'],
    );
    // when
    sut.emit(baseState);
    sut.add(SearchQueryChanged('MS'));
    // then
    expect(
      sut.stream,
      emits(expectedState),
    );
  });

  test('SelectCity emits state with selected city', () async {
    // given
    // when
    sut.add(SelectCity('Msc'));
    // then
    expect(
      sut.stream,
      emits(initialState.copy(selectedCity: 'Msc')),
    );
  });

  test(
      'GetLocationFromServices emits state with detected and selected city'
      'on matching success', () async {
    // given
    final cities = ['Msc', 'Rzn'];
    final rznLat = 54.629565;
    final rznLong = 39.741917;
    final locationResult = LocationData.fromMap({
      'latitude': rznLat,
      'longitude': rznLong,
    });
    final geocodingPlacesResult = [geocoding.Placemark(locality: 'rzn')];

    final baseState = initialState.copy(
      allCities: cities,
      citiesToShow: cities,
    );
    final expectedState1 = baseState.copy(
      detectingCity: true,
      detectedCityNotAllowed: false,
      removeDetectedCity: true,
    );
    final expectedState2 = expectedState1.copy(
      selectedCity: 'Rzn',
      detectingCity: false,
      detectedCity: 'Rzn',
    );
    // when
    when(() => locationService.getLocation()).thenAnswer(
      (invocation) => Future.value(locationResult),
    );
    when(
      () => geocodingService.placemarkFromCoordinates(rznLat, rznLong),
    ).thenAnswer(
      (invocation) => Future.value(geocodingPlacesResult),
    );
    sut.emit(baseState);
    sut.add(GetLocationFromServices());
    // then
    expect(
      sut.stream,
      emitsInOrder([expectedState1, expectedState2]),
    );
  });

  test(
      'GetLocationFromServices emits state without detected and selected city'
      'on matching failure', () async {
    // given
    final cities = ['Msc', 'Rzn'];
    final rznLat = 54.629565;
    final rznLong = 39.741917;
    final locationResult = LocationData.fromMap({
      'latitude': rznLat,
      'longitude': rznLong,
    });
    final geocodingPlacesResult = [geocoding.Placemark(locality: 'Spb')];

    final baseState = initialState.copy(
      allCities: cities,
      citiesToShow: cities,
    );
    final expectedState1 = baseState.copy(
      detectingCity: true,
      detectedCityNotAllowed: false,
      removeDetectedCity: true,
    );
    final expectedState2 = expectedState1.copy(
      detectingCity: false,
      detectedCity: 'Spb',
      detectedCityNotAllowed: true,
    );
    // when
    when(() => locationService.getLocation()).thenAnswer(
      (invocation) => Future.value(locationResult),
    );
    when(
      () => geocodingService.placemarkFromCoordinates(rznLat, rznLong),
    ).thenAnswer(
      (invocation) => Future.value(geocodingPlacesResult),
    );
    sut.emit(baseState);
    sut.add(GetLocationFromServices());
    // then
    expect(
      sut.stream,
      emitsInOrder([expectedState1, expectedState2]),
    );
  });
}

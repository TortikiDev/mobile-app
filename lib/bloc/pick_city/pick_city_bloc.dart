import 'dart:async';

import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart';

import '../../data/repositories/repositories.dart';
import '../base_bloc.dart';
import '../error_handling/index.dart';
import 'index.dart';
import 'null_location_exception.dart';

class PickCityBloc extends BaseBloc<PickCityEvent, PickCityState> {
  // region Properties

  final CitiesRepository citiesRepository;
  final Location locationService;

  // endregion

  // region Lifecycle

  PickCityBloc({
    required String selectedCity,
    required this.citiesRepository,
    required this.locationService,
    required ErrorHandlingBloc errorHandlingBloc,
  }) : super(
            initialState: PickCityState.initial(selectedCity: selectedCity),
            errorHandlingBloc: errorHandlingBloc);

  @override
  Stream<PickCityState> mapEventToState(PickCityEvent event) async* {
    if (event is BlocInit) {
      final cities = await citiesRepository.getCities();
      yield state.copy(allCities: cities, citiesToShow: cities);
    } else if (event is SearchQueryChanged) {
      final citiesToShow = state.allCities
          .where(
            (city) => city.toLowerCase().contains(event.query.toLowerCase()),
          )
          .toList();
      yield state.copy(
        searchQuery: event.query,
        citiesToShow: citiesToShow,
      );
    } else if (event is SelectCity) {
      yield state.copy(selectedCity: event.city);
    } else if (event is GetLocationFromServices) {
      yield state.copy(
        detectingCity: true,
        detectedCityNotAllowed: false,
        removeDetectedCity: true,
      );
      LocationData? locationResult;
      try {
        locationResult = await locationService.getLocation();
      } on Exception catch (e) {
        errorHandlingBloc.add(ExceptionRaised(e));
      }
      if (locationResult != null) {
        if (locationResult.latitude != null &&
            locationResult.longitude != null) {
          final placemarks = await geocoding.placemarkFromCoordinates(
              locationResult.latitude!, locationResult.longitude!);

          final cityMatches = state.allCities.where(
            (city) => placemarks
                .where((place) => place.locality != null)
                .map((place) => place.locality!.toLowerCase())
                .where((detectedCity) => city.contains(detectedCity))
                .isNotEmpty,
          );
          final isCityAllowed = cityMatches.isNotEmpty;
          if (isCityAllowed) {
            yield state.copy(
              selectedCity: cityMatches.first,
              detectingCity: false,
              detectedCity: cityMatches.first,
            );
          } else {
            yield state.copy(
              detectingCity: false,
              detectedCity: placemarks.first.locality ?? '',
              detectedCityNotAllowed: true,
            );
          }
        } else {
          yield state.copy(detectingCity: false);
          final exception = NullLocationException();
          errorHandlingBloc.add(ExceptionRaised(exception));
        }
      }
    }
  }

  // endregion
}

import 'dart:async';

import '../../data/repositories/repositories.dart';
import '../base_bloc.dart';
import '../error_handling/index.dart';
import 'index.dart';

class PickCityBloc extends BaseBloc<PickCityEvent, PickCityState> {
  // region Properties

  final CitiesRepository citiesRepository;

  // endregion

  // region Lifecycle

  PickCityBloc({
    required String selectedCity,
    required this.citiesRepository,
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
    }
  }

  // endregion
}

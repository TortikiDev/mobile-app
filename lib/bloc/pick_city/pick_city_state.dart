import 'package:equatable/equatable.dart';

class PickCityState extends Equatable {
  final List<String> allCities;
  final List<String> citiesToShow;
  final String selectedCity;
  final String searchQuery;
  final bool loading;

  const PickCityState({
    this.allCities = const [],
    this.citiesToShow = const [],
    required this.selectedCity,
    this.searchQuery = '',
    this.loading = false,
  });

  factory PickCityState.initial({
    required String selectedCity,
  }) =>
      PickCityState(selectedCity: selectedCity);

  PickCityState copy({
    List<String>? allCities,
    List<String>? citiesToShow,
    String? selectedCity,
    String? searchQuery,
    bool? loading,
  }) =>
      PickCityState(
        allCities: allCities ?? this.allCities,
        citiesToShow: citiesToShow ?? this.citiesToShow,
        selectedCity: selectedCity ?? this.selectedCity,
        searchQuery: searchQuery ?? this.searchQuery,
        loading: loading ?? this.loading,
      );

  @override
  List<Object?> get props => [
        allCities,
        citiesToShow,
        selectedCity,
        searchQuery,
        loading,
      ];
}

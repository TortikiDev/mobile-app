import 'package:equatable/equatable.dart';

abstract class PickCityEvent extends Equatable {}

class BlocInit extends PickCityEvent {
  @override
  List<Object?> get props => [];
}

class SearchQueryChanged extends PickCityEvent {
  final String query;

  SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class SelectCity extends PickCityEvent {
  final String city;

  SelectCity(this.city);

  @override
  List<Object?> get props => [city];
}

class GetLocationFromServices extends PickCityEvent {
  @override
  List<Object?> get props => [];
}

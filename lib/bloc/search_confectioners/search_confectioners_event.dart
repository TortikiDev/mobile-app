import 'package:equatable/equatable.dart';

abstract class SearchConfectionersEvent extends Equatable {}

class BlocInit extends SearchConfectionersEvent {
  @override
  List<Object?> get props => [];
}

class SearchQueryChanged extends SearchConfectionersEvent {
  final String query;

  SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class LoadNextPage extends SearchConfectionersEvent {
  @override
  List<Object?> get props => [];
}

import 'package:equatable/equatable.dart';

import '../../data/http_client/requests/requests.dart';
import '../../ui/reusable/list_items/list_item.dart';

class SearchConfectionersState extends Equatable {
  final LatLong mapCenter;
  final List<ListItem> _listItems;
  final bool loadingFirstPage;
  final bool loadingNextPage;
  final String? searchQuery;

  List<ListItem> get listItems => List.of(_listItems);

  SearchConfectionersState({
    required this.mapCenter,
    required List<ListItem> listItems,
    this.loadingFirstPage = false,
    this.loadingNextPage = false,
    this.searchQuery,
  }) : _listItems = listItems;

  factory SearchConfectionersState.initial({required LatLong mapCenter}) =>
      SearchConfectionersState(mapCenter: mapCenter, listItems: []);

  SearchConfectionersState copy({
    LatLong? mapCenter,
    List<ListItem>? listItems,
    bool? loadingFirstPage,
    bool? loadingNextPage,
    String? searchQuery,
    bool setSearchQueryToNull = false,
  }) =>
      SearchConfectionersState(
        mapCenter: mapCenter ?? this.mapCenter,
        listItems: listItems ?? _listItems,
        loadingFirstPage: loadingFirstPage ?? this.loadingFirstPage,
        loadingNextPage: loadingNextPage ?? this.loadingNextPage,
        searchQuery:
            setSearchQueryToNull ? null : (searchQuery ?? this.searchQuery),
      );

  @override
  List<Object?> get props => [
        mapCenter,
        _listItems,
        loadingFirstPage,
        loadingNextPage,
        searchQuery,
      ];

  @override
  bool get stringify => true;
}

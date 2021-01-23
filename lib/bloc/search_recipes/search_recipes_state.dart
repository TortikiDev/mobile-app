import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../ui/reusable/list_items/list_item.dart';

class SearchRecipesState extends Equatable {
  final List<ListItem> _listItems;
  final List<int> _bookmarkedRecipesIds;
  final bool loadingFirstPage;
  final bool loadingNextPage;
  final String searchQuery;

  List<ListItem> get listItems => _listItems;
  List<int> get bookmarkedRecipesIds => _bookmarkedRecipesIds;

  SearchRecipesState({
    @required List<ListItem> listItems,
    List<int> bookmarkedRecipesIds,
    this.loadingFirstPage = false,
    this.loadingNextPage = false,
    this.searchQuery,
  })  : _listItems = listItems,
        _bookmarkedRecipesIds = bookmarkedRecipesIds;

  factory SearchRecipesState.initial() => SearchRecipesState(listItems: []);

  SearchRecipesState copy({
    List<ListItem> listItems,
    List<int> bookmarkedRecipesIds,
    bool loadingFirstPage,
    bool loadingNextPage,
    String searchQuery,
  }) =>
      SearchRecipesState(
        listItems: listItems ?? _listItems,
        bookmarkedRecipesIds: bookmarkedRecipesIds ?? _bookmarkedRecipesIds,
        loadingFirstPage: loadingFirstPage ?? this.loadingFirstPage,
        loadingNextPage: loadingNextPage ?? this.loadingNextPage,
        searchQuery: searchQuery ?? this.searchQuery,
      );

  @override
  List<Object> get props => [
        _listItems,
        _bookmarkedRecipesIds,
        loadingFirstPage,
        loadingNextPage,
        searchQuery,
      ];

  @override
  bool get stringify => true;
}

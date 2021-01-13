import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../ui/reusable/list_items/list_item.dart';

class RecipesState extends Equatable {
  final List<ListItem> _listItems;
  final List<int> _bookmarkedRecipesIds;
  final bool loadingFirstPage;
  final bool loadingNextPage;

  List<ListItem> get listItems => _listItems;
  List<int> get bookmarkedRecipesIds => _bookmarkedRecipesIds;

  RecipesState(
      {@required List<ListItem> listItems,
      List<int> bookmarkedRecipesIds,
      this.loadingFirstPage = false,
      this.loadingNextPage = false})
      : _listItems = listItems,
        _bookmarkedRecipesIds = bookmarkedRecipesIds;

  factory RecipesState.initial() => RecipesState(listItems: []);

  RecipesState copy(
          {List<ListItem> listItems,
          List<int> bookmarkedRecipesIds,
          bool loadingFirstPage,
          bool loadingNextPage}) =>
      RecipesState(
          listItems: listItems ?? _listItems,
          bookmarkedRecipesIds: bookmarkedRecipesIds ?? _bookmarkedRecipesIds,
          loadingFirstPage: loadingFirstPage ?? this.loadingFirstPage,
          loadingNextPage: loadingNextPage ?? this.loadingNextPage);

  @override
  List<Object> get props => [
        _listItems,
        _bookmarkedRecipesIds,
        loadingFirstPage,
        loadingNextPage,
      ];

  @override
  bool get stringify => true;
}

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../ui/reusable/list_items/list_item.dart';


class RecipesState extends Equatable {
  final List<ListItem> _listItems;
  final bool loadingFirstPage;
  final bool loadingNextPage;

  List<ListItem> get listItems => _listItems;

  RecipesState(
      {@required List<ListItem> feedItems,
      this.loadingFirstPage = false,
      this.loadingNextPage = false})
      : _listItems = feedItems;

  factory RecipesState.initial() => RecipesState(feedItems: []);

  RecipesState copy(
          {List<ListItem> listItems,
          bool loadingFirstPage,
          bool loadingNextPage}) =>
      RecipesState(
          feedItems: listItems ?? _listItems,
          loadingFirstPage: loadingFirstPage ?? this.loadingFirstPage,
          loadingNextPage: loadingNextPage ?? this.loadingNextPage);

  @override
  List<Object> get props => [_listItems, loadingFirstPage, loadingNextPage];

  @override
  bool get stringify => true;
}

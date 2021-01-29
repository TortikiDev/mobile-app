import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../ui/reusable/list_items/list_item.dart';


class FeedState extends Equatable {
  final List<ListItem> _feedItems;
  final bool loadingFirstPage;
  final bool loadingNextPage;

  List<ListItem> get feedItems => _feedItems;

  FeedState(
      {@required List<ListItem> feedItems,
      this.loadingFirstPage = false,
      this.loadingNextPage = false})
      : _feedItems = feedItems;

  factory FeedState.initial() => FeedState(feedItems: []);

  FeedState copy(
          {List<ListItem> feedItems,
          bool loadingFirstPage,
          bool loadingNextPage}) =>
      FeedState(
          feedItems: feedItems ?? _feedItems,
          loadingFirstPage: loadingFirstPage ?? this.loadingFirstPage,
          loadingNextPage: loadingNextPage ?? this.loadingNextPage);

  @override
  List<Object> get props => [_feedItems, loadingFirstPage, loadingNextPage];

  @override
  bool get stringify => true;
}

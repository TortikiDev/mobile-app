import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../ui/screens/main/feed/list_items/feed_list_item.dart';

class FeedState extends Equatable {
  final List<FeedListItem> _feedItems;
  final bool loadingFirstPage;
  final bool loadingNextPage;

  List<FeedListItem> get feedItems => _feedItems;

  FeedState(
      {@required List<FeedListItem> feedItems,
      this.loadingFirstPage = false,
      this.loadingNextPage = false})
      : _feedItems = feedItems;

  factory FeedState.initial() => FeedState(feedItems: []);

  FeedState copy(
          {List<FeedListItem> feedItems,
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

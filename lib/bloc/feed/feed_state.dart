import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../ui/screens/main/feed/list_items/feed_list_item.dart';

class FeedState extends Equatable {
  final List<FeedListItem> _feedItems;
  final bool showCreatePostButton;
  final bool loadingFirstPage;
  final bool loadingNextPage;

  List<FeedListItem> get feedItems => _feedItems;

  FeedState(
      {@required List<FeedListItem> feedItems,
      this.showCreatePostButton = false,
      this.loadingFirstPage = false,
      this.loadingNextPage = false})
      : _feedItems = feedItems;

  factory FeedState.initial() => FeedState(feedItems: []);

  FeedState copy(
          {List<FeedListItem> feedItems,
          bool showCreatePostButton,
          bool loadingFirstPage,
          bool loadingNextPage}) =>
      FeedState(
          feedItems: feedItems ?? _feedItems,
          showCreatePostButton:
              showCreatePostButton ?? this.showCreatePostButton,
          loadingFirstPage: loadingFirstPage ?? this.loadingFirstPage,
          loadingNextPage: loadingNextPage ?? this.loadingNextPage);

  @override
  List<Object> get props =>
      [_feedItems, showCreatePostButton, loadingFirstPage, loadingNextPage];

  @override
  bool get stringify => true;
}

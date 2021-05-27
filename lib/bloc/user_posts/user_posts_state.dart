import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../ui/reusable/list_items/list_item.dart';

class UserPostsState extends Equatable {
  final bool isMyPosts;
  final int userId;
  final List<ListItem> _feedItems;
  final bool loadingFirstPage;
  final bool loadingNextPage;

  List<ListItem> get feedItems => List.of(_feedItems);

  UserPostsState({
    this.isMyPosts = false,
    @required this.userId,
    @required List<ListItem> feedItems,
    this.loadingFirstPage = false,
    this.loadingNextPage = false,
  }) : _feedItems = feedItems;

  factory UserPostsState.initial({
    bool isMyPosts = false,
    @required int userId,
  }) =>
      UserPostsState(isMyPosts: isMyPosts, userId: userId, feedItems: []);

  UserPostsState copy({
    bool isMyPosts,
    int userId,
    List<ListItem> feedItems,
    bool loadingFirstPage,
    bool loadingNextPage,
  }) =>
      UserPostsState(
          isMyPosts: isMyPosts ?? this.isMyPosts,
          userId: userId ?? this.userId,
          feedItems: feedItems ?? _feedItems,
          loadingFirstPage: loadingFirstPage ?? this.loadingFirstPage,
          loadingNextPage: loadingNextPage ?? this.loadingNextPage);

  @override
  List<Object> get props => [
        isMyPosts,
        userId,
        _feedItems,
        loadingFirstPage,
        loadingNextPage,
      ];

  @override
  bool get stringify => true;
}

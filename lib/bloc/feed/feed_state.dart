import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../ui/screens/main/feed/post/post_view_model.dart';

class FeedState extends Equatable {
  final List<PostViewModel> _postsViewModels;
  final bool loadingFirstPage;

  List<PostViewModel> get postsViewModels => _postsViewModels;

  FeedState(
      {@required List<PostViewModel> postsViewModels,
      this.loadingFirstPage = false})
      : _postsViewModels = postsViewModels;

  factory FeedState.initial() => FeedState(postsViewModels: []);

  FeedState copy(
          {List<PostViewModel> postsViewModels, bool loadingFirstPage}) =>
      FeedState(
          postsViewModels: postsViewModels ?? _postsViewModels,
          loadingFirstPage: loadingFirstPage ?? this.loadingFirstPage);

  @override
  List<Object> get props => [_postsViewModels, loadingFirstPage];
}

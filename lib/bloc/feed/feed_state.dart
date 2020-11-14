import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../ui/screens/main/feed/post/post_view_model.dart';

class FeedState extends Equatable {
  final List<PostViewModel> _postsViewModels;

  List<PostViewModel> get postsViewModels => _postsViewModels;

  FeedState({@required List<PostViewModel> postsViewModels})
      : _postsViewModels = postsViewModels;

  factory FeedState.initial() => FeedState(postsViewModels: []);

  FeedState copy({List<PostViewModel> postsViewModels}) =>
      FeedState(postsViewModels: postsViewModels ?? _postsViewModels);

  @override
  List<Object> get props => [_postsViewModels];
}

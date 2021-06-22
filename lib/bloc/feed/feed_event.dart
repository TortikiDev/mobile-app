import 'package:equatable/equatable.dart';

abstract class FeedEvent extends Equatable {}

abstract class PostEvent extends FeedEvent {
  final int postId;

  PostEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}

class BlocInit extends FeedEvent {
  @override
  List<Object?> get props => [];
}

class Like extends PostEvent {
  Like(int postId) : super(postId);
}

class Unlike extends PostEvent {
  Unlike(int postId) : super(postId);
}

class ExpandDescription extends PostEvent {
  ExpandDescription(int postId) : super(postId);
}

class CollapseDescription extends PostEvent {
  CollapseDescription(int postId) : super(postId);
}

class PullToRefresh extends FeedEvent {
  final Function onComplete;

  PullToRefresh(this.onComplete);

  @override
  List<Object?> get props => [];
}

class LoadNextPage extends FeedEvent {
  @override
  List<Object?> get props => [];
}

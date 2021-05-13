import 'package:equatable/equatable.dart';

abstract class UserPostsEvent extends Equatable {}

class BlocInit extends UserPostsEvent {
  @override
  List<Object> get props => [];
}

abstract class PostEvent extends UserPostsEvent {
  final int postId;

  PostEvent(this.postId);

  @override
  List<Object> get props => [postId];
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

class PullToRefresh extends UserPostsEvent {
  final Function onComplete;

  PullToRefresh(this.onComplete);

  @override
  List<Object> get props => [];
}

class LoadNextPage extends UserPostsEvent {
  @override
  List<Object> get props => [];
}

import 'package:equatable/equatable.dart';

abstract class FeedEvent extends Equatable {}

abstract class PostEvent extends FeedEvent {
  final String postId;

  PostEvent(this.postId);

  @override
  List<Object> get props => [postId];
}

class BlocInit extends FeedEvent {
  @override
  List<Object> get props => [];
}

class Like extends PostEvent {
  Like(String postId) : super(postId);
}

class Unlike extends PostEvent {
  Unlike(String postId) : super(postId);
}

class ExpandDescription extends PostEvent {
  ExpandDescription(String postId) : super(postId);
}

class CollapseDescription extends PostEvent {
  CollapseDescription(String postId) : super(postId);
}

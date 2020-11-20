import 'package:equatable/equatable.dart';

abstract class FeedEvent extends Equatable {}

class BlocInit extends FeedEvent {
  @override
  List<Object> get props => [];
}

class Like extends FeedEvent {
  final String postId;

  Like(this.postId);

  @override
  List<Object> get props => [postId];
}

class ExpandDescription extends FeedEvent {
  final String postId;

  ExpandDescription(this.postId);

  @override
  List<Object> get props => [postId];
}

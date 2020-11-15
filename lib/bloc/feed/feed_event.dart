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

class ExpandDesccription extends FeedEvent {
  final String postId;

  ExpandDesccription(this.postId);

  @override
  List<Object> get props => [postId];
}

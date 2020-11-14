import 'package:equatable/equatable.dart';

abstract class FeedEvent extends Equatable {}

class BlocInit extends FeedEvent {
  @override
  List<Object> get props => [];
}

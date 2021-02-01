import 'package:equatable/equatable.dart';

abstract class BookmarksEvent extends Equatable {}

class BlocInit extends BookmarksEvent {
  @override
  List<Object> get props => [];
}

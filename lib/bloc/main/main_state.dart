import 'package:equatable/equatable.dart';

class MainState extends Equatable {
  final bool showCreatePostButton;

  MainState({this.showCreatePostButton = false});

  factory MainState.initial() => MainState();

  MainState copy({bool? showCreatePostButton}) => MainState(
        showCreatePostButton: showCreatePostButton ?? this.showCreatePostButton,
      );

  @override
  List<Object?> get props => [showCreatePostButton];

  @override
  bool get stringify => true;
}

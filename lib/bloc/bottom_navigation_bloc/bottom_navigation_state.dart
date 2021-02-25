import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class BottomNavigationState extends Equatable {
  final bool isHidden;
  const BottomNavigationState({@required this.isHidden});

  factory BottomNavigationState.initial() =>
      BottomNavigationState(isHidden: false);

  BottomNavigationState copy({bool isHidden}) =>
      BottomNavigationState(isHidden: isHidden ?? this.isHidden);

  @override
  List<Object> get props => [isHidden];
}

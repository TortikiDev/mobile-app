import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'index.dart';

class BottomNavigationBloc
    extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  // region Properties

  // endregion

  // region Lifecycle

  BottomNavigationBloc() : super(BottomNavigationState.initial());

  @override
  Stream<BottomNavigationState> mapEventToState(
      BottomNavigationEvent event) async* {
    if (event is HideNavigationBar) {
      yield state.copy(isHidden: true);
    } else if (event is ShowNavigationBar) {
      yield state.copy(isHidden: false);
    }
  }

  // endregion
}

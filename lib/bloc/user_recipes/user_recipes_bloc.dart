import 'dart:async';

import 'package:flutter/foundation.dart';

import '../base_bloc.dart';
import '../error_handling/index.dart';
import 'index.dart';

class UserRecipesBloc extends BaseBloc<UserRecipesEvent, UserRecipesState> {
  // region Properties

  // endregion

  // region Lifecycle

  UserRecipesBloc({@required ErrorHandlingBloc errorHandlingBloc})
      : super(
            initialState: UserRecipesState.initial(), 
            errorHandlingBloc: errorHandlingBloc);

  @override
  Stream<UserRecipesState> mapEventToState(UserRecipesEvent event) async* {
    // TODO: implement event to state mapping
  }

  // endregion
}

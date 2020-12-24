import 'dart:async';

import 'package:flutter/foundation.dart';

import '../base_bloc.dart';
import '../error_handling/index.dart';
import 'index.dart';

class RecipesBloc extends BaseBloc<RecipesEvent, RecipesState> {
  // region Properties

  // endregion

  // region Lifecycle

  RecipesBloc({@required ErrorHandlingBloc errorHandlingBloc})
      : super(
            initialState: RecipesState.initial(), 
            errorHandlingBloc: errorHandlingBloc);

  @override
  Stream<RecipesState> mapEventToState(RecipesEvent event) async* {
    // TODO: implement event to state mapping
    throw UnimplementedError();
  }

  // endregion
}

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../base_bloc.dart';
import '../error_handling/index.dart';
import 'index.dart';

class RecipeDetailsBloc
    extends BaseBloc<RecipeDetailsEvent, RecipeDetailsState> {
  // region Properties

  // endregion

  // region Lifecycle

  RecipeDetailsBloc({@required ErrorHandlingBloc errorHandlingBloc})
      : super(
            initialState: RecipeDetailsState.initial(),
            errorHandlingBloc: errorHandlingBloc);

  @override
  Stream<RecipeDetailsState> mapEventToState(RecipeDetailsEvent event) async* {
    // TODO: implement event to state mapping
  }

  // endregion
}

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../base_bloc.dart';
import '../error_handling/index.dart';
import 'index.dart';

class CreatePostBloc extends BaseBloc<CreatePostEvent, CreatePostState> {
  // region Properties

  // endregion

  // region Lifecycle

  CreatePostBloc({@required ErrorHandlingBloc errorHandlingBloc})
      : super(
            initialState: CreatePostState.initial(),
            errorHandlingBloc: errorHandlingBloc);

  @override
  Stream<CreatePostState> mapEventToState(CreatePostEvent event) async* {
    if (event is BlocInit) {}
  }

  // endregion
}

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../base_bloc.dart';
import '../error_handling/index.dart';
import 'index.dart';

class FeedBloc extends BaseBloc<FeedEvent, FeedState> {
  // region Properties

  // endregion

  // region Lifecycle

  FeedBloc({@required ErrorHandlingBloc errorHandlingBloc})
      : super(
            initialState: FeedState(), errorHandlingBloc: errorHandlingBloc);

  @override
  Stream<FeedState> mapEventToState(FeedEvent event) async* {
    // TODO: implement event to state mapping
    throw UnimplementedError();
  }

  // endregion
}

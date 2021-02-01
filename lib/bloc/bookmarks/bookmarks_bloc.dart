import 'dart:async';

import 'package:flutter/foundation.dart';

import '../base_bloc.dart';
import '../error_handling/index.dart';
import 'index.dart';

class BookmarksBloc extends BaseBloc<BookmarksEvent, BookmarksState> {
  // region Properties

  // endregion

  // region Lifecycle

  BookmarksBloc({@required ErrorHandlingBloc errorHandlingBloc})
      : super(
            initialState: BookmarksState.initial(), 
            errorHandlingBloc: errorHandlingBloc);

  @override
  Stream<BookmarksState> mapEventToState(BookmarksEvent event) async* {
    // TODO: implement event to state mapping
    throw UnimplementedError();
  }

  // endregion
}

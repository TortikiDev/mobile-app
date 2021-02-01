import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/repositories/repositories.dart';
import '../base_bloc.dart';
import '../error_handling/index.dart';
import 'index.dart';

class BookmarksBloc extends BaseBloc<BookmarksEvent, BookmarksState> {
  // region Properties

  final BookmarkedRecipesRepository bookmarksRepository;

  // endregion

  // region Lifecycle

  BookmarksBloc(
      {@required this.bookmarksRepository,
      @required ErrorHandlingBloc errorHandlingBloc})
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

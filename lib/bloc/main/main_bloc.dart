import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/preferences/account.dart';
import '../../data/repositories/repositories.dart';
import '../base_bloc.dart';
import '../error_handling/index.dart';
import 'index.dart';

class MainBloc extends BaseBloc<MainEvent, MainState> {
  // region Properties

  final JwtRepository jwtRepository;
  final AccountRepository accountRepository;

  // endregion

  // region Lifecycle

  MainBloc(
      {@required this.jwtRepository,
      @required this.accountRepository,
      @required ErrorHandlingBloc errorHandlingBloc})
      : super(
            initialState: MainState.initial(),
            errorHandlingBloc: errorHandlingBloc);

  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    if (event is BlocInit) {
      final showCreatePostButton = await _needToShowCreatePostButton();
      yield state.copy(showCreatePostButton: showCreatePostButton);
    }
  }

  // endregion

  // Private methods

  Future<bool> _needToShowCreatePostButton() async {
    final isAuthenticated = (await jwtRepository.getJwt()) != null;
    var isConfectioner = false;
    if (isAuthenticated) {
      try {
        final myAccount = await accountRepository.getMyAccount();
        isConfectioner = myAccount.type == AccountType.confectioner;
      } on Exception catch (e) {
        errorHandlingBloc.add(ExceptionRaised(e));
      }
    }
    return isAuthenticated && isConfectioner;
  }

  // endregion
}

import 'dart:async';

import '../../data/repositories/repositories.dart';
import '../base_bloc.dart';
import '../error_handling/index.dart';
import 'index.dart';

class ClientProfileBloc
    extends BaseBloc<ClientProfileEvent, ClientProfileState> {
  // region Properties

  final AccountRepository accountRepository;

  // endregion

  // region Lifecycle

  ClientProfileBloc({
    required this.accountRepository,
    required ErrorHandlingBloc errorHandlingBloc,
  }) : super(
          initialState: ClientProfileState.initial(),
          errorHandlingBloc: errorHandlingBloc,
        );

  @override
  Stream<ClientProfileState> mapEventToState(ClientProfileEvent event) async* {
    if (event is BlocInit) {
      final account = await accountRepository.getMyAccount();
      yield state.copy(phone: account.phone, city: account.city);
    } else if (event is PickCity) {
      accountRepository.setCity(event.city);
      yield state.copy(city: event.city);
    } else if (event is Logout) {
      accountRepository.deleteAccount();
      // TODO: handle logout
    }
  }

  // endregion
}

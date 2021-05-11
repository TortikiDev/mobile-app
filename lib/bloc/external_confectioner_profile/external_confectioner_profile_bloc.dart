import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/http_client/responses/responses.dart';
import '../../data/repositories/repositories.dart';
import '../base_bloc.dart';
import '../error_handling/index.dart';
import 'index.dart';

class ExternalConfectionerProfileBloc extends BaseBloc<
    ExternalConfectionerProfileEvent, ExternalConfectionerProfileState> {
  // region Properties

  final ConfectionersRepository confectionersRepository;

  // endregion

  // region Lifecycle

  ExternalConfectionerProfileBloc({
    @required int confectionerId,
    @required String confectionerName,
    @required this.confectionersRepository,
    @required ErrorHandlingBloc errorHandlingBloc,
  }) : super(
            initialState: ExternalConfectionerProfileState.initial(
              confectionerId: confectionerId,
              confectionerName: confectionerName,
            ),
            errorHandlingBloc: errorHandlingBloc);

  @override
  Stream<ExternalConfectionerProfileState> mapEventToState(
      ExternalConfectionerProfileEvent event) async* {
    if (event is BlocInit) {
      yield state.copy(loading: true);
      ConfectionerResponse confectionerResponse;
      try {
        confectionerResponse = await confectionersRepository
            .getConfectionerDetails(id: state.confectionerId);
      } on Exception catch (error) {
        errorHandlingBloc.add(ExceptionRaised(error));
      }
      yield state.copy(confectioner: confectionerResponse, loading: false);
    }
  }

  // endregion

  // region Private methods

  // endregion
}

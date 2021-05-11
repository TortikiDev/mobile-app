import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../data/http_client/responses/responses.dart';

class ExternalConfectionerProfileState extends Equatable {
  final int confectionerId;
  final String confectionerName;
  final ConfectionerResponse confectioner;
  final bool loading;

  const ExternalConfectionerProfileState({
    @required this.confectionerId,
    @required this.confectionerName,
    this.confectioner,
    this.loading = false,
  });

  factory ExternalConfectionerProfileState.initial({
    @required int confectionerId,
    @required String confectionerName,
  }) =>
      ExternalConfectionerProfileState(
        confectionerId: confectionerId,
        confectionerName: confectionerName,
      );

  ExternalConfectionerProfileState copy({
    int confectionerId,
    String confectionerName,
    ConfectionerResponse confectioner,
    bool loading,
  }) =>
      ExternalConfectionerProfileState(
        confectionerId: confectionerId ?? this.confectionerId,
        confectionerName: confectionerName ?? this.confectionerName,
        confectioner: confectioner ?? this.confectioner,
        loading: loading ?? this.loading,
      );

  @override
  List<Object> get props => [
        confectionerId,
        confectionerName,
        confectioner,
        loading,
      ];
}

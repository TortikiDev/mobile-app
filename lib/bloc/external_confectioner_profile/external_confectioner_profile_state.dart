import 'package:equatable/equatable.dart';

import '../../data/http_client/responses/responses.dart';

class ExternalConfectionerProfileState extends Equatable {
  final int confectionerId;
  final String confectionerName;
  final int confectionerGender;
  final ConfectionerResponse? confectioner;
  final bool loading;

  const ExternalConfectionerProfileState({
    required this.confectionerId,
    required this.confectionerName,
    required this.confectionerGender,
    this.confectioner,
    this.loading = false,
  });

  factory ExternalConfectionerProfileState.initial({
    required int confectionerId,
    required String confectionerName,
    required int confectionerGender,
  }) =>
      ExternalConfectionerProfileState(
        confectionerId: confectionerId,
        confectionerName: confectionerName,
        confectionerGender: confectionerGender,
      );

  ExternalConfectionerProfileState copy({
    int? confectionerId,
    String? confectionerName,
    int? confectionerGender,
    ConfectionerResponse? confectioner,
    bool? loading,
  }) =>
      ExternalConfectionerProfileState(
        confectionerId: confectionerId ?? this.confectionerId,
        confectionerName: confectionerName ?? this.confectionerName,
        confectionerGender: confectionerGender ?? this.confectionerGender,
        confectioner: confectioner ?? this.confectioner,
        loading: loading ?? this.loading,
      );

  @override
  List<Object?> get props => [
        confectionerId,
        confectionerName,
        confectionerGender,
        confectioner,
        loading,
      ];
}

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

enum AuthParts { nonAuth, errorAuth, successAuth }

class AuthState extends Equatable {
  final AuthParts _authParts;

  AuthParts get authParts => _authParts;

  AuthState(AuthParts authParts) : _authParts = authParts;

  factory AuthState.initial() => AuthState(AuthParts.nonAuth);

  AuthState copy({AuthParts authParts}) => AuthState(authParts ?? _authParts);

  @override
  List<Object> get props => [_authParts];
}

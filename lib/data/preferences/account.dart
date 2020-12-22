import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Account extends Equatable {
  final int type;

  Account({@required this.type});

  @override
  List<Object> get props => [type];
}

class AccountType {
  static const client = 0;
  static const confectioner = 1;
}

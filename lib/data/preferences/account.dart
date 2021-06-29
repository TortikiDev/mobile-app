import 'package:equatable/equatable.dart';

class Account extends Equatable {
  final String phone;
  final String city;
  final int type;

  Account({
    required this.phone,
    required this.city,
    required this.type,
  });

  @override
  List<Object?> get props => [phone, city, type];
}

class AccountType {
  static const client = 0;
  static const confectioner = 1;
}

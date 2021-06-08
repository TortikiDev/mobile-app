import 'package:equatable/equatable.dart';

class ClientProfileState extends Equatable {
  final String phone;
  final String city;

  const ClientProfileState({
    this.phone = '',
    this.city = '',
  });

  factory ClientProfileState.initial() => ClientProfileState();

  ClientProfileState copy({
    String phone,
    String city,
  }) =>
      ClientProfileState(
        phone: phone ?? this.phone,
        city: city ?? this.city,
      );

  @override
  List<Object> get props => [phone, city];
}

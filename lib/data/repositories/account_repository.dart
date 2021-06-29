import '../preferences/account.dart';

// TODO: inject secret local storage client and make real data requests
class AccountRepository {
  Future<Account> getMyAccount() async => Account(
        phone: '+7 (987) 654 32 11',
        city: 'Рязань',
        type: AccountType.confectioner,
      );

  Future<void> setCity(String city) async =>
      Future.delayed(Duration(seconds: 1));

  Future<void> deleteAccount() async => Future.delayed(Duration(seconds: 1));
}

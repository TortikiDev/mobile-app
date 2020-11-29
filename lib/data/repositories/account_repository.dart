import '../preferences/account.dart';

// TODO: inject secret local storage client and make real data requests
class AccountRepository {
  Future<Account> getMyAccount() async =>
      Account(type: AccountType.confectioner);
}

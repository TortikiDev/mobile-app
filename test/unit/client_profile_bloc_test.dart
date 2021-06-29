@Timeout(Duration(seconds: 10))
import 'package:flutter_test/flutter_test.dart';
import 'package:tortiki/bloc/client_profile/index.dart';
import 'package:tortiki/bloc/error_handling/index.dart';
import 'package:tortiki/data/preferences/account.dart';
import 'package:tortiki/data/repositories/repositories.dart';
import 'package:mocktail/mocktail.dart';

class _MockErrorHandlingBloc extends Mock implements ErrorHandlingBloc {}

class _MockAccountRepository extends Mock implements AccountRepository {}

void main() {
  late ClientProfileBloc sut;
  late _MockErrorHandlingBloc errorHandlingBloc;
  late _MockAccountRepository accountRepository;

  final initialState = ClientProfileState.initial();

  setUp(() {
    accountRepository = _MockAccountRepository();
    errorHandlingBloc = _MockErrorHandlingBloc();

    sut = ClientProfileBloc(
      accountRepository: accountRepository,
      errorHandlingBloc: errorHandlingBloc,
    );
  });

  tearDown(() {
    sut.close();
  });

  test('initial state is correct', () {
    expect(sut.state, initialState);
  });

  test('close does not emit new states', () {
    sut.close();
    expectLater(
      sut.stream,
      emitsDone,
    );
  });

  test('BlocInit emits account data', () {
    // given
    final phone = '12345';
    final city = 'NY';
    final excpectedState = initialState.copy(phone: phone, city: city);
    // when
    when(() => accountRepository.getMyAccount()).thenAnswer(
      (invocation) => Future.value(Account(
        phone: phone,
        city: city,
        type: AccountType.client,
      )),
    );
    sut.add(BlocInit());
    // then
    expect(
      sut.stream,
      emits(excpectedState),
    );
  });

  test('PickCity emits state with picked city', () {
    // given
    final city = 'LA';
    final excpectedState = initialState.copy(city: city);
    // when
    when(() => accountRepository.setCity(city))
        .thenAnswer((invocation) => Future.value());
    sut.add(PickCity(city));
    // then
    expect(
      sut.stream,
      emits(excpectedState),
    );
  });

  test('Logout deletes user account from repository', () async {
    // given
    // when
    when(() => accountRepository.deleteAccount())
        .thenAnswer((invocation) => Future.value());
    sut.add(Logout());
    // then
    await untilCalled(() => accountRepository.deleteAccount());
  });
}

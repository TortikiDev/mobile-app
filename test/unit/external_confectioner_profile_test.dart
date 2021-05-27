@Timeout(Duration(seconds: 10))
import 'package:flutter_test/flutter_test.dart';
import 'package:tortiki/bloc/error_handling/index.dart';
import 'package:mockito/mockito.dart';
import 'package:tortiki/bloc/external_confectioner_profile/index.dart';
import 'package:tortiki/data/http_client/responses/responses.dart';
import 'package:tortiki/data/repositories/repositories.dart';

class _MockErrorHandlingBloc extends Mock implements ErrorHandlingBloc {}

class _MockConfectionersRepository extends Mock
    implements ConfectionersRepository {}

void main() {
  ExternalConfectionerProfileBloc sut;
  _MockErrorHandlingBloc errorHandlingBloc;
  _MockConfectionersRepository confectionersRepository;

  final nameStub = 'John';
  final idStub = 123;
  final genderStub = Gender.male;

  final initialState = ExternalConfectionerProfileState.initial(
    confectionerId: idStub,
    confectionerName: nameStub,
    confectionerGender: genderStub,
  );

  setUp(() {
    errorHandlingBloc = _MockErrorHandlingBloc();
    confectionersRepository = _MockConfectionersRepository();

    sut = ExternalConfectionerProfileBloc(
      confectionerId: idStub,
      confectionerName: nameStub,
      confectionerGender: genderStub,
      confectionersRepository: confectionersRepository,
      errorHandlingBloc: errorHandlingBloc,
    );
  });

  tearDown(() {
    sut?.close();
  });

  test('initial state is correct', () {
    expect(sut.state, initialState);
  });

  test('close does not emit new states', () {
    sut?.close();
    expectLater(
      sut,
      emitsDone,
    );
  });

  test(
      'BlocInit loads confectionner details and emits them on response success',
      () {
    // given
    final responseStub = ConfectionerResponse(
      id: idStub,
      name: nameStub,
      address: 'address',
      about: 'about',
      gender: genderStub,
      avatarUrl: 'avatarUrl',
      starType: ConfectionerRatingStarType.silver,
      rating: 345,
      coordinate: null,
    );
    final expectedState1 = initialState.copy(loading: true);
    final expectedState2 =
        expectedState1.copy(confectioner: responseStub, loading: false);
    // when
    when(confectionersRepository.getConfectionerDetails(id: idStub))
        .thenAnswer((realInvocation) => Future.value(responseStub));
    sut.add(BlocInit());
    // then
    expectLater(
      sut,
      emitsInOrder([
        expectedState1,
        expectedState2,
      ]),
    );
  });

  test(
      'BlocInit loads confectionner details and emits them on response success',
      () {
    // given
    final expectedState1 = initialState.copy(loading: true);
    final expectedState2 = expectedState1.copy(loading: false);
    // when
    when(confectionersRepository.getConfectionerDetails(id: idStub))
        .thenAnswer((realInvocation) => Future.error(Exception()));
    sut.add(BlocInit());
    // then
    expectLater(
      sut,
      emitsInOrder([
        expectedState1,
        expectedState2,
      ]),
    );
  });
}

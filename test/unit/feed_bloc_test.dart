@Timeout(Duration(seconds: 10))
import 'package:flutter_test/flutter_test.dart';
import 'package:tortiki/bloc/error_handling/index.dart';
import 'package:mockito/mockito.dart';
import 'package:tortiki/bloc/feed/index.dart';

class _MockErrorHandlingBloc extends Mock implements ErrorHandlingBloc {}

void main() {
  FeedBloc sut;
  _MockErrorHandlingBloc errorHandlingBloc;
  final initialState = FeedState.initial();

  setUp(() {
    errorHandlingBloc = _MockErrorHandlingBloc();
    sut = FeedBloc(errorHandlingBloc: errorHandlingBloc);
  });

  tearDown(() {
    sut?.close();
  });

  test('initial state is correct', () {
    expect(sut.state, initialState);
  });

  test('close does not emit new states', () {
    sut.close();
    expectLater(
      sut,
      emitsDone,
    );
  });
}

@Timeout(Duration(seconds: 10))
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:tortiki/bloc/error_handling/index.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tortiki/bloc/create_post/index.dart';
import 'package:tortiki/data/repositories/repositories.dart';

class _MockErrorHandlingBloc extends Mock implements ErrorHandlingBloc {}

class _MockPostsRepository extends Mock implements PostsRepository {}

void main() {
  late CreatePostBloc sut;
  late _MockErrorHandlingBloc errorHandlingBloc;
  late _MockPostsRepository postsRepository;

  final initialState = CreatePostState.initial();

  setUp(() {
    errorHandlingBloc = _MockErrorHandlingBloc();
    postsRepository = _MockPostsRepository();

    sut = CreatePostBloc(
        postsRepository: postsRepository, errorHandlingBloc: errorHandlingBloc);
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

  test('PhotoPicked emits state with photo and canCreatePost == true', () {
    // given
    final photo = File('');
    final expectedState1 = initialState.copy(photo: photo);
    final expectedState2 = expectedState1.copy(canCreatePost: true);
    // when
    sut.add(PhotoPicked(photo));
    // then
    expect(
      sut.stream,
      emitsInOrder([
        expectedState1,
        expectedState2,
      ]),
    );
  });

  test('DescriptionChanged emits state with changed desciption', () {
    // given
    final description = '123';
    // when
    sut.add(DescriptionChanged(description));
    // then
    expect(
      sut.stream,
      emits(initialState.copy(description: description)),
    );
  });

  test('CreatePost does not emit loading state when photo is null', () {
    // given
    // when
    sut.add(CreatePost());
    sut.close();
    // then
    expect(
      sut.stream,
      neverEmits(initialState.copy(creatingPost: true)),
    );
  });

  test(
      'CreatePost does not invoke repositories createPost '
      'method when photo is null', () {
    // given
    // when
    sut.add(CreatePost());
    sut.close();
    // then
    verifyNever(
        () => () => postsRepository.createPost(photo: any(named: 'photo')));
  });

  test('CreatePost flow test', () {
    // given
    final description = '123';
    final photo = File('');

    final expectedState0 = initialState.copy(description: description);
    final expectedState1 = expectedState0.copy(photo: photo);
    final expectedState2 = expectedState1.copy(canCreatePost: true);
    final expectedState3 = expectedState2.copy(creatingPost: true);
    final expectedState4 =
        expectedState3.copy(creatingPost: false, postSuccessfulyCreated: true);

    // when
    when(() =>
            postsRepository.createPost(photo: photo, description: description))
        .thenAnswer((realInvocation) => Future.value());
    sut.add(DescriptionChanged(description));
    sut.add(PhotoPicked(photo));
    sut.add(CreatePost());
    // then
    expect(
      sut.stream,
      emitsInOrder([
        expectedState0,
        expectedState1,
        expectedState2,
        expectedState3,
        expectedState4,
      ]),
    );
  });
}

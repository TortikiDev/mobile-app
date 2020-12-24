@Timeout(Duration(seconds: 10))
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tortiki/bloc/error_handling/index.dart';
import 'package:mockito/mockito.dart';
import 'package:tortiki/bloc/feed/index.dart';
import 'package:tortiki/data/repositories/repositories.dart';
import 'package:tortiki/data/http_client/responses/responses.dart';
import 'package:tortiki/ui/reusable/list_items/list_item.dart';
import 'package:tortiki/ui/reusable/list_items/progress_indicator_item.dart';
import 'package:tortiki/ui/screens/main/feed/post/post_view_model.dart';

class _MockErrorHandlingBloc extends Mock implements ErrorHandlingBloc {}

class _MockPostsRepository extends Mock implements PostsRepository {}

void main() {
  FeedBloc sut;
  _MockErrorHandlingBloc errorHandlingBloc;
  _MockPostsRepository postsRepository;

  final initialState = FeedState.initial();

  setUp(() {
    errorHandlingBloc = _MockErrorHandlingBloc();
    postsRepository = _MockPostsRepository();

    sut = FeedBloc(
        postsRepository: postsRepository,
        errorHandlingBloc: errorHandlingBloc);
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

  test('BlocInit event loads first posts page', () {
    // given
    final postsResponseStub = [
      PostResponse(
          id: 123,
          userAvaratUrl: 'https://images.unsplash.com/photo',
          userName: 'Granny',
          imageUrl: 'https://images.unsplash.com/photo',
          description:
              'В качестве рекламы моего рецепта могу сказать следующее.',
          likes: 0,
          liked: false),
      PostResponse(
          id: 124,
          userAvaratUrl: null,
          userName: 'DEady',
          imageUrl: 'https://images.unsplash.com/photo',
          description: 'Результат просто превосходный!',
          likes: 1250,
          liked: true)
    ];
    final feedItemsStub = [
      PostViewModel(
          id: 123,
          userAvaratUrl: 'https://images.unsplash.com/photo',
          userName: 'Granny',
          imageUrl: 'https://images.unsplash.com/photo',
          description:
              'В качестве рекламы моего рецепта могу сказать следующее.',
          likes: 0,
          liked: false),
      PostViewModel(
          id: 124,
          userAvaratUrl: null,
          userName: 'DEady',
          imageUrl: 'https://images.unsplash.com/photo',
          description: 'Результат просто превосходный!',
          likes: 1250,
          liked: true)
    ];
    final expectedState1 = initialState.copy(loadingFirstPage: true);
    final expectedState2 =
        initialState.copy(feedItems: feedItemsStub, loadingFirstPage: false);

    // when
    when(postsRepository.getPosts())
        .thenAnswer((realInvocation) => Future.value(postsResponseStub));
    sut.add(BlocInit());

    // then
    expectLater(
      sut,
      emitsInOrder([expectedState1, expectedState2]),
    );
  });

  test(
      'BlocInit event emits loading changes only'
      ' when getPosts() throws an error', () {
    // given
    final expectedState1 = initialState.copy(loadingFirstPage: true);
    final expectedState2 = initialState.copy(loadingFirstPage: false);

    // when
    when(postsRepository.getPosts()).thenThrow(DioError());
    sut.add(BlocInit());

    // then
    expectLater(
      sut,
      emitsInOrder([expectedState1, expectedState2]),
    );
  });

  test('PullToRefresh event loads first posts page', () {
    // given
    final postsResponseStub = [
      PostResponse(
          id: 123,
          userAvaratUrl: 'https://images.unsplash.com/photo',
          userName: 'Granny',
          imageUrl: 'https://images.unsplash.com/photo',
          description:
              'В качестве рекламы моего рецепта могу сказать следующее.',
          likes: 0,
          liked: false),
      PostResponse(
          id: 124,
          userAvaratUrl: null,
          userName: 'DEady',
          imageUrl: 'https://images.unsplash.com/photo',
          description: 'Результат просто превосходный!',
          likes: 1250,
          liked: true)
    ];
    final feedItemsStub = [
      PostViewModel(
          id: 123,
          userAvaratUrl: 'https://images.unsplash.com/photo',
          userName: 'Granny',
          imageUrl: 'https://images.unsplash.com/photo',
          description:
              'В качестве рекламы моего рецепта могу сказать следующее.',
          likes: 0,
          liked: false),
      PostViewModel(
          id: 124,
          userAvaratUrl: null,
          userName: 'DEady',
          imageUrl: 'https://images.unsplash.com/photo',
          description: 'Результат просто превосходный!',
          likes: 1250,
          liked: true)
    ];
    final expectedState = initialState.copy(feedItems: feedItemsStub);

    // when
    when(postsRepository.getPosts())
        .thenAnswer((realInvocation) => Future.value(postsResponseStub));
    sut.add(PullToRefresh(() {}));

    // then
    expectLater(
      sut,
      emitsInOrder([expectedState]),
    );
  });

  test(
      'PullToRefresh event emits nothing'
      ' when getPosts() throws an error', () {
    // given

    // when
    when(postsRepository.getPosts()).thenThrow(DioError());
    sut.add(BlocInit());

    // then
    expectLater(sut.state, initialState);
  });

  test('LoadNextPage event loads next posts page', () {
    // given
    final currentPosts = <ListItem>[
      PostViewModel(
          id: 100,
          userAvaratUrl: 'https://images.unsplash.com/photo',
          userName: 'Granny',
          imageUrl: 'https://images.unsplash.com/photo',
          description:
              'В качестве рекламы моего рецепта могу сказать следующее.',
          likes: 0,
          liked: false),
    ];
    final feedItemsOnLoadNextPage = currentPosts + [ProgressIndicatorItem()];
    final nextPageResponseStub = [
      PostResponse(
          id: 123,
          userAvaratUrl: 'https://images.unsplash.com/photo',
          userName: 'Granny',
          imageUrl: 'https://images.unsplash.com/photo',
          description:
              'В качестве рекламы моего рецепта могу сказать следующее.',
          likes: 0,
          liked: false),
      PostResponse(
          id: 124,
          userAvaratUrl: null,
          userName: 'DEady',
          imageUrl: 'https://images.unsplash.com/photo',
          description: 'Результат просто превосходный!',
          likes: 1250,
          liked: true)
    ];
    final feedItemsStub = currentPosts +
        [
          PostViewModel(
              id: 123,
              userAvaratUrl: 'https://images.unsplash.com/photo',
              userName: 'Granny',
              imageUrl: 'https://images.unsplash.com/photo',
              description:
                  'В качестве рекламы моего рецепта могу сказать следующее.',
              likes: 0,
              liked: false),
          PostViewModel(
              id: 124,
              userAvaratUrl: null,
              userName: 'DEady',
              imageUrl: 'https://images.unsplash.com/photo',
              description: 'Результат просто превосходный!',
              likes: 1250,
              liked: true)
        ];
    final currentState = initialState.copy(feedItems: currentPosts);
    final expectedState1 = currentState.copy(
        loadingNextPage: true, feedItems: feedItemsOnLoadNextPage);
    final expectedState2 =
        expectedState1.copy(loadingNextPage: false, feedItems: feedItemsStub);

    // when
    sut.emit(currentState);
    when(postsRepository.getPosts(lastId: 100))
        .thenAnswer((realInvocation) => Future.value(nextPageResponseStub));
    sut.add(LoadNextPage());

    // then
    expectLater(
      sut,
      emitsInOrder([expectedState1, expectedState2]),
    );
  });

  test('Like event emits state with liked post', () {
    // given
    final feedItemsStub = [
      PostViewModel(
          id: 123,
          userAvaratUrl: 'https://images.unsplash.com/photo',
          userName: 'Granny',
          imageUrl: 'https://images.unsplash.com/photo',
          description:
              'В качестве рекламы моего рецепта могу сказать следующее.',
          likes: 0,
          liked: false)
    ];
    final expectedFeedItemsStub = [
      PostViewModel(
          id: 123,
          userAvaratUrl: 'https://images.unsplash.com/photo',
          userName: 'Granny',
          imageUrl: 'https://images.unsplash.com/photo',
          description:
              'В качестве рекламы моего рецепта могу сказать следующее.',
          likes: 1,
          liked: true)
    ];

    final currentState = initialState.copy(feedItems: feedItemsStub);
    final expectedState = currentState.copy(feedItems: expectedFeedItemsStub);

    // when
    sut.emit(currentState);
    when(postsRepository.likePost(postId: 123))
        .thenAnswer((realInvocation) => Future.value());
    sut.add(Like(123));

    // then
    expectLater(sut, emits(expectedState));
  });

  test('Like event invokes likePost() repository method', () async {
// given
    final feedItemsStub = [
      PostViewModel(
          id: 123,
          userAvaratUrl: 'https://images.unsplash.com/photo',
          userName: 'Granny',
          imageUrl: 'https://images.unsplash.com/photo',
          description:
              'В качестве рекламы моего рецепта могу сказать следующее.',
          likes: 0,
          liked: false)
    ];

    final currentState = initialState.copy(feedItems: feedItemsStub);

    // when
    sut.emit(currentState);
    sut.add(Like(123));

    // then
    await untilCalled(postsRepository.likePost(postId: 123));
    verify(postsRepository.likePost(postId: 123)).called(1);
  });

  test('Unike event emits state with unliked post', () {
    // given
    final feedItemsStub = [
      PostViewModel(
          id: 123,
          userAvaratUrl: 'https://images.unsplash.com/photo',
          userName: 'Granny',
          imageUrl: 'https://images.unsplash.com/photo',
          description:
              'В качестве рекламы моего рецепта могу сказать следующее.',
          likes: 5,
          liked: true)
    ];
    final expectedFeedItemsStub = [
      PostViewModel(
          id: 123,
          userAvaratUrl: 'https://images.unsplash.com/photo',
          userName: 'Granny',
          imageUrl: 'https://images.unsplash.com/photo',
          description:
              'В качестве рекламы моего рецепта могу сказать следующее.',
          likes: 4,
          liked: false)
    ];

    final currentState = initialState.copy(feedItems: feedItemsStub);
    final expectedState = currentState.copy(feedItems: expectedFeedItemsStub);

    // when
    sut.emit(currentState);
    when(postsRepository.unlikePost(postId: 123))
        .thenAnswer((realInvocation) => Future.value());
    sut.add(Unlike(123));

    // then
    expectLater(sut, emits(expectedState));
  });

  test('Unike event invokes likePost() repository method', () async {
// given
    final feedItemsStub = [
      PostViewModel(
          id: 123,
          userAvaratUrl: 'https://images.unsplash.com/photo',
          userName: 'Granny',
          imageUrl: 'https://images.unsplash.com/photo',
          description:
              'В качестве рекламы моего рецепта могу сказать следующее.',
          likes: 5,
          liked: true)
    ];

    final currentState = initialState.copy(feedItems: feedItemsStub);

    // when
    sut.emit(currentState);
    sut.add(Unlike(123));

    // then
    await untilCalled(postsRepository.unlikePost(postId: 123));
    verify(postsRepository.unlikePost(postId: 123)).called(1);
  });
}

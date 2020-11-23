import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../ui/screens/main/feed/list_items/post/post_view_model.dart';
import '../../ui/screens/main/feed/list_items/progress_indicator_item.dart';
import '../base_bloc.dart';
import '../error_handling/index.dart';
import 'index.dart';

class FeedBloc extends BaseBloc<FeedEvent, FeedState> {
  // region Properties

  // endregion

  // region Lifecycle

  FeedBloc({@required ErrorHandlingBloc errorHandlingBloc})
      : super(
            initialState: FeedState.initial(),
            errorHandlingBloc: errorHandlingBloc);

  @override
  Stream<FeedState> mapEventToState(FeedEvent event) async* {
    if (event is BlocInit) {
      yield state.copy(loadingFirstPage: true);
      try {
        final posts = await _getPostsFirstPage();
        yield state.copy(feedItems: posts, loadingFirstPage: false);
      } on Exception catch (e) {
        errorHandlingBloc.add(ExceptionRaised(e));
        yield state.copy(loadingFirstPage: false);
      }
    } else if (event is PostEvent) {
      yield _mapPostEventToState(event);
    } else if (event is PullToRefresh) {
      try {
        final posts = await _getPostsFirstPage();
        yield state.copy(feedItems: posts);
      } on Exception catch (e) {
        errorHandlingBloc.add(ExceptionRaised(e));
      }
      event.onComplete();
    } else if (event is LoadNextPage) {
      final updatedFeedItems = List.of(state.feedItems);
      updatedFeedItems.add(ProgressIndicatorItem());
      yield state.copy(loadingNextPage: true, feedItems: updatedFeedItems);

      final postNextPage = <PostViewModel>[];
      try {
        final nextPage = await _getPostsNextPage();
        postNextPage.addAll(nextPage);
      } on Exception catch (e) {
        errorHandlingBloc.add(ExceptionRaised(e));
      }
      updatedFeedItems.removeLast();
      updatedFeedItems.addAll(postNextPage);
      yield state.copy(loadingNextPage: false, feedItems: updatedFeedItems);
    }
  }

  // endregion

  // Private methods

  Future<List<PostViewModel>> _getPostsFirstPage() {
    // TODO: Load posts from server
    final firstPage = _generatePostsPage();
    final result = firstPage
        .asMap()
        .map((key, value) => MapEntry(key, value.copy(id: key)))
        .values
        .toList();
    return Future.delayed(Duration(seconds: 2))
        .then((_) => Future.value(result));
  }

  Future<List<PostViewModel>> _getPostsNextPage() {
    final lastItem =
        state.feedItems.lastWhere((e) => e is PostViewModel) as PostViewModel;
    final lastId = lastItem.id;
    final nextPage = _generatePostsPage();
    final result = nextPage
        .asMap()
        .map((key, value) => MapEntry(key, value.copy(id: key + lastId)))
        .values
        .toList();
    return Future.delayed(Duration(seconds: 2))
        .then((_) => Future.value(result));
  }

  FeedState _mapPostEventToState(PostEvent event) {
    final post = state.feedItems
            .firstWhere((e) => e is PostViewModel && e.id == event.postId)
        as PostViewModel;
    if (post != null) {
      PostViewModel postToUpdate;
      if (event is Like) {
        final likes = post.likes + 1;
        postToUpdate = post.copy(liked: true, likes: likes);
        // TODO: send like http request
      } else if (event is Unlike) {
        final likes = max<int>(0, post.likes - 1);
        postToUpdate = post.copy(liked: false, likes: likes);
        // TODO: send unlike http request
      } else if (event is ExpandDescription) {
        postToUpdate = post.copy(descriptionExpanded: true);
      } else if (event is CollapseDescription) {
        postToUpdate = post.copy(descriptionExpanded: false);
      }

      final updatedPostsViewModels = List.of(state.feedItems);
      final postIndex = updatedPostsViewModels.indexOf(post);
      updatedPostsViewModels
          .replaceRange(postIndex, postIndex + 1, [postToUpdate]);
      return state.copy(feedItems: updatedPostsViewModels);
    } else {
      return state.copy();
    }
  }

  // endregion

  // TODO: delete generating posts func

  List<PostViewModel> _generatePostsPage() {
    final postsStub = [
      PostViewModel(
          id: 123,
          userAvaratUrl:
              'https://images.unsplash.com/photo-1510616022132-9976466385a8',
          userName: 'Granny',
          imageUrl:
              'https://images.unsplash.com/photo-1486427944299-d1955d23e34d',
          description:
              'В качестве рекламы моего рецепта могу сказать следующее.',
          likes: 0,
          liked: false),
      PostViewModel(
          id: 124,
          userAvaratUrl: null,
          userName: 'DEady',
          imageUrl:
              'https://images.unsplash.com/photo-1510616022132-9976466385a8',
          description:
              'В качестве рекламы моего рецепта могу сказать следующее: '
              'когда муж моей подруги, капитан рыболовного судна, возвращался'
              ' после 4 - 6 месяцев отсутствия домой, он звонил из Норвегии '
              'или уже из Мурманска и просил меня испечь для него этот торт. '
              'И я пекла. Оля рассказывает, что огромный торт он съедал один,'
              ' никому не давал ни кусочка... говорил: "Это МОЙ торт! Он ДЛЯ'
              ' МЕНЯ сделан!" И все. Ингредиентов - самый минимум!!! '
              'Результат просто превосходный!',
          likes: 1250,
          liked: true)
    ];
    return postsStub + postsStub + postsStub + postsStub + postsStub;
  }
}

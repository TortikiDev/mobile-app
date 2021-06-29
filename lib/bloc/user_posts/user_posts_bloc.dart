import 'dart:async';
import 'dart:math';

import '../../data/http_client/responses/responses.dart';
import '../../data/repositories/repositories.dart';
import '../../ui/reusable/list_items/progress_indicator_item.dart';
import '../../ui/screens/main/feed/post/post_view_model.dart';
import '../base_bloc.dart';
import '../error_handling/index.dart';
import 'index.dart';

class UserPostsBloc extends BaseBloc<UserPostsEvent, UserPostsState> {
  // region Properties

  final PostsRepository postsRepository;

  // endregion

  // region Lifecycle

  UserPostsBloc({
    bool isMyPosts = false,
    required int userId,
    required this.postsRepository,
    required ErrorHandlingBloc errorHandlingBloc,
  }) : super(
            initialState: UserPostsState.initial(
              isMyPosts: isMyPosts,
              userId: userId,
            ),
            errorHandlingBloc: errorHandlingBloc);

  @override
  Stream<UserPostsState> mapEventToState(UserPostsEvent event) async* {
    if (event is BlocInit) {
      yield state.copy(loadingFirstPage: true);
      final posts = await _getPostsFirstPage();
      yield state.copy(feedItems: posts, loadingFirstPage: false);
    } else if (event is PullToRefresh) {
      final posts = await _getPostsFirstPage();
      yield state.copy(feedItems: posts);
      event.onComplete();
    } else if (event is LoadNextPage) {
      final initialFeedItems = state.feedItems;
      final feedItemsOnLoad = initialFeedItems + [ProgressIndicatorItem()];
      yield state.copy(loadingNextPage: true, feedItems: feedItemsOnLoad);
      final postNextPage = await _getPostsNextPage();
      final updatedFeedItems = initialFeedItems + postNextPage;
      yield state.copy(loadingNextPage: false, feedItems: updatedFeedItems);
    } else if (event is PostEvent) {
      yield _mapPostEventToState(event);
    }
  }

  // endregion

  // Private methods

  Future<List<PostViewModel>> _getPostsFirstPage() async {
    List<PostResponse> firstPageResponse;
    final request = state.isMyPosts
        ? postsRepository.getMyPosts()
        : postsRepository.getPostsOfUser(userId: state.userId);
    try {
      firstPageResponse = await request;
    } on Exception catch (e) {
      errorHandlingBloc.add(ExceptionRaised(e));
      return [];
    }
    final result = firstPageResponse.map(_mapPostResponseToViewModel).toList();
    return result;
  }

  Future<List<PostViewModel>> _getPostsNextPage() async {
    final lastItem =
        state.feedItems.lastWhere((e) => e is PostViewModel) as PostViewModel;
    final lastId = lastItem.id;
    List<PostResponse> nextPageResponse;
    final request = state.isMyPosts
        ? postsRepository.getMyPosts(lastId: lastId)
        : postsRepository.getPostsOfUser(userId: state.userId, lastId: lastId);
    try {
      nextPageResponse = await request;
    } on Exception catch (e) {
      errorHandlingBloc.add(ExceptionRaised(e));
      nextPageResponse = [];
    }
    final result = nextPageResponse.map(_mapPostResponseToViewModel).toList();
    return result;
  }

  PostViewModel _mapPostResponseToViewModel(PostResponse response) =>
      PostViewModel(
          id: response.id,
          userAvaratUrl: response.userAvaratUrl,
          userName: response.userName,
          userId: response.userId,
          userGender: response.userGender,
          imageUrl: response.imageUrl,
          description: response.description,
          likes: response.likes,
          liked: response.liked);

  UserPostsState _mapPostEventToState(PostEvent event) {
    final post = state.feedItems
            .firstWhere((e) => e is PostViewModel && e.id == event.postId)
        as PostViewModel;
    late PostViewModel postToUpdate;
    if (event is Like) {
      final likes = post.likes + 1;
      postToUpdate = post.copy(liked: true, likes: likes);
      try {
        postsRepository.likePost(postId: event.postId);
      } on Exception catch (e) {
        errorHandlingBloc.add(ExceptionRaised(e));
      }
    } else if (event is Unlike) {
      final likes = max<int>(0, post.likes - 1);
      postToUpdate = post.copy(liked: false, likes: likes);
      try {
        postsRepository.unlikePost(postId: event.postId);
      } on Exception catch (e) {
        errorHandlingBloc.add(ExceptionRaised(e));
      }
    } else if (event is ExpandDescription) {
      postToUpdate = post.copy(descriptionExpanded: true);
    } else if (event is CollapseDescription) {
      postToUpdate = post.copy(descriptionExpanded: false);
    }

    final updatedPostsViewModels = state.feedItems;
    final postIndex = updatedPostsViewModels.indexOf(post);
    updatedPostsViewModels
        .replaceRange(postIndex, postIndex + 1, [postToUpdate]);
    return state.copy(feedItems: updatedPostsViewModels);
  }

  // endregion
}

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../ui/screens/main/feed/post/post_view_model.dart';
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
      // TODO: Load posts from server
      final postsStub = [
        PostViewModel(
            id: '123',
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
            id: '124',
            userAvaratUrl: null,
            userName: 'DEady',
            imageUrl:
                'https://images.unsplash.com/photo-1510616022132-9976466385a8',
            description:
                'В качестве рекламы моего рецепта могу сказать следующее: '
                'когда муж моей подруги, капитан рыболовного судна, возвращался'
                ' после 4 -6 месяцев отсутствия домой, он звонил из Норвегии '
                'или уже из Мурманска и просил меня испечь для него этот торт. '
                'И я пекла. Оля рассказывает, что огромный торт он съедал один,'
                ' никому не давал ни кусочка... говорил: "Это МОЙ торт! Он ДЛЯ'
                ' МЕНЯ сделан!" И все. Ингредиентов - самый минимум!!! '
                'Результат просто превосходный!',
            likes: 1250,
            liked: true)
      ];
      yield state.copy(postsViewModels: postsStub);
    } else if (event is Like) {
      yield _mapLikeEventToState(event.postId);
    } else if (event is ExpandDescription) {
      yield _mapExpandDescriptionEventToState(event.postId);
    }
  }

  // endregion

  // Private methods

  FeedState _mapLikeEventToState(String postId) {
    // TODO: handle post like
    print('[LIKE] postId: $postId');
    return state.copy();
  }

  FeedState _mapExpandDescriptionEventToState(String postId) {
    final post = state.postsViewModels.firstWhere((e) => e.id == postId);
    if (post != null) {
      final expandedPost = post.copy(descriptionExpanded: true);
      final updatedPostsViewModels = List.of(state.postsViewModels);
      final postIndex = updatedPostsViewModels.indexOf(post);
      updatedPostsViewModels
          .replaceRange(postIndex, postIndex + 1, [expandedPost]);
      return state.copy(postsViewModels: updatedPostsViewModels);
    } else {
      return state.copy();
    }
  }

  // endregion
}

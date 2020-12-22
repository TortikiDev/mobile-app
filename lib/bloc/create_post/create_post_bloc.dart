import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/repositories/posts_repository.dart';
import '../base_bloc.dart';
import '../error_handling/index.dart';
import 'index.dart';

class CreatePostBloc extends BaseBloc<CreatePostEvent, CreatePostState> {
  // region Properties

  final PostsRepository postsRepository;

  // endregion

  // region Lifecycle

  CreatePostBloc(
      {@required this.postsRepository,
      @required ErrorHandlingBloc errorHandlingBloc})
      : super(
            initialState: CreatePostState.initial(),
            errorHandlingBloc: errorHandlingBloc);

  @override
  Stream<CreatePostState> mapEventToState(CreatePostEvent event) async* {
    if (event is BlocInit) {
    } else if (event is PhotoPicked) {
      yield state.copy(photo: event.photo);
      yield state.copy(canCreatePost: state.photo != null);
    } else if (event is DescriptionChanged) {
      yield state.copy(description: event.text);
    } else if (event is CreatePost) {
      yield state.copy(creatingPost: true);
      bool success;
      try {
        await postsRepository.createPost(
            photo: state.photo, description: state.description);
        success = true;
      } on Exception catch (error) {
        errorHandlingBloc.add(ExceptionRaised(error));
        success = false;
      }
      yield state.copy(creatingPost: false, postSuccessfulyCreated: success);
    }
  }

  // endregion
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tortiki/bloc/create_post/index.dart';
import 'package:widget_factory/widget_factory.dart';
import 'package:tortiki/ui/screens/main/create_post/create_post_screen.dart';

class _MockCreatePostBloc extends MockBloc<CreatePostEvent, CreatePostState>
    implements CreatePostBloc {}

class _MockImagePicker extends Mock implements ImagePicker {}

class TestCreatePostScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    final createPostInitialState = CreatePostState.initial();
    registerFallbackValue(createPostInitialState);
    registerFallbackValue(BlocInit());
    final createPostBloc = _MockCreatePostBloc();
    when(() => createPostBloc.state).thenReturn(createPostInitialState);

    final imagePicker = _MockImagePicker();

    return BlocProvider<CreatePostBloc>(
      create: (context) => createPostBloc,
      child: CreatePostScreen(imagePicker: imagePicker),
    );
  }
}

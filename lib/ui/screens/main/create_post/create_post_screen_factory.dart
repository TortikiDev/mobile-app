import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:widget_factory/widget_factory.dart';

import '../../../../bloc/create_post/index.dart';
import '../../../../bloc/error_handling/index.dart';
import '../../../../data/repositories/repositories.dart';
import 'create_post_screen.dart';

class CreatePostScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    return Builder(builder: (context) {
      final postsRepository = RepositoryProvider.of<PostsRepository>(context);
      final errorHandlingBloc = BlocProvider.of<ErrorHandlingBloc>(context);
      final createPostBloc = CreatePostBloc(
          postsRepository: postsRepository,
          errorHandlingBloc: errorHandlingBloc)
        ..add(BlocInit());
      final imagePicker = ImagePicker();
      return BlocProvider(
          create: (context) => createPostBloc,
          child: CreatePostScreen(imagePicker: imagePicker));
    });
  }
}

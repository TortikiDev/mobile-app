import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/create_post/index.dart';
import '../../../../bloc/error_handling/index.dart';
import '../../../../data/repositories/repositories.dart';
import '../../../reusable/widget_factory.dart';
import 'create_post_screen.dart';

class CreatePostScreenFactoryData {
  final PostsRepository postsRepository;

  const CreatePostScreenFactoryData({@required this.postsRepository});
}

class CreatePostScreenFactory
    implements WidgetFactory<CreatePostScreenFactoryData> {
  @override
  Widget createWidget({CreatePostScreenFactoryData data}) {
    return Builder(builder: (context) {
      final errorHandlingBloc = BlocProvider.of<ErrorHandlingBloc>(context);
      final createPostBloc = CreatePostBloc(
          postsRepository: data.postsRepository,
          errorHandlingBloc: errorHandlingBloc)
        ..add(BlocInit());
      return BlocProvider(
          create: (context) => createPostBloc, child: CreatePostScreen());
    });
  }
}

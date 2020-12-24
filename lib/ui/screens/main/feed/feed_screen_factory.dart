import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/error_handling/index.dart';
import '../../../../bloc/feed/index.dart';
import '../../../../data/repositories/repositories.dart';
import '../../../reusable/widget_factory.dart';
import 'feed_screen.dart';

class FeedScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    return Builder(builder: (context) {
      final postsRepository = RepositoryProvider.of<PostsRepository>(context);
      return BlocProvider(
          create: (context) => FeedBloc(
              postsRepository: postsRepository,
              errorHandlingBloc: BlocProvider.of<ErrorHandlingBloc>(context))
            ..add(BlocInit()),
          child: FeedScreen());
    });
  }
}

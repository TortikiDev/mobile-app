import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widget_factory/widget_factory.dart';

import '../../../../bloc/error_handling/index.dart';
import '../../../../bloc/feed/index.dart';
import '../../../../data/repositories/repositories.dart';
import 'feed_screen.dart';

class FeedScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    return BlocProvider(
      create: (context) => FeedBloc(
        postsRepository: RepositoryProvider.of<PostsRepository>(context),
        errorHandlingBloc: BlocProvider.of<ErrorHandlingBloc>(context),
      )..add(BlocInit()),
      child: FeedScreen(),
    );
  }
}

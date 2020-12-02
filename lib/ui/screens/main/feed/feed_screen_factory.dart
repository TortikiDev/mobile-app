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
    final postsRepository = PostsRepository();
    final accountRepository = AccountRepository();
    return BlocProvider(
        create: (context) => FeedBloc(
            postsRepository: postsRepository,
            accountRepository: accountRepository,
            errorHandlingBloc: BlocProvider.of<ErrorHandlingBloc>(context))
          ..add(BlocInit()),
        child: FeedScreen());
  }
}

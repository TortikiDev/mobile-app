import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/error_handling/index.dart';
import '../../../bloc/main/index.dart';
import '../../../data/repositories/account_repository.dart';
import '../../../data/repositories/jwt_repository.dart';
import '../../../data/repositories/posts_repository.dart';
import '../../reusable/in_develop_screen_factory.dart';
import '../../reusable/widget_factory.dart';
import 'feed/feed_screen_factory.dart';
import 'main_screen.dart';

class MainScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    return Builder(builder: (context) {
      final jwtRepository = JwtRepository();
      final accountRepository = AccountRepository();
      final postsRepository = PostsRepository();
      final errorHandlingBloc = BlocProvider.of<ErrorHandlingBloc>(context);
      final mainBloc = MainBloc(
          jwtRepository: jwtRepository,
          accountRepository: accountRepository,
          errorHandlingBloc: errorHandlingBloc)
        ..add(BlocInit());

      final feedScreenFactory = FeedScreenFactory();
      // TODO: use actual recipes screen factory instead
      final recipesScreenFactory = InDevelopWidgetFactory();

      return MultiRepositoryProvider(
          providers: [
            RepositoryProvider(create: (context) => jwtRepository),
            RepositoryProvider(create: (context) => accountRepository),
            RepositoryProvider(create: (context) => postsRepository),
          ],
          child: BlocProvider(
              create: (context) => mainBloc,
              child: MainScreen(
                  feedScreenFactory: feedScreenFactory,
                  recipesScreenFactory: recipesScreenFactory)));
    });
  }
}

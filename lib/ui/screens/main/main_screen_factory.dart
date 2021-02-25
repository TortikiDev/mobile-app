import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/error_handling/index.dart';
import '../../../bloc/main/index.dart';
import '../../../data/repositories/account_repository.dart';
import '../../../data/repositories/jwt_repository.dart';
import '../../../data/repositories/posts_repository.dart';
import '../../../data/repositories/repositories.dart';
import '../../reusable/widget_factory.dart';
import 'feed/feed_screen_factory.dart';
import 'main_screen.dart';
import 'recipes/recipes_screen_factory.dart';
import 'search_recipes/search_recipes_screen_factory.dart';

class MainScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    return Builder(builder: (context) {
      final jwtRepository = JwtRepository();
      final accountRepository = AccountRepository();
      final postsRepository = PostsRepository();
      final recipesRepository = RecipesRepository();
      final errorHandlingBloc = BlocProvider.of<ErrorHandlingBloc>(context);
      final mainBloc = MainBloc(
          jwtRepository: jwtRepository,
          accountRepository: accountRepository,
          errorHandlingBloc: errorHandlingBloc)
        ..add(BlocInit());

      final feedScreenFactory = FeedScreenFactory();
      final recipesScreenFactory = RecipesScreenFactory();
      final searchRecipesScreenFactory = SearchRecipesScreenFactory();

      return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => jwtRepository),
          RepositoryProvider(create: (context) => accountRepository),
          RepositoryProvider(create: (context) => postsRepository),
          RepositoryProvider(create: (context) => recipesRepository)
        ],
        child: BlocProvider(
          create: (context) => mainBloc,
          child: MainScreen(
            feedScreenFactory: feedScreenFactory,
            recipesScreenFactory: recipesScreenFactory,
            searchRecipesScreenFactory: searchRecipesScreenFactory,
          ),
        ),
      );
    });
  }
}

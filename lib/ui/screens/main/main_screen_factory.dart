import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widget_factory/widget_factory.dart';

import '../../../bloc/error_handling/index.dart';
import '../../../bloc/main/index.dart';
import '../../../data/repositories/repositories.dart';
import 'feed/feed_screen_factory.dart';
import 'main_screen.dart';
import 'recipes/recipes_screen_factory.dart';
import 'search_recipes/search_recipes_screen_factory.dart';

class MainScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    return Builder(
      builder: (context) {
        final jwtRepository = RepositoryProvider.of<JwtRepository>(context);
        final accountRepository =
            RepositoryProvider.of<AccountRepository>(context);
        final errorHandlingBloc = BlocProvider.of<ErrorHandlingBloc>(context);
        final mainBloc = MainBloc(
            jwtRepository: jwtRepository,
            accountRepository: accountRepository,
            errorHandlingBloc: errorHandlingBloc)
          ..add(BlocInit());

        final feedScreenFactory = FeedScreenFactory();
        final recipesScreenFactory = RecipesScreenFactory();
        final searchRecipesScreenFactory = SearchRecipesScreenFactory();

        return BlocProvider(
          create: (context) => mainBloc,
          child: MainScreen(
            feedScreenFactory: feedScreenFactory,
            recipesScreenFactory: recipesScreenFactory,
            searchRecipesScreenFactory: searchRecipesScreenFactory,
          ),
        );
      },
    );
  }
}

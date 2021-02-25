import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/error_handling/index.dart';
import '../../../../bloc/search_recipes/index.dart';
import '../../../../data/repositories/repositories.dart';
import '../../../reusable/widget_factory.dart';
import 'search_recipes_screen.dart';

class SearchRecipesScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    return BlocProvider(
      create: (context) {
        final recipesRepository =
            RepositoryProvider.of<RecipesRepository>(context);
        final bookmarkedRecipesRepository =
            RepositoryProvider.of<BookmarkedRecipesRepository>(context);
        final errorHandlingBloc = BlocProvider.of<ErrorHandlingBloc>(context);
        return SearchRecipesBloc(
          recipesRepository: recipesRepository,
          bookmarkedRecipesRepository: bookmarkedRecipesRepository,
          errorHandlingBloc: errorHandlingBloc,
        )..add(BlocInit());
      },
      child: SearchRecipesScreen(),
    );
  }
}

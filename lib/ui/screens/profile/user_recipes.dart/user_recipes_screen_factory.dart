import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widget_factory/widget_factory.dart';

import '../../../../bloc/user_recipes/index.dart';
import '../../recipe_details/recipe_details_screen_factory.dart';
import 'user_recipes_screen.dart';

class UserRecipesScreenFactoryData {
  final bool isMyRecipes;
  final int userId;

  UserRecipesScreenFactoryData({
    required this.isMyRecipes,
    required this.userId,
  });
}

class UserRecipesScreenFactory
    implements WidgetFactory<UserRecipesScreenFactoryData> {
  @override
  Widget createWidget({UserRecipesScreenFactoryData? data}) {
    final recipeDetailsScreenFactory = RecipeDetailsScreenFactory();
    return BlocProvider(
      create: (context) => UserRecipesBloc(
        isMyRecipes: data!.isMyRecipes,
        userId: data.userId,
        recipesRepository: RepositoryProvider.of(context),
        bookmarkedRecipesRepository: RepositoryProvider.of(context),
        errorHandlingBloc: BlocProvider.of(context),
      )..add(BlocInit()),
      child: UserRecipesScreen(
        recipeDetailsScreenFactory: recipeDetailsScreenFactory,
      ),
    );
  }
}

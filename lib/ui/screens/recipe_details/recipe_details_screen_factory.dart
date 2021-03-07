import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/recipe_details/index.dart';
import '../../reusable/widget_factory.dart';
import 'recipe_details_screen.dart';

class RecipeDetailsScreenFactoryData {
  final int recipeId;

  const RecipeDetailsScreenFactoryData(this.recipeId);
}

class RecipeDetailsScreenFactory
    implements WidgetFactory<RecipeDetailsScreenFactoryData> {
  @override
  Widget createWidget({RecipeDetailsScreenFactoryData data}) {
    return BlocProvider(
      create: (context) => RecipeDetailsBloc(
        recipeId: data.recipeId,
        recipesRepository: RepositoryProvider.of(context),
        errorHandlingBloc: BlocProvider.of(context),
      )..add(BlocInit()),
      child: RecipeDetailsScreen(),
    );
  }
}

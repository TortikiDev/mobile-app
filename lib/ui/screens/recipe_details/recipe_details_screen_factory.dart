import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/recipe_details/index.dart';
import '../../../data/http_client/responses/recipe_response.dart';
import '../../reusable/widget_factory.dart';
import 'recipe_details_screen.dart';

class RecipeDetailsScreenFactoryData {
  final int id;
  final String title;
  final double complexity;
  final List<String> _imageUrls;

  List<String> get imageUrls => List.of(_imageUrls);

  RecipeDetailsScreenFactoryData({
    @required this.id,
    @required this.title,
    @required this.complexity,
    @required List<String> imageUrls,
  }) : _imageUrls = imageUrls;
}

class RecipeDetailsScreenFactory
    implements WidgetFactory<RecipeDetailsScreenFactoryData> {
  @override
  Widget createWidget({RecipeDetailsScreenFactoryData data}) {
    final recipe = RecipeResponse(
      id: data.id,
      title: data.title,
      complexity: data.complexity,
      imageUrls: data.imageUrls,
    );
    return BlocProvider(
      create: (context) => RecipeDetailsBloc(
        recipe: recipe,
        recipesRepository: RepositoryProvider.of(context),
        bookmarkedRecipesRepository: RepositoryProvider.of(context),
        errorHandlingBloc: BlocProvider.of(context),
      )..add(BlocInit()),
      child: RecipeDetailsScreen(),
    );
  }
}

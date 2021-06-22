import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widget_factory/widget_factory.dart';

import '../../../bloc/recipe_details/index.dart';
import '../../../data/http_client/responses/recipe_response.dart';
import '../profile/external_confectioner_profile/external_confectioner_profile_screen_factory.dart';
import 'recipe_details_screen.dart';

class RecipeDetailsScreenFactoryData {
  final int id;
  final String title;
  final double complexity;
  final List<String> _imageUrls;
  final bool isInBookmarks;

  List<String> get imageUrls => List.of(_imageUrls);

  RecipeDetailsScreenFactoryData({
    required this.id,
    required this.title,
    required this.complexity,
    required List<String> imageUrls,
    required this.isInBookmarks,
  }) : _imageUrls = imageUrls;
}

class RecipeDetailsScreenFactory
    implements WidgetFactory<RecipeDetailsScreenFactoryData> {
  @override
  Widget createWidget({RecipeDetailsScreenFactoryData? data}) {
    final confectionerProfileScreenFactory =
        ExternalConfectionerProfileScreenFactory();
    final recipe = RecipeResponse(
      id: data!.id,
      title: data.title,
      complexity: data.complexity,
      imageUrls: data.imageUrls,
      userId: null,
    );
    return BlocProvider(
      create: (context) => RecipeDetailsBloc(
        recipe: recipe,
        isInBookmarks: data.isInBookmarks,
        recipesRepository: RepositoryProvider.of(context),
        bookmarkedRecipesRepository: RepositoryProvider.of(context),
        errorHandlingBloc: BlocProvider.of(context),
      )..add(BlocInit()),
      child: RecipeDetailsScreen(
        confectionerProfileScreenFactory: confectionerProfileScreenFactory,
      ),
    );
  }
}

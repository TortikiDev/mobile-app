import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/http_client/responses/responses.dart';
import '../../data/repositories/repositories.dart';
import '../base_bloc.dart';
import '../error_handling/index.dart';
import 'index.dart';

class RecipeDetailsBloc
    extends BaseBloc<RecipeDetailsEvent, RecipeDetailsState> {
  // region Properties

  final RecipesRepository recipesRepository;

  // endregion

  // region Lifecycle

  RecipeDetailsBloc({
    @required RecipeResponse recipe,
    @required this.recipesRepository,
    @required ErrorHandlingBloc errorHandlingBloc,
  }) : super(
          initialState: RecipeDetailsState.initial(recipe: recipe),
          errorHandlingBloc: errorHandlingBloc,
        );

  @override
  Stream<RecipeDetailsState> mapEventToState(RecipeDetailsEvent event) async* {
    if (event is BlocInit) {
      yield state.copy(loading: true);
      final recipe = await recipesRepository.getRecipe(state.recipe.id);
      yield state.copy(recipe: recipe, loading: false);
    }
  }

  // endregion
}

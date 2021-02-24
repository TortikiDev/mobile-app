import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../base_bloc.dart';
import '../error_handling/index.dart';
import 'index.dart';

class CreateRecipeBloc extends BaseBloc<CreateRecipeEvent, CreateRecipeState> {
  // region Properties

  // endregion

  // region Lifecycle

  CreateRecipeBloc({@required ErrorHandlingBloc errorHandlingBloc})
      : super(
            initialState: CreateRecipeState.initial(),
            errorHandlingBloc: errorHandlingBloc);

  @override
  Stream<CreateRecipeState> mapEventToState(CreateRecipeEvent event) async* {
    if (event is BlocInit) {
    } else if (event is TitleChanged) {
      yield state.copy(title: event.text);
    } else if (event is PlusComplexity) {
      final complexity = min(state.complexity + 0.5, 5.0);
      yield state.copy(complexity: complexity);
    } else if (event is MinusComplexity) {
      final complexity = max(state.complexity - 0.5, 0.5);
      yield state.copy(complexity: complexity);
    } else if (event is DescriptionChanged) {
      yield state.copy(description: event.text);
    } else if (event is IngredientsChanged) {
      yield state.copy(ingredients: event.ingredients);
    } else if (event is CookingStepsChanged) {
      yield state.copy(cookingSteps: event.text);
    } else if (event is CreateRecipe) {}
  }

  // endregion
}

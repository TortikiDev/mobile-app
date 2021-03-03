import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/recipe_details/index.dart';

class RecipeDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: add scaffold body
    return BlocBuilder<RecipeDetailsBloc, RecipeDetailsState>(
        builder: (context, state) => Scaffold());
  }
}
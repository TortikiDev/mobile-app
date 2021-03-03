import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/error_handling/error_handling_bloc.dart';
import '../../../bloc/recipe_details/index.dart';
import '../../../ui/reusable/widget_factory.dart';
import 'recipe_details_screen.dart';

class RecipeDetailsScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    return BlocProvider(
        create: (context) => RecipeDetailsBloc(
            errorHandlingBloc: BlocProvider.of<ErrorHandlingBloc>(context),)
          ..add(BlocInit()),
        child: RecipeDetailsScreen(),);
  }
}

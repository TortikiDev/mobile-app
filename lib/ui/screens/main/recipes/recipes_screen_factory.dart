import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/error_handling/index.dart';
import '../../../../bloc/recipes/index.dart';
import '../../../reusable/widget_factory.dart';
import 'recipes_screen.dart';

class RecipesScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    return BlocProvider(
        create: (context) => RecipesBloc(
            errorHandlingBloc: BlocProvider.of<ErrorHandlingBloc>(context))
          ..add(BlocInit()),
        child: RecipesScreen());
  }
}

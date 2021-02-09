import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/create_recipe/index.dart';
import '../../../../bloc/error_handling/index.dart';
import '../../../reusable/widget_factory.dart';
import 'create_recipe_screen.dart';

class CreateRecipeScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    return BlocProvider(
      create: (context) => CreateRecipeBloc(
        errorHandlingBloc: BlocProvider.of<ErrorHandlingBloc>(context),
      )..add(BlocInit()),
      child: CreateRecipeScreen(),
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widget_factory/widget_factory.dart';

import '../../../../bloc/error_handling/index.dart';
import '../../../../bloc/user_recipes/index.dart';
import 'user_recipes_screen.dart';

class UserRecipesScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    return BlocProvider(
        create: (context) => UserRecipesBloc(
            errorHandlingBloc: BlocProvider.of<ErrorHandlingBloc>(context),)
          ..add(BlocInit()),
        child: UserRecipesScreen(),);
  }
}

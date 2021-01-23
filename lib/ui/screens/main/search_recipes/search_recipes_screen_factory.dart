import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../bloc/error_handling/index.dart';
import '../../../../bloc/search_recipes/index.dart';
import '../../../reusable/widget_factory.dart';
import 'search_recipes_screen.dart';

class SearchRecipesScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    return BlocProvider(
      create: (context) {
        final http = Provider.of(context);

        return SearchRecipesBloc(
          errorHandlingBloc: BlocProvider.of<ErrorHandlingBloc>(context),
        )..add(BlocInit());
      },
      child: SearchRecipesScreen(),
    );
  }
}

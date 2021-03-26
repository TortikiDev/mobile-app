import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widget_factory/widget_factory.dart';

import '../../../bloc/error_handling/index.dart';
import '../../../bloc/map/index.dart';
import '../../../data/repositories/repositories.dart';
import 'map_screen.dart';

class MapScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    return BlocProvider(
      create: (context) => MapBloc(
        confectionersRepository:
            RepositoryProvider.of<ConfectionersRepository>(context),
        errorHandlingBloc: BlocProvider.of<ErrorHandlingBloc>(context),
      )..add(BlocInit()),
      child: MapScreen(),
    );
  }
}

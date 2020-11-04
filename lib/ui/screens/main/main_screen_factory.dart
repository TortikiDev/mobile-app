import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/error_handling/index.dart';
import '../../../bloc/main/index.dart';
import '../../reusable/widget_factory.dart';
import 'main_screen.dart';

class MainScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    return BlocProvider(
        create: (context) => MainBloc(
            errorHandlingBloc: BlocProvider.of<ErrorHandlingBloc>(context))
          ..add(BlocInit()),
        child: MainScreen());
  }
}

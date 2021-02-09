import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/bottom_navigation_bloc/index.dart';
import '../reusable/widget_factory.dart';
import 'bottom_navigation_controller.dart';

class BottomNavigationControllerFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    final bottomNavigationBloc = BottomNavigationBloc();
    return BlocProvider(
      create: (context) => bottomNavigationBloc,
      child: BottomNavigationController(),
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widget_factory/widget_factory.dart';

import '../../../../bloc/client_profile/index.dart';
import '../../../../bloc/error_handling/index.dart';
import 'client_profile_screen.dart';

class ClientProfileScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    return BlocProvider(
      create: (context) => ClientProfileBloc(
        errorHandlingBloc: BlocProvider.of<ErrorHandlingBloc>(context),
      )..add(BlocInit()),
      child: ClientProfileScreen(),
    );
  }
}

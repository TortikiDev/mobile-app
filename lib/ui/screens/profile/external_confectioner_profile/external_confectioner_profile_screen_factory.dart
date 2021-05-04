import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widget_factory/widget_factory.dart';

import '../../../../bloc/error_handling/index.dart';
import '../../../../bloc/external_confectioner_profile/index.dart';
import 'external_confectioner_profile_screen.dart';

class ExternalConfectionerProfileScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    return BlocProvider(
      create: (context) => ExternalConfectionerProfileBloc(
        errorHandlingBloc: BlocProvider.of<ErrorHandlingBloc>(context),
      )..add(BlocInit()),
      child: ExternalConfectionerProfileScreen(),
    );
  }
}

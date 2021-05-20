import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tortiki/bloc/error_handling/index.dart';
import 'package:tortiki/bloc/profile/auth_event.dart';
import 'package:tortiki/bloc/profile/index.dart';
import 'package:tortiki/ui/reusable/widget_factory.dart';

import 'profile_screen.dart';

class ProfileScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    final authParts = AuthParts.nonAuth;
    return BlocProvider(
        create: (context) => AuthBloc(
            authParts: authParts,
            errorHandlingBloc: BlocProvider.of<ErrorHandlingBloc>(context))
          ..add(BlocInit()),
        child: ProfileScreen());
  }
}

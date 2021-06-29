import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widget_factory/widget_factory.dart';

import '../../../../bloc/client_profile/index.dart';
import '../../../../bloc/error_handling/index.dart';
import '../pick_city/pick_city_screen_factory.dart';
import 'client_profile_screen.dart';

class ClientProfileScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    final pickCityFacctory = PickCityScreenFactory();
    return BlocProvider(
      create: (context) => ClientProfileBloc(
        accountRepository: RepositoryProvider.of(context),
        errorHandlingBloc: BlocProvider.of<ErrorHandlingBloc>(context),
      )..add(BlocInit()),
      child: ClientProfileScreen(pickCityScreenFactory: pickCityFacctory),
    );
  }
}

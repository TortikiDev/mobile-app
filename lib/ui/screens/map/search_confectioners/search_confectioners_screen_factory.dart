import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widget_factory/widget_factory.dart';

import '../../../../bloc/error_handling/index.dart';
import '../../../../bloc/search_confectioners/index.dart';
import '../../../../data/http_client/requests/requests.dart';
import '../../../../data/repositories/repositories.dart';
import '../../profile/external_confectioner_profile/external_confectioner_profile_screen_factory.dart';
import 'search_confectioners_screen.dart';

class SearchConfectionersScreenFactoryData {
  final LatLong mapCenter;

  SearchConfectionersScreenFactoryData({required this.mapCenter});
}

class SearchConfectionersScreenFactory
    implements WidgetFactory<SearchConfectionersScreenFactoryData> {
  @override
  Widget createWidget({SearchConfectionersScreenFactoryData? data}) {
    final confectionerProfileScreenFactory =
        ExternalConfectionerProfileScreenFactory();

    return BlocProvider(
      create: (context) {
        return SearchConfectionersBloc(
          mapCenter: data!.mapCenter,
          confectionersRepository:
              RepositoryProvider.of<ConfectionersRepository>(context),
          errorHandlingBloc: BlocProvider.of<ErrorHandlingBloc>(context),
        )..add(BlocInit());
      },
      child: SearchConfectionersScreen(
        confectionerProfileScreenFactory: confectionerProfileScreenFactory,
      ),
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:widget_factory/widget_factory.dart';

import '../../../../bloc/pick_city/index.dart';
import '../../../../data/repositories/repositories.dart';
import 'pick_city_screen.dart';

class PickCityScreenFactoryData {
  final String selectedCity;

  PickCityScreenFactoryData({required this.selectedCity});
}

class PickCityScreenFactory
    implements WidgetFactory<PickCityScreenFactoryData> {
  @override
  Widget createWidget({PickCityScreenFactoryData? data}) {
    return BlocProvider(
      create: (context) {
        final citiesRepository = CitiesRepository();
        final locationService = Location();

        return PickCityBloc(
          selectedCity: data!.selectedCity,
          citiesRepository: citiesRepository,
          locationService: locationService,
          errorHandlingBloc: BlocProvider.of(context),
        )..add(BlocInit());
      },
      child: PickCityScreen(),
    );
  }
}

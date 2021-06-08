import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:widget_factory/widget_factory.dart';

import '../../../../bloc/client_profile/index.dart';
import '../../../reusable/app_version_logo.dart';
import '../../../reusable/buttons/primary_button.dart';
import '../../../reusable/profile_field.dart';
import '../pick_city/pick_city_screen_factory.dart';

class ClientProfileScreen extends StatelessWidget {
  final WidgetFactory pickCityScreenFactory;

  const ClientProfileScreen({
    Key key,
    @required this.pickCityScreenFactory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.profile),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: localizations.logout,
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: BlocBuilder<ClientProfileBloc, ClientProfileState>(
        builder: (context, state) {
          return Column(
            children: [
              ProfileField(
                title: localizations.phone,
                value: state.phone,
                onTap: () {},
              ),
              ProfileField(
                title: localizations.city,
                value: state.city,
                onTap: () => _pickCity(context, state.city),
              ),
              SizedBox(height: 40),
              PrimaryButton(
                text: localizations.becomeConfectioner,
                onPressed: () => _becomeConfectioner(context),
              ),
              Spacer(),
              AppVersionLogo(),
              SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  Future<void> _pickCity(BuildContext context, String selecteCity) async {
    final screenData = PickCityScreenFactoryData(selectedCity: selecteCity);
    final route = MaterialPageRoute<String>(
      builder: (context) =>
          pickCityScreenFactory.createWidget(data: screenData),
    );
    final selectCityResult = await Navigator.of(context).push<String>(route);
    if (selectCityResult != null) {
      final event = PickCity(selectCityResult);
      BlocProvider.of<ClientProfileBloc>(context).add(event);
    }
  }

  void _becomeConfectioner(BuildContext context) {
    // TODO: go to become confectioner screen
    print('Become confectioner');
  }

  void _logout(BuildContext context) {
    final event = Logout();
    BlocProvider.of<ClientProfileBloc>(context).add(event);
  }
}

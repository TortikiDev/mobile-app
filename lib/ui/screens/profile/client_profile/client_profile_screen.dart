import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../bloc/client_profile/index.dart';
import '../../../reusable/app_version_logo.dart';
import '../../../reusable/buttons/primary_button.dart';
import '../../../reusable/profile_field.dart';

class ClientProfileScreen extends StatelessWidget {
  const ClientProfileScreen({Key key}) : super(key: key);

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
                onTap: () => _pickCity(context),
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

  void _pickCity(BuildContext context) {
    // TODO: go to pick city screen
    print('Pick city');
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

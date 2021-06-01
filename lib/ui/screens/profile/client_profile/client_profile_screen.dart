import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            tooltip: localizations.newPost,
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Column(
        children: [
          ProfileField(
            title: localizations.phone,
            value: '+7 999 987 65 43',
            onTap: () => _editPhone(context),
          ),
          ProfileField(
            title: localizations.city,
            value: 'Рязань',
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
          CircularProgressIndicator()
        ],
      ),
    );
  }

  void _editPhone(BuildContext context) {
    // TODO: go to edit phone screen
    print('Edit phone');
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
    // TODO: peerform logout
    print('Logout');
  }
}

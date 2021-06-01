import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Clientprofile extends StatelessWidget {
  const Clientprofile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.profile),
        actions: [
          IconButton(
            icon: Icon(Icons.send),
            tooltip: localizations.newPost,
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

      ],),
    );
  }

  void _logout(BuildContext context) {
    // TODO: peerform logout
    print('Logout');
  }
}

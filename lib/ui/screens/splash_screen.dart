import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.secondary,
      child: Center(
        child: ImageIcon(AssetImage('assets/tortiki_logo_big.png')),
      ),
    );
  }
}

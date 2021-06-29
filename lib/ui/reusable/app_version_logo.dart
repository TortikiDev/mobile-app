import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class AppVersionLogo extends StatelessWidget {
  const AppVersionLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Image.asset(
          'assets/main_app_bar_title.png',
          height: 28,
          color: theme.colorScheme.secondaryVariant,
        ),
        SizedBox(height: 4),
        FutureBuilder(
          future: _getVersionString(),
          builder: (context, snapshot) => snapshot.data != null
              ? Text(
                  snapshot.data.toString(),
                  style: theme.textTheme.caption
                      ?.copyWith(color: theme.colorScheme.secondaryVariant),
                )
              : Container(),
        ),
      ],
    );
  }

  Future<String> _getVersionString() async {
    final info = await PackageInfo.fromPlatform();
    return '${info.version}(${info.buildNumber})';
  }
}

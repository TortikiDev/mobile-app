import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_localizations.dart';
import '../../../bloc/main/index.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocBuilder<MainBloc, MainState>(
        builder: (context, state) => DefaultTabController(
              length: 2,
              child: Scaffold(
                  appBar: AppBar(
                      title: Image.asset('assets/main_app_bar_title.png',
                          height: 40),
                      bottom: TabBar(tabs: [
                        Tab(text: localizations.feed.toUpperCase()),
                        Tab(text: localizations.recipes.toUpperCase()),
                      ])),
                  body: TabBarView(children: [
                    Center(child: Text(localizations.feed)),
                    Center(child: Text(localizations.recipes))
                  ])),
            ));
  }
}

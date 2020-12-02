import 'package:flutter/material.dart';

import '../../../app_localizations.dart';
import '../../reusable/widget_factory.dart';

class MainScreen extends StatelessWidget {
  final WidgetFactory feedScreenFactory;
  final WidgetFactory recipesScreenFactory;

  const MainScreen(
      {Key key,
      @required this.feedScreenFactory,
      @required this.recipesScreenFactory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
              title: Image.asset('assets/main_app_bar_title.png', height: 40),
              bottom: TabBar(tabs: [
                Tab(text: localizations.feed.toUpperCase()),
                Tab(text: localizations.recipes.toUpperCase()),
              ])),
          body: TabBarView(children: [
            feedScreenFactory.createWidget(),
            recipesScreenFactory.createWidget()
          ]),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.edit),
            onPressed: () {

            },
          )),
    );
  }
}

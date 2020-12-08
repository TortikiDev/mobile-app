import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_localizations.dart';
import '../../../bloc/create_post/index.dart';
import '../../../bloc/main/index.dart';
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
      child: BlocBuilder<MainBloc, MainState>(
          builder: (context, state) => Scaffold(
              appBar: AppBar(
                  title:
                      Image.asset('assets/main_app_bar_title.png', height: 40),
                  bottom: TabBar(tabs: [
                    Tab(text: localizations.feed.toUpperCase()),
                    Tab(text: localizations.recipes.toUpperCase()),
                  ])),
              body: TabBarView(children: [
                feedScreenFactory.createWidget(),
                recipesScreenFactory.createWidget()
              ]),
              floatingActionButton: state.showCreatePostButton
                  ? FloatingActionButton(
                      child: Icon(Icons.create),
                      onPressed: () => _onCreateEntityTap(context))
                  : null)),
    );
  }

  void _onCreateEntityTap(BuildContext context) {
    final tabController = DefaultTabController.of(context);
    final tabIndex = tabController.index;
    WidgetFactory createEntityScreenFactory;
    switch (tabIndex) {
      case 0:
        createEntityScreenFactory = CreatePostScreenFactory();
        break;
      case 1:
      // TODO: use actual create recipe factory
        createEntityScreenFactory = CreatePostScreenFactory();
        break;
      default:
        throw IndexError(tabIndex, tabController);
    }

    final pageRoute = MaterialPageRoute(
        builder: (context) => createEntityScreenFactory.createWidget(),
        fullscreenDialog: true);
    Navigator.of(context).push(pageRoute);
  }
}

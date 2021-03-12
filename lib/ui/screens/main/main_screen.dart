import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../bloc/bottom_navigation_bloc/index.dart';
import '../../../bloc/main/index.dart';
import '../../reusable/widget_factory.dart';
import 'create_post/create_post_screen_factory.dart';
import 'create_recipe/create_recipe_screen_factory.dart';

class MainScreen extends StatefulWidget {
  final WidgetFactory feedScreenFactory;
  final WidgetFactory recipesScreenFactory;
  final WidgetFactory searchRecipesScreenFactory;

  const MainScreen({
    Key key,
    @required this.feedScreenFactory,
    @required this.recipesScreenFactory,
    @required this.searchRecipesScreenFactory,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _showSearchRecipesButton = false;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) {
            return DefaultTabController(
              length: 2,
              child: BlocBuilder<MainBloc, MainState>(
                builder: (context, state) => Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      title: Image.asset('assets/main_app_bar_title.png',
                          height: 40),
                      actions: _showSearchRecipesButton
                          ? [
                              IconButton(
                                key: Key('Search recipes'),
                                icon: Icon(Icons.search),
                                onPressed: () => _searchRecipes(context),
                              ),
                            ]
                          : null,
                      bottom: TabBar(
                        tabs: [
                          Tab(text: localizations.feed.toUpperCase()),
                          Tab(text: localizations.recipes.toUpperCase()),
                        ],
                        onTap: (index) {
                          setState(() {
                            _showSearchRecipesButton = index == 1;
                          });
                        },
                      ),
                    ),
                    body: TabBarView(children: [
                      widget.feedScreenFactory.createWidget(),
                      widget.recipesScreenFactory.createWidget()
                    ]),
                    floatingActionButton: state.showCreatePostButton
                        ? FloatingActionButton(
                            child: Icon(Icons.create),
                            onPressed: () => _onCreateEntityTap(context),
                          )
                        : null),
              ),
            );
          },
        );
      },
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
        createEntityScreenFactory = CreateRecipeScreenFactory();
        break;
      default:
        throw IndexError(tabIndex, tabController);
    }

    _pushFullScreenRoute(context, screenFactory: createEntityScreenFactory);
  }

  void _searchRecipes(BuildContext context) => _pushFullScreenRoute(context,
      screenFactory: widget.searchRecipesScreenFactory);

  void _pushFullScreenRoute(BuildContext context,
      {@required WidgetFactory screenFactory}) {
    final bottomNavigationBloc = BlocProvider.of<BottomNavigationBloc>(context);
    final pageRoute = MaterialPageRoute(
      builder: (context) => WillPopScope(
        child: screenFactory.createWidget(),
        onWillPop: () async {
          bottomNavigationBloc.add(ShowNavigationBar());
          return true;
        },
      ),
      fullscreenDialog: true,
    );
    Navigator.of(context).push(pageRoute);
    bottomNavigationBloc.add(HideNavigationBar());
  }
}

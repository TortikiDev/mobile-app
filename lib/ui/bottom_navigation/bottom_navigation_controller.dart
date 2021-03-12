import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../bloc/bottom_navigation_bloc/index.dart';
import '../app_theme.dart';
import '../screens/bookmarks/bookmarks_screen_factory.dart';
import '../screens/main/main_screen_factory.dart';
import 'bottom_navigation_controller_item.dart';

class BottomNavigationController extends StatefulWidget {
  BottomNavigationController({Key key}) : super(key: key);

  @override
  _BottomNavigationControllerState createState() =>
      _BottomNavigationControllerState();
}

class _BottomNavigationControllerState
    extends State<BottomNavigationController> {
  final pagesBucket = PageStorageBucket();
  final pageController = PageController();
  List<BottomNaigationControllerItem> _items;
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    if (_items == null) {
      final theme = Theme.of(context);
      final localizations = AppLocalizations.of(context);
      _items = [
        BottomNaigationControllerItem(
          MainScreenFactory().createWidget(),
          BottomNavigationBarItem(
            label: localizations.main,
            icon: ImageIcon(AssetImage('assets/cherry/cherry.png'),
                key: Key('cherry icon'), size: 24),
          ),
        ),
        BottomNaigationControllerItem(
          Container(
            color: appTheme.colorScheme.background,
            child: Center(
              child: Text(localizations.map, style: theme.textTheme.bodyText2),
            ),
          ),
          BottomNavigationBarItem(
            label: localizations.map,
            icon: Icon(Icons.location_pin),
          ),
        ),
        BottomNaigationControllerItem(
          BookmarksScreenFactory().createWidget(),
          BottomNavigationBarItem(
            label: localizations.bookmarks,
            icon: Icon(Icons.bookmark),
          ),
        ),
        BottomNaigationControllerItem(
          Container(
            color: appTheme.colorScheme.background,
            child: Center(
              child: Text(localizations.profile, style: theme.textTheme.button),
            ),
          ),
          BottomNavigationBarItem(
            label: localizations.profile,
            icon: Icon(Icons.account_circle),
          ),
        )
      ];
    }

    return BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
      builder: (context, state) => Scaffold(
        body: PageStorage(
          bucket: pagesBucket,
          child: PageView(
              physics: NeverScrollableScrollPhysics(),
              children: _items.map((e) => e.page).toList(),
              controller: pageController,
              onPageChanged: (index) => _currentPage = index),
        ),
        bottomNavigationBar: state.isHidden
            ? null
            : BottomNavigationBar(
                showSelectedLabels: false,
                showUnselectedLabels: false,
                items: _items.map((e) => e.barItem).toList(),
                currentIndex: _currentPage,
                onTap: _onItemTapped,
              ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      pageController.jumpToPage(index);
    });
  }
}

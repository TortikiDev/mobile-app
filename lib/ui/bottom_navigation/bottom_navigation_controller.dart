import 'package:flutter/material.dart';

import '../../app_localizations.dart';
import '../app_theme.dart';
import '../screens/main/main_screen_factory.dart';
import 'bottom_navigation_item.dart';

class BottomNaigationController extends StatefulWidget {
  BottomNaigationController({Key key}) : super(key: key);

  @override
  _BottomNaigationControllerState createState() =>
      _BottomNaigationControllerState();
}

class _BottomNaigationControllerState extends State<BottomNaigationController> {
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
            icon: ImageIcon(AssetImage('assets/cherry.png'),
                key: ValueKey('cherry icon'), size: 24),
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
          Container(
            color: appTheme.colorScheme.background,
            child: Center(
              child: Text(localizations.bookmarks,
                  style: theme.textTheme.headline6),
            ),
          ),
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

    return Scaffold(
      body: PageStorage(
        bucket: pagesBucket,
        child: PageView(
            physics: NeverScrollableScrollPhysics(),
            children: _items.map((e) => e.page).toList(),
            controller: pageController,
            onPageChanged: (index) => _currentPage = index),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: _items.map((e) => e.barItem).toList(),
        currentIndex: _currentPage,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      pageController.jumpToPage(index);
    });
  }
}

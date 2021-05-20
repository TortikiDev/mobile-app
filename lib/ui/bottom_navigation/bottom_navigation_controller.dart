import 'package:flutter/material.dart';

import '../../app_localizations.dart';
import '../app_theme.dart';
import '../screens/main/main_screen_factory.dart';
import 'bottom_navigation_item.dart';
import '../screens/main/profile_screen_factory.dart';

class BottomNaigationController extends StatefulWidget {
  BottomNaigationController({Key key}) : super(key: key);

  @override
  _BottomNaigationControllerState createState() =>
      _BottomNaigationControllerState();
}

class _BottomNaigationControllerState extends State<BottomNaigationController> {
  List<BottomNaigationControllerItem> _items;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

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
                    key: ValueKey('cherry icon'), size: 24))),
        BottomNaigationControllerItem(
            Container(
                color: appTheme.colorScheme.background,
                child: Center(
                    child: Text(localizations.map,
                        style: theme.textTheme.bodyText2))),
            BottomNavigationBarItem(
                label: localizations.map, icon: Icon(Icons.location_pin))),
        BottomNaigationControllerItem(
            Container(
                color: appTheme.colorScheme.background,
                child: Center(
                    child: Text(localizations.bookmarks,
                        style: theme.textTheme.headline6))),
            BottomNavigationBarItem(
                label: localizations.bookmarks, icon: Icon(Icons.bookmark))),
        BottomNaigationControllerItem(
            Container(
                color: appTheme.colorScheme.background,
                child: Center(
                    child: FlatButton(
                        onPressed: () {
                          print('test event');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileScreenFactory().createWidget()));
                        },
                        child: Text("Тестовый текст для кнопки"))
                    // Text(localizations.profile,
                    //     style: theme.textTheme.button)
                    )),
            BottomNavigationBarItem(
                label: localizations.profile, icon: Icon(Icons.account_circle)))
      ];
    }

    return Scaffold(
      body: _items.map((e) => e.page).toList()[_currentPage],
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
      _currentPage = index;
    });
  }
}

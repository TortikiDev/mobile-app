import 'package:flutter/material.dart';
import '../app_theme.dart';
import 'bottom_navigation_item.dart';

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
      _items = [
        BottomNaigationControllerItem(
            Container(
                color: appTheme.colorScheme.background,
                child: Center(
                    child: Text('Главная', style: theme.textTheme.bodyText1))),
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('assets/cherry.png'),
                    key: ValueKey('cherry icon'), size: 24),
                label: '')),
        BottomNaigationControllerItem(
            Container(
                color: appTheme.colorScheme.background,
                child: Center(
                    child: Text('Карта', style: theme.textTheme.bodyText2))),
            BottomNavigationBarItem(icon: Icon(Icons.location_pin), label: '')),
        BottomNaigationControllerItem(
            Container(
                color: appTheme.colorScheme.background,
                child: Center(
                    child:
                        Text('Избранное', style: theme.textTheme.headline6))),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: '')),
        BottomNaigationControllerItem(
            Container(
                color: appTheme.colorScheme.background,
                child: Center(
                    child: Text('Профиль', style: theme.textTheme.button))),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), label: ''))
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

import 'package:flutter/material.dart';
import '../../app_localizations.dart';
import '../app_theme.dart';
import 'bottom_navigation_item.dart';

class BottomNaigationController extends StatefulWidget {
  final AppLocalizations localizations;

  BottomNaigationController({Key key, @required this.localizations})
      : super(key: key);

  @override
  _BottomNaigationControllerState createState() =>
      _BottomNaigationControllerState(localizations);
}

class _BottomNaigationControllerState extends State<BottomNaigationController> {
  final List<BottomNaigationControllerItem> _items;
  int _currentPage = 0;

  _BottomNaigationControllerState(AppLocalizations localizations)
      : _items = [
          BottomNaigationControllerItem(
              Container(
                  color: appTheme.colorScheme.background,
                  child: Center(child: Text('Главная'))),
              BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage('assets/cherry.png'),
                      key: ValueKey('cherry icon'), size: 24),
                  label: '')),
          BottomNaigationControllerItem(
              Container(
                  color: appTheme.colorScheme.background,
                  child: Center(child: Text('Карта'))),
              BottomNavigationBarItem(
                  icon: Icon(Icons.location_pin), label: '')),
          BottomNaigationControllerItem(
              Container(
                  color: appTheme.colorScheme.background,
                  child: Center(child: Text('Избранное'))),
              BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: '')),
          BottomNaigationControllerItem(
              Container(
                  color: appTheme.colorScheme.background,
                  child: Center(child: Text('Профиль'))),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle), label: ''))
        ];

  @override
  Widget build(BuildContext context) {
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

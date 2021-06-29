import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:widget_factory/widget_factory.dart';

import 'bottom_navigation_controller_item.dart';

class BottomNavigationController extends StatefulWidget {
  final WidgetFactory mainScreenFactory;
  final WidgetFactory mapScreenFactory;
  final WidgetFactory bookmarksScreenFactory;
  final WidgetFactory profileScreenFactory;

  const BottomNavigationController({
    Key? key,
    required this.mainScreenFactory,
    required this.mapScreenFactory,
    required this.bookmarksScreenFactory,
    required this.profileScreenFactory,
  }) : super(key: key);

  @override
  _BottomNavigationControllerState createState() =>
      _BottomNavigationControllerState();
}

class _BottomNavigationControllerState
    extends State<BottomNavigationController> {
  final pageController = PageController();
  List<BottomNaigationControllerItem>? _items;
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    if (_items == null) {
      final localizations = AppLocalizations.of(context)!;
      _items = [
        BottomNaigationControllerItem(
          widget.mainScreenFactory.createWidget(),
          BottomNavigationBarItem(
            label: localizations.main,
            icon: ImageIcon(
              AssetImage('assets/cherry/cherry.png'),
              key: Key('cherry icon'),
              size: 24,
            ),
          ),
        ),
        BottomNaigationControllerItem(
          widget.mapScreenFactory.createWidget(),
          BottomNavigationBarItem(
            label: localizations.map,
            icon: Icon(Icons.location_pin),
          ),
        ),
        BottomNaigationControllerItem(
          widget.bookmarksScreenFactory.createWidget(),
          BottomNavigationBarItem(
            label: localizations.bookmarks,
            icon: Icon(Icons.bookmark),
          ),
        ),
        BottomNaigationControllerItem(
          widget.profileScreenFactory.createWidget(),
          BottomNavigationBarItem(
            label: localizations.profile,
            icon: Icon(Icons.account_circle),
          ),
        )
      ];
    }

    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        children: _items!.map((e) => e.page).toList(),
        controller: pageController,
        onPageChanged: (index) => _currentPage = index,
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: _items!.map((e) => e.barItem).toList(),
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/main/index.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Localize strings
    return BlocBuilder<MainBloc, MainState>(
        builder: (context, state) => DefaultTabController(
              length: 2,
              child: Scaffold(
                  appBar: AppBar(
                      title: Image.asset('assets/main_app_bar_title.png',
                          height: 40),
                      bottom: TabBar(tabs: [
                        Tab(text: 'Лента'.toUpperCase()),
                        Tab(text: 'Рецепты'.toUpperCase()),
                      ])),
                  body: TabBarView(children: [
                    Center(child: Text('Главная')),
                    Center(child: Text('Рецепты'))
                  ])),
            ));
  }
}

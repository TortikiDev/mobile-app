import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:widget_factory/widget_factory.dart';

import '../../data/repositories/repositories.dart';
import 'bottom_navigation_controller.dart';

class BottomNavigationControllerFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    return Builder(
      builder: (context) {
        final db = Provider.of<Database>(context, listen: false);

        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider(create: (context) => JwtRepository()),
            RepositoryProvider(create: (context) => AccountRepository()),
            RepositoryProvider(create: (context) => PostsRepository()),
            RepositoryProvider(create: (context) => RecipesRepository()),
            RepositoryProvider(
              create: (context) => BookmarkedRecipesRepository(db: db),
            ),
          ],
          child: Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) {
                  return BottomNavigationController();
                },
              );
            },
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data/database/tortiki_db_factory.dart';
import 'data/http_client/tortiki_http_client_factory.dart';
import 'ui/app.dart';
import 'ui/bottom_navigation/bottom_navigation_controller_factory.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final httpClientFactory = TortikiHttpClientFactory();
  final dbFactory = TortikiDbFactory();
  final bottomNavigationControllerFactory = BottomNavigationControllerFactory();
  runApp(App(
    httpClientFactory: httpClientFactory,
    dbFactory: dbFactory,
    bottomNavigationControllerFactory: bottomNavigationControllerFactory,
  ));
}

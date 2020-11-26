import 'package:flutter/widgets.dart';

import '../../reusable/in_develop_screen_factory.dart';
import '../../reusable/widget_factory.dart';
import 'feed/feed_screen_factory.dart';
import 'main_screen.dart';

class MainScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    final feedScreenFactory = FeedScreenFactory();
    // TODO: use actual recipes screen factory instead
    final recipesScreenFactory = InDevelopWidgetFactory();
    return MainScreen(
        feedScreenFactory: feedScreenFactory,
        recipesScreenFactory: recipesScreenFactory);
  }
}

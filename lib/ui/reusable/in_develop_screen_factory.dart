import 'package:flutter/material.dart';

import 'widget_factory.dart';

class InDevelopWidgetFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) => Container(
        child: Center(
          child: Text('В разработке... 👨‍💻'),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:widget_factory/widget_factory.dart';

class InDevelopWidgetFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) => Container(
        child: Center(
          child: Text('В разработке... 👨‍💻'),
        ),
      );
}

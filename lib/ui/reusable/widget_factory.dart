import 'package:flutter/widgets.dart';

// ignore: one_member_abstracts
abstract class WidgetFactory<TWidgetData> {
  Widget createWidget({TWidgetData data});
}

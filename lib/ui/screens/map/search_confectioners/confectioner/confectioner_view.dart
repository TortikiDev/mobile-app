import 'package:flutter/material.dart';

import 'confectioner_view_model.dart';

class ConfectionerView extends StatelessWidget {
  final ConfectionerViewModel model;
  final ThemeData theme;
  final Function(ConfectionerViewModel) showDetails;

  const ConfectionerView({
    Key key,
    @required this.model,
    @required this.theme,
    this.showDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: Colors.amber,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          height: 1,
          color: Colors.grey,
        ),
      ),
    );
  }
}

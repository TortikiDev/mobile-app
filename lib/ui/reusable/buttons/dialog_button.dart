import 'package:flutter/material.dart';

class DialogButton extends StatelessWidget {
  final String title;
  final GestureTapCallback onPressed;

  const DialogButton({@required this.title, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: Text(title,
          style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Theme.of(context).accentColor,
              fontSize: 14)),
    );
  }
}

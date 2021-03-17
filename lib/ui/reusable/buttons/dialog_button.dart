import 'package:flutter/material.dart';

class DialogButton extends StatelessWidget {
  final String title;
  final GestureTapCallback onPressed;

  const DialogButton({@required this.title, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        title,
        style: Theme.of(context).textTheme.button,
      ),
    );
  }
}

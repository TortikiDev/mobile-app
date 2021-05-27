import 'package:flutter/material.dart';

class Disclosure extends StatelessWidget {
  final String title;
  final double height;

  const Disclosure({
    Key key,
    @required this.title,
    this.height = 56,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: height,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Row(
          children: [
            Expanded(child: Text(title, style: theme.textTheme.subtitle1)),
            SizedBox(width: 8),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final double strokeWidth;

  const LoadingIndicator({
    Key key,
    this.strokeWidth = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CircularProgressIndicator(
      color: theme.accentColor,
      strokeWidth: strokeWidth,
    );
  }
}

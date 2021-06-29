import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;

  const PrimaryButton({
    Key? key,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MaterialButton(
      onPressed: onPressed,
      child: Text(text.toUpperCase()),
      color: theme.colorScheme.primary,
      textColor: theme.colorScheme.onPrimary,
      height: 36,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    );
  }
}

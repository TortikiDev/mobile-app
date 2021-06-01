import 'package:flutter/material.dart';

class ProfileField extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;

  const ProfileField({
    Key key,
    @required this.title,
    @required this.value,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        color: Colors.transparent,
        child: Column(
          children: [
            SizedBox(height: 1),
            Expanded(
              child: Row(
                children: [
                  SizedBox(width: 16),
                  Text(
                    title,
                    style: theme.textTheme.subtitle1,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      value,
                      style: theme.textTheme.subtitle1
                          .copyWith(color: theme.colorScheme.onPrimary),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  SizedBox(width: 24),
                ],
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}

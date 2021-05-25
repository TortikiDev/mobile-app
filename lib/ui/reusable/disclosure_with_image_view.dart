import 'package:flutter/material.dart';

import 'image_views/circlar_avatar.dart';

class DisclosureWithAvatar extends StatelessWidget {
  final String imageUrl;
  final bool male;
  final String title;
  final double height;
  final VoidCallback onTap;

  const DisclosureWithAvatar({
    Key key,
    @required this.title,
    this.imageUrl,
    this.male = false,
    this.height = 56,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
          child: Row(
            children: [
              CirclarAvatar(
                radius: 20,
                url: imageUrl,
                male: male,
              ),
              SizedBox(width: 16),
              Expanded(child: Text(title, style: theme.textTheme.subtitle1)),
              SizedBox(width: 8),
              Icon(Icons.chevron_right, color: Colors.grey),
              SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}

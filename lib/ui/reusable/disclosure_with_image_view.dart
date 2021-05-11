import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../utils/string_is_valid_url.dart';

class DisclosureWithImageView extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double height;
  final VoidCallback onTap;

  const DisclosureWithImageView({
    Key key,
    @required this.title,
    this.imageUrl,
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
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                child: imageUrl?.isValidUrl() ?? false
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        imageBuilder: (context, imageProvider) {
                          return CircleAvatar(
                              radius: 19.5,
                              backgroundColor: Colors.transparent,
                              backgroundImage: imageProvider);
                        },
                        fit: BoxFit.cover,
                      )
                    : null,
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

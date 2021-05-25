import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../utils/string_is_valid_url.dart';
import 'avatar_size.dart';

class CirclarAvatar extends StatelessWidget {
  final String url;
  final double radius;
  final bool male;
  final AvatarSize placeholderSize;

  const CirclarAvatar({
    Key key,
    @required this.url,
    @required this.radius,
    this.male = false,
    this.placeholderSize = AvatarSize.small,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isValidUrl = url?.isValidUrl() ?? false;

    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[300],
      child: isValidUrl
          ? CachedNetworkImage(
              imageUrl: url,
              imageBuilder: (context, imageProvider) {
                return CircleAvatar(
                  radius: radius - 0.5,
                  backgroundColor: Colors.transparent,
                  backgroundImage: imageProvider,
                );
              },
              fit: BoxFit.cover,
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                getPlaceholderAssetName(
                  size: placeholderSize,
                  male: male,
                ),
              ),
            ),
    );
  }
}

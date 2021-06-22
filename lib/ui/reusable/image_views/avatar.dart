import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../utils/string_is_valid_url.dart';
import 'avatar_size.dart';

class Avatar extends StatelessWidget {
  final String? url;
  final double cornerRadius;
  final bool male;
  final AvatarSize placeholderSize;
  final EdgeInsets placeholderPadding;

  const Avatar({
    Key? key,
    required this.url,
    this.cornerRadius = 0.0,
    this.male = false,
    this.placeholderSize = AvatarSize.small,
    this.placeholderPadding = const EdgeInsets.all(8.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final validUrl = url?.isValidUrl() ?? false;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(cornerRadius)),
        color: Colors.grey[300],
      ),
      clipBehavior: Clip.hardEdge,
      child: validUrl
          ? CachedNetworkImage(
              imageUrl: url!,
              fit: BoxFit.cover,
            )
          : Padding(
              padding: placeholderPadding,
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

import 'package:flutter/material.dart';

enum AvatarSize { small, large }

String getPlaceholderAssetName({
  @required AvatarSize size,
  @required bool male,
}) {
  String sizeSuffix;
  switch (size) {
    case AvatarSize.small:
      sizeSuffix = 's';
      break;
    case AvatarSize.large:
      sizeSuffix = 'l';
  }

  if (male) {
    return 'assets/boy_$sizeSuffix';
  } else {
    return 'assets/girl_$sizeSuffix';
  }
}

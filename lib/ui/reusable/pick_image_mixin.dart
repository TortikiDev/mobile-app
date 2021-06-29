import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

mixin PickImageMixin {
  void pickImage({
    required BuildContext context,
    required ImagePicker imagePicker,
    required Function(File?) completion,
  }) async {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      builder: (dialogContext) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading:
                        Icon(Icons.photo_library, color: theme.accentColor),
                    title: Text(localizations.photoLibrary,
                        style: theme.textTheme.bodyText1),
                    onTap: () async {
                      Navigator.of(context).pop();
                      final result =
                          await _pickImageFromGallery(context, imagePicker);
                      completion(result);
                    }),
                ListTile(
                  leading: Icon(Icons.photo_camera, color: theme.accentColor),
                  title: Text(localizations.camera,
                      style: theme.textTheme.bodyText1),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final result =
                        await _pickImageFromCamera(context, imagePicker);
                    completion(result);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<File?> _pickImageFromCamera(
      BuildContext context, ImagePicker imagePicker) async {
    final image = await imagePicker.getImage(
        source: ImageSource.camera, imageQuality: 50);
    return (image != null) ? File(image.path) : null;
  }

  Future<File?> _pickImageFromGallery(
      BuildContext context, ImagePicker imagePicker) async {
    final image = await imagePicker.getImage(
        source: ImageSource.gallery, imageQuality: 50);
    return (image != null) ? File(image.path) : null;
  }
}

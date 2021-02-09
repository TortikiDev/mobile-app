import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app_localizations.dart';
import '../../../../bloc/create_post/index.dart';

class CreatePostScreen extends StatelessWidget {
  final ImagePicker imagePicker;

  const CreatePostScreen({Key key, @required this.imagePicker})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return BlocConsumer<CreatePostBloc, CreatePostState>(
      listenWhen: (previous, current) => current.postSuccessfulyCreated,
      listener: (context, state) => Navigator.of(context).pop(),
      builder: (context, state) => Scaffold(
        appBar: AppBar(
            title:
                Text(localizations.newPost, style: theme.textTheme.headline6),
            actions: state.creatingPost
                ? [
                    Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Center(
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 3),
                        ),
                      ),
                    )
                  ]
                : [
                    IconButton(
                      icon: Icon(Icons.send),
                      tooltip: localizations.newPost,
                      onPressed: state.canCreatePost
                          ? () => _createPost(context)
                          : null,
                    ),
                  ]),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 16.0, right: 16.0, left: 16.0, bottom: 32.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(localizations.photo, style: theme.textTheme.subtitle1),
                    SizedBox(height: 16),
                    AspectRatio(
                        aspectRatio: 1,
                        child: _getPhotoWidget(context, photo: state.photo)),
                    SizedBox(height: 24),
                    Text(localizations.description,
                        style: theme.textTheme.subtitle1),
                    SizedBox(height: 16),
                    TextField(
                        maxLength: 500,
                        maxLines: null,
                        onChanged: (value) =>
                            _descriptionChanged(context, value))
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  void _createPost(BuildContext context) {
    final event = CreatePost();
    BlocProvider.of<CreatePostBloc>(context).add(event);
  }

  void _descriptionChanged(BuildContext context, String text) {
    final event = DescriptionChanged(text);
    BlocProvider.of<CreatePostBloc>(context).add(event);
  }

  Widget _getPhotoWidget(BuildContext context, {File photo}) {
    Widget photoWidget;
    if (photo != null) {
      photoWidget = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 0.5, color: Colors.grey[400]),
        ),
        clipBehavior: Clip.hardEdge,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(photo, fit: BoxFit.cover),
        ),
      );
    } else {
      photoWidget = Image.asset('assets/add_photo.png', fit: BoxFit.cover);
    }
    return GestureDetector(
      child: photoWidget,
      onTap: () => _showImagePicker(context),
    );
  }

  void _showImagePicker(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

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
                      onTap: () {
                        _pickImageFromGallery(context);
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera, color: theme.accentColor),
                    title: Text(localizations.camera,
                        style: theme.textTheme.bodyText1),
                    onTap: () {
                      _pickImageFromCamera(context);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _pickImageFromCamera(BuildContext context) async {
    final image = await imagePicker.getImage(
        source: ImageSource.camera, imageQuality: 50);
    if (image != null) {
      final imageFile = File(image.path);
      BlocProvider.of<CreatePostBloc>(context).add(PhotoPicked(imageFile));
    }
  }

  Future<void> _pickImageFromGallery(BuildContext context) async {
    final image = await imagePicker.getImage(
        source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      final imageFile = File(image.path);
      BlocProvider.of<CreatePostBloc>(context).add(PhotoPicked(imageFile));
    }
  }
}

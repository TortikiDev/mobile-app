import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_localizations.dart';
import '../../../../bloc/create_post/index.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return BlocBuilder<CreatePostBloc, CreatePostState>(
        builder: (context, state) => Scaffold(
            appBar: AppBar(
                title: Text(localizations.newPost,
                    style: theme.textTheme.headline6),
                actions: [
                  IconButton(
                    icon: Icon(Icons.send),
                    tooltip: localizations.newPost,
                    onPressed: () {},
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
                          Text(localizations.photo,
                              style: theme.textTheme.subtitle1),
                          SizedBox(height: 16),
                          AspectRatio(
                              aspectRatio: 1,
                              child:
                                  _getPhotoWidget(context, photo: state.photo)),
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
                ))));
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
              border: Border.all(width: 0.5, color: Colors.grey[300])),
          child: Image.file(photo, fit: BoxFit.cover));
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
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading:
                          Icon(Icons.photo_library, color: theme.accentColor),
                      title: Text('Photo Library',
                          style: theme.textTheme.bodyText1),
                      onTap: () {
                        _pickImageFromGallery(context);
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera, color: theme.accentColor),
                    title: Text('Camera', style: theme.textTheme.bodyText1),
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
    final image = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50);
    final imageFile = File(image.path);
    BlocProvider.of<CreatePostBloc>(context).add(PhotoPicked(imageFile));
  }

  Future<void> _pickImageFromGallery(BuildContext context) async {
    final image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);
    final imageFile = File(image.path);
    BlocProvider.of<CreatePostBloc>(context).add(PhotoPicked(imageFile));
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app_localizations.dart';
import '../../../../../bloc/feed/index.dart';
import 'post_view_model.dart';

class PostView extends StatefulWidget {
  final PostViewModel model;
  final ThemeData theme;
  final AppLocalizations localizations;

  PostView(
      {Key key,
      @required this.model,
      @required this.theme,
      @required this.localizations})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _PostViewState(model: model, theme: theme, localizations: localizations);
}

class _PostViewState extends State<PostView> {
  final PostViewModel model;
  final ThemeData theme;
  final AppLocalizations localizations;

  TapGestureRecognizer _moreTapGestureRecognizer;

  _PostViewState(
      {@required this.model,
      @required this.theme,
      @required this.localizations});

  @override
  void initState() {
    super.initState();
    _moreTapGestureRecognizer = TapGestureRecognizer()
      ..onTap = _expandDesccription;
  }

  @override
  void dispose() {
    _moreTapGestureRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[300],
                  child: CircleAvatar(
                    radius: 19.5,
                    backgroundColor: Colors.transparent,
                    backgroundImage: (model.userAvaratUrl?.isEmpty ?? true)
                        ? null
                        : NetworkImage(model.userAvaratUrl),
                  )),
            ),
            Expanded(
                child: Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child:
                        Text(model.userName, style: theme.textTheme.subtitle1)))
          ],
        ),
        AspectRatio(
            aspectRatio: 1,
            child: Container(
                color: Colors.grey[300],
                child: Padding(
                  padding: EdgeInsets.only(top: 0.5, bottom: 0.5),
                  child: (model.imageUrl?.isEmpty ?? true)
                      ? null
                      : Image.network(model.imageUrl, fit: BoxFit.cover),
                ))),
        Padding(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: RichText(
                maxLines: model.descriptionExpanded ? null : 2,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(children: [
                  TextSpan(
                      text: model.description,
                      style: theme.textTheme.bodyText2),
                  TextSpan(
                      text: localizations.more,
                      style: theme.textTheme.bodyText2
                          .copyWith(color: theme.colorScheme.onSurface),
                      recognizer: _moreTapGestureRecognizer),
                ]))),
        Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Row(
            children: [
              IconButton(
                  icon: Icon(
                      model.liked ? Icons.favorite : Icons.favorite_border,
                      color: model.liked
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.secondaryVariant),
                  onPressed: _likePressed),
              Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Text(model.likes.toString(),
                      style: theme.textTheme.caption)),
              IconButton(
                  icon: Icon(Icons.share,
                      color: theme.colorScheme.secondaryVariant),
                  onPressed: _sharePressed)
            ],
          ),
        ),
      ],
    );
  }

  void _likePressed() {
    BlocProvider.of<FeedBloc>(context).add(Like(model.id));
  }

  void _sharePressed() {
    // TODO: implement sharing
    print('share');
  }

  void _expandDesccription() {
    BlocProvider.of<FeedBloc>(context).add(ExpandDesccription(model.id));
  }
}

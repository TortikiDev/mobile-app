import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:share/share.dart';

import '../../../../../app_localizations.dart';
import '../../../../../bloc/feed/index.dart';
import '../../../../../utils/string_is_valid_url.dart';
import '../../../../reusable/text/expandable_text.dart';
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

  _PostViewState(
      {@required this.model,
      @required this.theme,
      @required this.localizations});

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
                    child: model.userAvaratUrl?.isValidUrl() ?? false
                        ? CachedNetworkImage(
                            imageUrl: model.userAvaratUrl,
                            imageBuilder: (context, imageProvider) {
                              return CircleAvatar(
                                  radius: 19.5,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: imageProvider);
                            },
                            fit: BoxFit.cover)
                        : null)),
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
                  child: model.imageUrl?.isValidUrl() ?? false
                      ? PinchZoom(
                          maxScale: 1.2,
                          zoomedBackgroundColor: Colors.black.withOpacity(0.1),
                          image: CachedNetworkImage(
                              imageUrl: model.imageUrl, fit: BoxFit.cover))
                      : null,
                ))),
        Padding(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: ExpandableText(model.description,
                readMoreText: localizations.more,
                readLessText: localizations.showLess,
                theme: theme,
                onExpand: _expandDescription,
                initialExpandedValue: model.descriptionExpanded)),
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
    final event = model.liked ? Unlike(model.id) : Like(model.id);
    BlocProvider.of<FeedBloc>(context).add(event);
  }

  void _sharePressed() {
    // TODO: specify actual base url
    final baseUrl = 'https://tortiki.ru';
    final postUrl = '$baseUrl/post/${model.id}';
    Share.share(postUrl);
  }

  void _expandDescription(bool isExpanded) {
    final event = isExpanded
        ? ExpandDescription(model.id)
        : CollapseDescription(model.id);
    BlocProvider.of<FeedBloc>(context).add(event);
  }
}

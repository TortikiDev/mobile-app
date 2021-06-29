import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:share/share.dart';

import '../../../../../data/http_client/responses/responses.dart';
import '../../../../../utils/string_is_valid_url.dart';
import '../../../../reusable/image_views/circlar_avatar.dart';
import '../../../../reusable/text/expandable_text.dart';
import 'post_view_model.dart';

class PostView extends StatefulWidget {
  final PostViewModel model;
  final Function(PostViewModel) onAuthorTap;
  final Function(PostViewModel) onLike;
  final Function({
    required PostViewModel model,
    required bool isExpanded,
  }) onExpandDescription;
  final ThemeData theme;
  final AppLocalizations localizations;

  PostView(
      {Key? key,
      required this.model,
      required this.onAuthorTap,
      required this.onLike,
      required this.onExpandDescription,
      required this.theme,
      required this.localizations})
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
      {required this.model, required this.theme, required this.localizations});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => widget.onAuthorTap(model),
          child: Container(
            color: Colors.transparent,
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CirclarAvatar(
                    radius: 20,
                    url: model.userAvaratUrl,
                    male: model.userGender == Gender.male,
                  ),
                ),
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: Text(model.userName,
                            style: theme.textTheme.subtitle1)))
              ],
            ),
          ),
        ),
        Container(
          color: Colors.grey[300],
          child: Padding(
            padding: EdgeInsets.only(top: 0.5, bottom: 0.5),
            child: model.imageUrl.isValidUrl()
                // TODO: check if zoom clips image or not
                ? PinchZoomImage(
                    zoomedBackgroundColor: Colors.black.withOpacity(0.1),
                    image: AspectRatio(
                      aspectRatio: 1,
                      child: CachedNetworkImage(
                        imageUrl: model.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : null,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: ExpandableText(model.description,
              readMoreText: localizations.more,
              readLessText: localizations.showLess,
              theme: theme,
              onExpand: (expanded) => widget.onExpandDescription(
                  model: model, isExpanded: expanded),
              initialExpandedValue: model.descriptionExpanded),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Row(
            children: [
              IconButton(
                icon: Icon(model.liked ? Icons.favorite : Icons.favorite_border,
                    color: model.liked
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.secondaryVariant),
                onPressed: () => widget.onLike(model),
              ),
              SizedBox(
                width: 28,
                child: Text(
                  model.likes.toString(),
                  style: theme.textTheme.caption,
                ),
              ),
              SizedBox(width: 4),
              IconButton(
                icon: Icon(Icons.share,
                    color: theme.colorScheme.secondaryVariant),
                onPressed: _sharePressed,
              )
            ],
          ),
        ),
      ],
    );
  }

  void _sharePressed() {
    // TODO: specify actual base url
    final baseUrl = 'https://tortiki.ru';
    final postUrl = '$baseUrl/post/${model.id}';
    Share.share(postUrl);
  }
}

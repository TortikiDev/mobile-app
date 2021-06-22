import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../../../data/http_client/responses/confectioner/rating_star_type.dart';
import '../../../../../data/http_client/responses/responses.dart';
import '../../../../../utils/get_rating_star_color.dart';
import '../../../../reusable/image_views/avatar.dart';
import 'confectioner_view_model.dart';

class ConfectionerView extends StatelessWidget {
  final ConfectionerViewModel model;
  final ThemeData theme;
  final Function(ConfectionerViewModel)? showDetails;

  const ConfectionerView({
    Key? key,
    required this.model,
    required this.theme,
    this.showDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDetails?.call(model),
      child: Container(
        height: 88,
        color: Colors.transparent,
        child: Stack(
          children: [
            Container(
              height: 164,
              padding: EdgeInsets.fromLTRB(8, 8, 8, 12),
              child: Row(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.grey[300],
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Avatar(
                        url: model.avatarUrl,
                        male: model.gender == Gender.male,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 2),
                        AutoSizeText(
                          model.name,
                          style: theme.textTheme.subtitle1,
                          maxLines: 1,
                          minFontSize: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          model.address,
                          style: theme.textTheme.caption
                              ?.copyWith(color: theme.colorScheme.onSurface),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (model.starType !=
                                ConfectionerRatingStarType.none)
                              Padding(
                                padding: EdgeInsets.only(right: 2),
                                child: Icon(
                                  Icons.star,
                                  size: 20,
                                  color: getRatignStarColor(model.starType),
                                ),
                              ),
                            Padding(
                              padding: EdgeInsets.only(left: 4, top: 2),
                              child: Text(
                                model.rating.toString(),
                                style: theme.textTheme.subtitle2?.copyWith(
                                    color: theme.colorScheme.onPrimary),
                                maxLines: 1,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Divider(),
            ),
          ],
        ),
      ),
    );
  }
}

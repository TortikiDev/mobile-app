import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:map_launcher/map_launcher.dart';

import '../../../data/http_client/responses/responses.dart';
import '../../../utils/get_rating_star_color.dart';
import '../../reusable/buttons/secondary_button.dart';

class ConfectionerPanel extends StatelessWidget {
  final ConfectionerShortResponse confectioner;
  const ConfectionerPanel({
    Key key,
    @required this.confectioner,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return Container(
      height: 164,
      padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 0),
            blurRadius: 6,
          )
        ],
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              width: 24,
              height: 4,
              color: Colors.black12,
            ),
          ),
          SizedBox(height: 8),
          Expanded(
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
                    child: CachedNetworkImage(
                      // TODO: add placeholder 
                      // depends on gender (boy or girl icon)
                      imageUrl: confectioner.avatarUrl,
                      fit: BoxFit.cover,
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
                        confectioner.name,
                        style: theme.textTheme.subtitle1,
                        maxLines: 1,
                        minFontSize: 10,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        confectioner.address,
                        style: theme.textTheme.caption
                            .copyWith(color: theme.colorScheme.onSurface),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (confectioner.starType !=
                              ConfectionerRatingStarType.none)
                            Padding(
                              padding: EdgeInsets.only(right: 2),
                              child: Icon(
                                Icons.star,
                                size: 20,
                                color:
                                    getRatignStarColor(confectioner.starType),
                              ),
                            ),
                          Padding(
                            padding: EdgeInsets.only(left: 4, top: 2),
                            child: Text(
                              confectioner.rating.toString(),
                              style: theme.textTheme.subtitle2
                                  .copyWith(color: theme.colorScheme.onPrimary),
                              maxLines: 1,
                            ),
                          )
                        ],
                      ),
                      Spacer(),
                      SizedBox(
                        height: 24,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: SecondaryButton(
                                text: localizations.profile,
                                onPressed: () => _goToProfile(context),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: SecondaryButton(
                                text: localizations.route,
                                onPressed: () => _showDirections(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _goToProfile(BuildContext context) {
    // TODO: implement _goToProfile
  }

  Future<void> _showDirections(BuildContext context) async {
    final coords = Coords(
      confectioner.coordinate.lat,
      confectioner.coordinate.long,
    );
    final title = confectioner.name;
    final availableMaps = await MapLauncher.installedMaps;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  for (final map in availableMaps)
                    ListTile(
                      onTap: () {
                        Navigator.of(context).pop();
                        map.showDirections(
                          destination: coords,
                          destinationTitle: title,
                        );
                      },
                      title: Text(map.mapName),
                      leading: SvgPicture.asset(
                        map.icon,
                        height: 30.0,
                        width: 30.0,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

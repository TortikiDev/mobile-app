import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../bloc/external_confectioner_profile/index.dart';
import '../../../../data/http_client/responses/responses.dart';
import '../../../../utils/get_rating_star_color.dart';
import '../../../../utils/string_is_valid_url.dart';
import '../../../reusable/app_version_logo.dart';
import '../../../reusable/disclosure.dart';

class ExternalConfectionerProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return BlocBuilder<ExternalConfectionerProfileBloc,
        ExternalConfectionerProfileState>(builder: (context, state) {
      final confectioner = state.confectioner;

      return Scaffold(
        appBar: AppBar(title: Text(confectioner.name)),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverAppBar(
              expandedHeight: 270,
              backgroundColor: Colors.transparent,
              toolbarHeight: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: confectioner.avatarUrl?.isValidUrl() ?? false
                    ? CachedNetworkImage(
                        imageUrl: confectioner.avatarUrl,
                        fit: BoxFit.cover,
                      )
                    // TODO: use boy or girls avatar placeholder
                    : Container(color: Colors.grey[300]),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            SizedBox(height: 24),
                            Row(children: [
                              Text(
                                confectioner.name,
                                style: theme.textTheme.bodyText1,
                              ),
                              SizedBox(width: 16),
                              Spacer(),
                              if (confectioner.starType !=
                                  ConfectionerRatingStarType.none)
                                Padding(
                                  padding: EdgeInsets.only(right: 2),
                                  child: Icon(
                                    Icons.star,
                                    size: 20,
                                    color: getRatignStarColor(
                                        confectioner.starType),
                                  ),
                                ),
                              Padding(
                                padding: EdgeInsets.only(left: 4, top: 2),
                                child: Text(
                                  confectioner.rating.toString(),
                                  style: theme.textTheme.subtitle1.copyWith(
                                      color: theme.colorScheme.onPrimary),
                                  maxLines: 1,
                                ),
                              )
                            ]),
                            SizedBox(height: 8),
                            Row(children: [
                              Icon(
                                Icons.location_pin,
                                color: theme.colorScheme.primaryVariant,
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Text(
                                confectioner.address,
                                style: theme.textTheme.bodyText2.copyWith(
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ]),
                            SizedBox(height: 24),
                            Text(
                              confectioner.about,
                              style: theme.textTheme.subtitle1,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      Divider(),
                      Disclosure(title: localizations.publications),
                      Divider(),
                      Disclosure(title: localizations.recipes),
                      Divider(),
                      SizedBox(height: 48),
                      AppVersionLogo(),
                      SizedBox(height: 32),
                    ],
                  );
                },
                childCount: 1,
              ),
            )
          ],
        ),
      );
    });
  }
}

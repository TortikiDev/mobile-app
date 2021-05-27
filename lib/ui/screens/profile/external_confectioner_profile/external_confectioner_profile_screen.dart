import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:widget_factory/widget_factory.dart';

import '../../../../bloc/external_confectioner_profile/index.dart';
import '../../../../data/http_client/responses/responses.dart';
import '../../../../utils/get_rating_star_color.dart';
import '../../../reusable/content_shimmer.dart';
import '../../../reusable/disclosure.dart';
import '../../../reusable/image_views/avatar.dart';
import '../../../reusable/image_views/avatar_size.dart';
import '../user_posts/user_posts_factory.dart';
import '../user_recipes.dart/user_recipes_screen_factory.dart';

class ExternalConfectionerProfileScreen extends StatelessWidget {
  final WidgetFactory userPostsScreenFacory;
  final WidgetFactory userRecipesScreenFacory;

  const ExternalConfectionerProfileScreen({
    Key key,
    @required this.userPostsScreenFacory,
    @required this.userRecipesScreenFacory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return BlocBuilder<ExternalConfectionerProfileBloc,
        ExternalConfectionerProfileState>(builder: (context, state) {
      final confectioner = state.confectioner ??
          ConfectionerResponse(
            id: null,
            name: '',
            address: '',
            about: '',
            avatarUrl: null,
            gender: Gender.none,
            starType: ConfectionerRatingStarType.none,
            rating: 0,
            coordinate: null,
          );

      return Scaffold(
        appBar: AppBar(title: Text(state.confectionerName)),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverAppBar(
              expandedHeight: 270,
              backgroundColor: Colors.transparent,
              stretch: true,
              toolbarHeight: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Avatar(
                  url: confectioner.avatarUrl,
                  male: state.confectionerGender == Gender.male,
                  placeholderSize: AvatarSize.large,
                  placeholderPadding: const EdgeInsets.all(32),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return state.loading
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 28),
                              SizedBox(
                                height: 16,
                                child: ContentShimmer(),
                              ),
                              SizedBox(height: 12),
                              SizedBox(
                                height: 16,
                                width: 200,
                                child: ContentShimmer(),
                              ),
                              SizedBox(height: 32),
                              SizedBox(
                                height: 80,
                                child: ContentShimmer(),
                              ),
                            ],
                          ),
                        )
                      : Column(
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
                                        style: theme.textTheme.subtitle1
                                            .copyWith(
                                                color: theme
                                                    .colorScheme.onPrimary),
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
                            GestureDetector(
                              onTap: () => _goToPublications(context,
                                  confectionerId: state.confectionerId),
                              child:
                                  Disclosure(title: localizations.publications),
                            ),
                            Divider(),
                            GestureDetector(
                              onTap: () => _goToRecipes(context,
                                  confectionerId: state.confectionerId),
                              child: Disclosure(title: localizations.recipes),
                            ),
                            Divider(),
                            SizedBox(height: 48),
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

  void _goToPublications(BuildContext context, {@required int confectionerId}) {
    final data =
        UserPostsScreenFactoryData(isMyPosts: false, userId: confectionerId);
    final screen = userPostsScreenFacory.createWidget(data: data);
    final route = MaterialPageRoute(builder: (context) => screen);
    Navigator.of(context).push(route);
  }

  void _goToRecipes(BuildContext context, {@required int confectionerId}) {
    final data = UserRecipesScreenFactoryData(
        isMyRecipes: false, userId: confectionerId);
    final screen = userRecipesScreenFacory.createWidget(data: data);
    final route = MaterialPageRoute(builder: (context) => screen);
    Navigator.of(context).push(route);
  }
}

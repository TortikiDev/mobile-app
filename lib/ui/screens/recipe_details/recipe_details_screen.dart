import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:widget_factory/widget_factory.dart';

import '../../../bloc/recipe_details/index.dart';
import '../../reusable/content_shimmer.dart';
import '../../reusable/images_collection.dart';
import '../profile/external_confectioner_profile/external_confectioner_profile_screen_factory.dart';
import 'recipe_header/recipe_header.dart';
import 'recipe_header/recipe_header_view_model.dart';
import 'vote_widget.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final WidgetFactory confectionerProfileScreenFactory;

  const RecipeDetailsScreen({
    Key key,
    @required this.confectionerProfileScreenFactory,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen>
    with TickerProviderStateMixin {
  final scrollController = ScrollController();
  bool statusBarBackgroundIsVisible = true;

  @override
  void initState() {
    scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<RecipeDetailsBloc, RecipeDetailsState>(
            builder: (context, state) => CustomScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              controller: scrollController,
              slivers: [
                SliverAppBar(
                  expandedHeight: 270,
                  stretch: true,
                  pinned: true,
                  toolbarHeight: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background:
                        ImagesCollection(urls: state.recipe?.imageUrls ?? []),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Column(
                        children: [
                          RecipeHeader(
                            model: state.headerViewModel,
                            addToBookmarks: (model) =>
                                _addRecipeToBookmarks(model, context),
                            showAuthorProfile: (model) =>
                                _showAuthorProfile(model, context),
                          ),
                          if (!state.loading)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 24),
                                  Text(
                                    localizations.description,
                                    style: theme.textTheme.headline5,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    state.recipe.description ?? '',
                                    style: theme.textTheme.bodyText2,
                                  ),
                                  SizedBox(height: 24),
                                  Text(
                                    localizations.ingredients,
                                    style: theme.textTheme.headline5,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    // ignore: lines_longer_than_80_chars
                                    ' •  ${state.recipe.ingredients.join('\n •  ')}',
                                    style: theme.textTheme.bodyText2,
                                  ),
                                  SizedBox(height: 24),
                                  Text(
                                    localizations.cooking,
                                    style: theme.textTheme.headline5,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    state.recipe.cookingSteps ?? '',
                                    style: theme.textTheme.bodyText2,
                                  ),
                                ],
                              ),
                            ),
                          if (state.loading)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 24),
                                  SizedBox(
                                    height: 24,
                                    child: ContentShimmer(),
                                  ),
                                  SizedBox(height: 16),
                                  SizedBox(
                                    height: 192,
                                    child: ContentShimmer(),
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(height: 8),
                          if (!state.loading)
                            VoteWidget(
                              voteResult: state.recipe.myVote,
                              vsync: this,
                            ),
                          SizedBox(height: 32),
                        ],
                      );
                    },
                    childCount: 1,
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 16,
            child: SafeArea(
              child: GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 28,
                    height: 28,
                    color: Colors.black54,
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: statusBarBackgroundIsVisible,
            child: Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                // TODO: check bg height on android devices
                height: 44,
                color: Colors.white30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addRecipeToBookmarks(
      RecipeHeaderViewModel model, BuildContext context) {
    final event = Bookmarks(model);
    final bloc = BlocProvider.of<RecipeDetailsBloc>(context);
    bloc.add(event);
  }

  void _showAuthorProfile(RecipeHeaderViewModel model, BuildContext context) {
    final screenData = ExternalConfectionerProfileScreenFactoryData(
      confectionerId: model.authorId,
      confectionerName: model.authorName,
    );
    final screen =
        widget.confectionerProfileScreenFactory.createWidget(data: screenData);
    final route = MaterialPageRoute(builder: (context) => screen);
    Navigator.of(context).push(route);
  }

  void _onScroll() {
    final showStatusBarBackground = scrollController.offset < 270;
    if (statusBarBackgroundIsVisible != showStatusBarBackground) {
      setState(() {
        statusBarBackgroundIsVisible = showStatusBarBackground;
      });
    }
  }
}

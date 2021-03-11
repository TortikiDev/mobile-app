import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_localizations.dart';
import '../../../bloc/recipe_details/index.dart';
import '../../reusable/images_collection.dart';
import 'recipe_header/recipe_header.dart';
import 'recipe_header/recipe_header_view_model.dart';

class RecipeDetailsScreen extends StatefulWidget {
  const RecipeDetailsScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
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
              physics: BouncingScrollPhysics(),
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

  void _onScroll() {
    final showStatusBarBackground = scrollController.offset < 270;
    if (statusBarBackgroundIsVisible != showStatusBarBackground) {
      setState(() {
        statusBarBackgroundIsVisible = showStatusBarBackground;
      });
    }
  }
}

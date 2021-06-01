import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:widget_factory/widget_factory.dart';

import '../../../../bloc/user_recipes/index.dart';
import '../../../reusable/list_items/progress_indicator_item.dart';
import '../../../reusable/loading_indicator.dart';
import '../../main/recipes/recipe/recipe_view.dart';
import '../../main/recipes/recipe/recipe_view_model.dart';
import '../../recipe_details/recipe_details_screen_factory.dart';

class UserRecipesScreen extends StatelessWidget {
  final WidgetFactory recipeDetailsScreenFactory;

  const UserRecipesScreen({@required this.recipeDetailsScreenFactory});

  @override
  Widget build(BuildContext context) {
    final localizaitons = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizaitons.recipes)),
      body: BlocBuilder<UserRecipesBloc, UserRecipesState>(
          builder: (context, state) {
        return state.loadingFirstPage
            ? Center(
                child:
                    SizedBox(width: 32, height: 32, child: LoadingIndicator()))
            : _ScrollView(
                state: state,
                recipeDetailsScreenFactory: recipeDetailsScreenFactory,
              );
      }),
    );
  }
}

class _ScrollView extends StatelessWidget {
  final WidgetFactory recipeDetailsScreenFactory;
  final UserRecipesState state;

  const _ScrollView({
    Key key,
    @required this.state,
    @required this.recipeDetailsScreenFactory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scrollbar(
      child: RefreshIndicator(
        color: theme.accentColor,
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: 8),
          itemCount: state.listItems.length,
          itemBuilder: (context, index) {
            final model = state.listItems[index];
            if (model is RecipeViewModel) {
              if ((index == state.listItems.length - 1) &&
                  !state.loadingNextPage) {
                BlocProvider.of<UserRecipesBloc>(context).add(LoadNextPage());
              }
              return RecipeView(
                key: ObjectKey(model),
                model: model,
                theme: theme,
                addToBookmarks: (model) =>
                    _addRecipeToBookmarks(model, context),
                showDetails: (model) => _showRecipeDetails(model, context),
              );
            } else if (model is ProgressIndicatorItem) {
              return SizedBox(
                height: 64,
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: LoadingIndicator(),
                  ),
                ),
              );
            } else {
              throw UnimplementedError('Type [${model.runtimeType}] is not'
                  ' implemented for list view builder');
            }
          },
        ),
        onRefresh: () => _pullToRefreshList(context),
      ),
    );
  }

  Future<void> _pullToRefreshList(BuildContext context) async {
    final completer = Completer();
    final feedBloc = BlocProvider.of<UserRecipesBloc>(context);
    feedBloc.add(PullToRefresh(completer.complete));
    return completer.future;
  }

  void _addRecipeToBookmarks(RecipeViewModel model, BuildContext context) {
    final event = Bookmarks(model);
    final bloc = BlocProvider.of<UserRecipesBloc>(context);
    bloc.add(event);
  }

  void _showRecipeDetails(RecipeViewModel model, BuildContext context) {
    final navigator = Navigator.of(context);
    final screenData = RecipeDetailsScreenFactoryData(
      id: model.id,
      title: model.title,
      complexity: model.complexity,
      imageUrls: model.imageUrls,
      isInBookmarks: model.isInBookmarks,
    );
    final route = MaterialPageRoute(
      builder: (_) => WillPopScope(
        child: recipeDetailsScreenFactory.createWidget(data: screenData),
        onWillPop: () async {
          final recipesBloc = BlocProvider.of<UserRecipesBloc>(context);
          recipesBloc.add(UpdateIsInBookmarks(model));
          return true;
        },
      ),
      fullscreenDialog: true,
    );
    navigator.push(route);
  }
}

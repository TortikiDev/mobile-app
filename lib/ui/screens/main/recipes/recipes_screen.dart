import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widget_factory/widget_factory.dart';

import '../../../../bloc/recipes/index.dart';
import '../../../reusable/list_items/progress_indicator_item.dart';
import '../../recipe_details/recipe_details_screen_factory.dart';
import 'recipe/recipe_view.dart';
import 'recipe/recipe_view_model.dart';

class RecipesScreen extends StatefulWidget {
  final WidgetFactory recipeDetailsScreenFactory;

  const RecipesScreen({Key key, @required this.recipeDetailsScreenFactory})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen>
    with AutomaticKeepAliveClientMixin<RecipesScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<RecipesBloc, RecipesState>(builder: (context, state) {
      return state.loadingFirstPage
          ? Center(
              child: SizedBox(
                  width: 32, height: 32, child: CircularProgressIndicator()))
          : _ScrollView(
              state: state,
              recipeDetailsScreenFactory: widget.recipeDetailsScreenFactory,
            );
    });
  }
}

class _ScrollView extends StatelessWidget {
  final WidgetFactory recipeDetailsScreenFactory;
  final RecipesState state;

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
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: 8),
          itemCount: state.listItems.length,
          itemBuilder: (context, index) {
            final model = state.listItems[index];
            if (model is RecipeViewModel) {
              if ((index == state.listItems.length - 1) &&
                  !state.loadingNextPage) {
                BlocProvider.of<RecipesBloc>(context).add(LoadNextPage());
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
                    child: CircularProgressIndicator(),
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
    final feedBloc = BlocProvider.of<RecipesBloc>(context);
    feedBloc.add(PullToRefresh(completer.complete));
    return completer.future;
  }

  void _addRecipeToBookmarks(RecipeViewModel model, BuildContext context) {
    final event = Bookmarks(model);
    final bloc = BlocProvider.of<RecipesBloc>(context);
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
          final recipesBloc = BlocProvider.of<RecipesBloc>(context);
          recipesBloc.add(UpdateIsInBookmarks(model));
          return true;
        },
      ),
      fullscreenDialog: true,
    );
    navigator.push(route);
  }
}

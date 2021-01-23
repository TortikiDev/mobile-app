import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/search_recipes/index.dart';
import '../../../reusable/list_items/progress_indicator_item.dart';
import '../../../reusable/search_bar.dart';
import '../recipes/recipe/recipe_view.dart';
import '../recipes/recipe/recipe_view_model.dart';

class SearchRecipesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchRecipesBloc, SearchRecipesState>(
      builder: (context, state) => Scaffold(
        body: Column(
          children: [
            SearchBar(),
            _ScrollView(state: state),
          ],
        ),
      ),
    );
  }
}

class _ScrollView extends StatelessWidget {
  final SearchRecipesState state;

  const _ScrollView({Key key, @required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scrollbar(
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 8),
        itemCount: state.listItems.length,
        itemBuilder: (context, index) {
          final model = state.listItems[index];
          if (model is RecipeViewModel) {
            if ((index == state.listItems.length - 1) &&
                !state.loadingNextPage) {
              BlocProvider.of<SearchRecipesBloc>(context).add(LoadNextPage());
            }
            return RecipeView(
              key: ObjectKey(model),
              model: model,
              theme: theme,
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/bookmarks/index.dart';
import '../main/recipes/recipe/recipe_view.dart';
import '../main/recipes/recipe/recipe_view_model.dart';

class BookmarksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarksBloc, BookmarksState>(
      builder: (context, state) {
        return state.loading
            ? Center(
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(),
                ),
              )
            : _ScrollView(state: state);
      },
    );
  }
}

class _ScrollView extends StatelessWidget {
  final BookmarksState state;

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
          return RecipeView(
            key: ObjectKey(model),
            model: model,
            theme: theme,
            addToBookmarks: (model) =>
                _removeRecipeFromBookmarks(model, context),
          );
        },
      ),
    );
  }

  void _removeRecipeFromBookmarks(RecipeViewModel model, BuildContext context) {
    final event = RemoveFromBookmarks(model);
    final bloc = BlocProvider.of<BookmarksBloc>(context);
    bloc.add(event);
  }
}

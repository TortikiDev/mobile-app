import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_localizations.dart';
import '../../../bloc/bookmarks/index.dart';
import '../main/recipes/recipe/recipe_view.dart';
import '../main/recipes/recipe/recipe_view_model.dart';

class BookmarksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.bookmarks)),
      body: BlocBuilder<BookmarksBloc, BookmarksState>(
        builder: (context, state) {
          return Stack(
            children: [
              Positioned(
                top: 80,
                left: 0,
                right: 0,
                child: Visibility(
                  visible: state.loading,
                  child: Center(
                    child: SizedBox(
                      height: 32,
                      width: 32,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
              Center(
                child: Image.asset('assets/logo_transparent.png'),
              ),
              _ScrollView(state: state),
            ],
          );
        },
      ),
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

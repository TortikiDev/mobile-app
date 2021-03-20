import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../bloc/bookmarks/index.dart';
import '../../../bloc/bottom_navigation_bloc/index.dart';
import '../../reusable/widget_factory.dart';
import '../main/recipes/recipe/recipe_view.dart';
import '../main/recipes/recipe/recipe_view_model.dart';
import '../recipe_details/recipe_details_screen_factory.dart';

class BookmarksScreen extends StatelessWidget {
  final WidgetFactory recipeDetailsScreenFactory;

  const BookmarksScreen({
    Key key,
    @required this.recipeDetailsScreenFactory,
  }) : super(key: key);

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
              _ScrollView(
                state: state,
                recipeDetailsScreenFactory: recipeDetailsScreenFactory,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ScrollView extends StatelessWidget {
  final WidgetFactory recipeDetailsScreenFactory;
  final BookmarksState state;

  const _ScrollView({
    Key key,
    @required this.state,
    @required this.recipeDetailsScreenFactory,
  }) : super(key: key);

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
            showDetails: (model) => _showRecipeDetails(model, context),
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

  void _showRecipeDetails(RecipeViewModel model, BuildContext context) {
    final bottomNavigationBloc = BlocProvider.of<BottomNavigationBloc>(context);
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
          bottomNavigationBloc.add(ShowNavigationBar());
          final bookmarksBloc = BlocProvider.of<BookmarksBloc>(context);
          bookmarksBloc.add(UpdateIsInBookmarks(model));
          return true;
        },
      ),
      fullscreenDialog: true,
    );
    navigator.push(route);
    bottomNavigationBloc.add(
      HideNavigationBar(),
    );
  }
}

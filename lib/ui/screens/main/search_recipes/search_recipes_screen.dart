import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widget_factory/widget_factory.dart';

import '../../../../bloc/search_recipes/index.dart';
import '../../../reusable/list_items/progress_indicator_item.dart';
import '../../../reusable/search_bar.dart';
import '../../recipe_details/recipe_details_screen_factory.dart';
import '../recipes/recipe/recipe_view.dart';
import '../recipes/recipe/recipe_view_model.dart';

class SearchRecipesScreen extends StatelessWidget {
  final WidgetFactory recipeDetailsScreenFactory;

  const SearchRecipesScreen({
    Key key,
    @required this.recipeDetailsScreenFactory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<SearchRecipesBloc, SearchRecipesState>(
      builder: (context, state) => Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: theme.colorScheme.primary,
                height: 52,
              ),
            ),
            Positioned(
              top: 144,
              left: 0,
              right: 0,
              child: Visibility(
                visible: state.loadingFirstPage,
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
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  SearchBar(
                    autofocus: true,
                    onTextChanged: (text) =>
                        _onSearchTextChanged(context, text),
                    onBackArrowPressed: () {
                      FocusScope.of(context).unfocus();
                      Navigator.of(context).maybePop();
                    },
                  ),
                  Expanded(
                    child: _ScrollView(
                      state: state,
                      recipeDetailsScreenFactory: recipeDetailsScreenFactory,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSearchTextChanged(BuildContext context, String text) {
    final bloc = BlocProvider.of<SearchRecipesBloc>(context);
    final event = SearchQueryChanged(text);
    bloc.add(event);
  }
}

class _ScrollView extends StatefulWidget {
  final SearchRecipesState state;
  final WidgetFactory recipeDetailsScreenFactory;

  _ScrollView({
    Key key,
    @required this.state,
    @required this.recipeDetailsScreenFactory,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScrollViewState();
}

class _ScrollViewState extends State<_ScrollView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      FocusScope.of(context).unfocus();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scrollbar(
      child: ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: 8),
        itemCount: widget.state.listItems.length,
        itemBuilder: (context, index) {
          final model = widget.state.listItems[index];
          if (model is RecipeViewModel) {
            if ((index == widget.state.listItems.length - 1) &&
                !widget.state.loadingNextPage) {
              BlocProvider.of<SearchRecipesBloc>(context).add(LoadNextPage());
            }
            return RecipeView(
              key: ObjectKey(model),
              model: model,
              theme: theme,
              addToBookmarks: (model) => _addRecipeToBookmarks(model, context),
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
    );
  }

  void _addRecipeToBookmarks(RecipeViewModel model, BuildContext context) {
    final event = Bookmarks(model);
    final bloc = BlocProvider.of<SearchRecipesBloc>(context);
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
        child: widget.recipeDetailsScreenFactory.createWidget(data: screenData),
        onWillPop: () async {
          final bookmarksBloc = BlocProvider.of<SearchRecipesBloc>(context);
          bookmarksBloc.add(UpdateIsInBookmarks(model));
          return true;
        },
      ),
      fullscreenDialog: true,
    );
    navigator.push(route);
  }
}

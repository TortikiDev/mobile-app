import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tortiki/bloc/bookmarks/index.dart';
import 'package:widget_factory/widget_factory.dart';
import 'package:tortiki/ui/screens/bookmarks/bookmarks_screen.dart';
import 'package:tortiki/ui/screens/main/recipes/recipe/recipe_view_model.dart';

class _MockBookmarksBloc extends MockBloc<BookmarksEvent, BookmarksState>
    implements BookmarksBloc {}

class TestRecipeDetaailsScreenFactory extends Mock implements WidgetFactory {}

class TestBookmarksScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    final recipesModels = [
      RecipeViewModel(
        id: 1,
        title: '1',
        complexity: 4,
        imageUrls: [],
        isInBookmarks: true,
      ),
      RecipeViewModel(
        id: 2,
        title: '2',
        complexity: 3,
        imageUrls: ['http://134.png'],
        isInBookmarks: true,
      ),
    ];

    final bookmarksState = BookmarksState(listItems: recipesModels);
    registerFallbackValue(bookmarksState);
    registerFallbackValue(BlocInit());

    final bookmarksBloc = _MockBookmarksBloc();
    when(() => bookmarksBloc.state).thenReturn(bookmarksState);

    final recipeDetailsScreenFactory = TestRecipeDetaailsScreenFactory();

    return BlocProvider<BookmarksBloc>(
      create: (context) => bookmarksBloc,
      child: BookmarksScreen(
        recipeDetailsScreenFactory: recipeDetailsScreenFactory,
      ),
    );
  }
}

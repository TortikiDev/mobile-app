import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tortiki/bloc/bookmarks/index.dart';
import 'package:tortiki/ui/reusable/widget_factory.dart';
import 'package:tortiki/ui/screens/bookmarks/bookmarks_screen.dart';
import 'package:tortiki/ui/screens/main/recipes/recipe/recipe_view_model.dart';

class _MockBookmarksBloc extends MockBloc<BookmarksState>
    implements BookmarksBloc {}

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

    final bookmarksBloc = _MockBookmarksBloc();
    final bookmarksState = BookmarksState(listItems: recipesModels);
    when(bookmarksBloc.state).thenReturn(bookmarksState);
    whenListen(bookmarksBloc, Stream<BookmarksState>.value(bookmarksState));

    return BlocProvider<BookmarksBloc>(
      create: (context) => bookmarksBloc,
      child: BookmarksScreen(),
    );
  }
}

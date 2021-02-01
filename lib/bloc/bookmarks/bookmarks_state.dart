import 'package:equatable/equatable.dart';

import '../../ui/screens/main/recipes/recipe/recipe_view_model.dart';

class BookmarksState extends Equatable {
  final List<RecipeViewModel> _listItems;
  final bool loading;

  List<RecipeViewModel> get listItems => List.of(_listItems);

  const BookmarksState({
    List<RecipeViewModel> listItems = const [],
    this.loading = false,
  }) : _listItems = listItems;

  factory BookmarksState.initial() => BookmarksState();

  BookmarksState copy({
    List<RecipeViewModel> listModels,
    bool loading,
  }) =>
      BookmarksState(
        listItems: listItems ?? _listItems,
        loading: loading ?? this.loading,
      );

  @override
  List<Object> get props => [_listItems, loading];

  @override
  bool get stringify => true;
}

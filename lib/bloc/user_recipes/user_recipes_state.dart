import 'package:equatable/equatable.dart';

import '../../ui/reusable/list_items/list_item.dart';

class UserRecipesState extends Equatable {
  final bool isMyRecipes;
  final int userId;
  final List<ListItem> _listItems;
  final Set<int> _bookmarkedRecipesIds;
  final bool loadingFirstPage;
  final bool loadingNextPage;

  List<ListItem> get listItems => List.of(_listItems);
  Set<int> get bookmarkedRecipesIds => Set.of(_bookmarkedRecipesIds);

  UserRecipesState(
      {required this.isMyRecipes,
      required this.userId,
      required List<ListItem> listItems,
      Set<int> bookmarkedRecipesIds = const {},
      this.loadingFirstPage = false,
      this.loadingNextPage = false})
      : _listItems = listItems,
        _bookmarkedRecipesIds = bookmarkedRecipesIds;

  factory UserRecipesState.initial({
    bool isMyRecipes = false,
    required int userId,
  }) =>
      UserRecipesState(
        isMyRecipes: isMyRecipes,
        userId: userId,
        listItems: [],
      );

  UserRecipesState copy({
    bool? isMyRecipes,
    int? userId,
    List<ListItem>? listItems,
    Set<int>? bookmarkedRecipesIds,
    bool? loadingFirstPage,
    bool? loadingNextPage,
  }) =>
      UserRecipesState(
          isMyRecipes: isMyRecipes ?? this.isMyRecipes,
          userId: userId ?? this.userId,
          listItems: listItems ?? _listItems,
          bookmarkedRecipesIds: bookmarkedRecipesIds ?? _bookmarkedRecipesIds,
          loadingFirstPage: loadingFirstPage ?? this.loadingFirstPage,
          loadingNextPage: loadingNextPage ?? this.loadingNextPage);

  @override
  List<Object?> get props => [
        isMyRecipes,
        userId,
        _listItems,
        _bookmarkedRecipesIds,
        loadingFirstPage,
        loadingNextPage,
      ];

  @override
  bool get stringify => true;
}

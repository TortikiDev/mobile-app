@Timeout(Duration(seconds: 10))
import 'package:flutter_test/flutter_test.dart';
import 'package:tortiki/bloc/error_handling/index.dart';
import 'package:tortiki/bloc/search_recipes/index.dart';
import 'package:tortiki/data/database/models/models.dart';
import 'package:tortiki/data/http_client/responses/responses.dart';
import 'package:tortiki/data/repositories/repositories.dart';
import 'package:mockito/mockito.dart';
import 'package:tortiki/ui/reusable/list_items/list_item.dart';
import 'package:tortiki/ui/reusable/list_items/progress_indicator_item.dart';
import 'package:tortiki/ui/screens/main/recipes/recipe/recipe_view_model.dart';

class _MockErrorHandlingBloc extends Mock implements ErrorHandlingBloc {}

class _MockRecipesRepository extends Mock implements RecipesRepository {}

class _MockBookmarkedRecipesRepository extends Mock
    implements BookmarkedRecipesRepository {}

void main() {
  SearchRecipesBloc sut;
  _MockErrorHandlingBloc errorHandlingBloc;
  _MockRecipesRepository recipesRepository;
  _MockBookmarkedRecipesRepository bookmarkedRecipesRepository;

  final initialState = SearchRecipesState.initial();

  setUp(() {
    recipesRepository = _MockRecipesRepository();
    bookmarkedRecipesRepository = _MockBookmarkedRecipesRepository();
    errorHandlingBloc = _MockErrorHandlingBloc();

    sut = SearchRecipesBloc(
      recipesRepository: recipesRepository,
      bookmarkedRecipesRepository: bookmarkedRecipesRepository,
      errorHandlingBloc: errorHandlingBloc,
    );
  });

  tearDown(() {
    sut?.close();
  });

  test('initial state is correct', () {
    expect(sut.state, initialState);
  });

  test('close does not emit new states', () {
    sut.close();
    expectLater(
      sut,
      emitsDone,
    );
  });

  test('BlocInit emits state with bookmarked recipe ids', () {
    // given
    final expectedState = initialState.copy(bookmarkedRecipesIds: {21, 22});
    // when
    when(bookmarkedRecipesRepository.getRecipes())
        .thenAnswer((realInvocation) => Future.value([
              RecipeDbModel(
                  id: 21, title: '123', complexity: 3.0, imageUrls: []),
              RecipeDbModel(
                  id: 22, title: '124', complexity: 3.1, imageUrls: []),
            ]));
    sut.add(BlocInit());
    // then
    expect(
      sut,
      emits(expectedState),
    );
  });

  test('LoadNextPage loads recipes next page', () {
    // given
    final initialItems = <ListItem>[
      RecipeViewModel(id: 19, title: '111', complexity: 5, imageUrls: []),
    ];
    final recipesNextPageResponse = [
      RecipeShortResponse(id: 20, title: '122', complexity: 3.9, imageUrls: []),
      RecipeShortResponse(id: 21, title: '123', complexity: 3.0, imageUrls: []),
      RecipeShortResponse(id: 22, title: '124', complexity: 3.1, imageUrls: []),
      RecipeShortResponse(id: 23, title: '125', complexity: 3.2, imageUrls: []),
    ];

    final baseState = initialState.copy(
      listItems: initialItems,
      bookmarkedRecipesIds: {21, 23},
    );
    final expectedState1 = baseState.copy(
      listItems: initialItems + [ProgressIndicatorItem()],
      loadingNextPage: true,
    );
    final expectedState2 = expectedState1.copy(
      listItems: [
        RecipeViewModel(id: 19, title: '111', complexity: 5, imageUrls: []),
        RecipeViewModel(id: 20, title: '122', complexity: 3.9, imageUrls: []),
        RecipeViewModel(
          id: 21,
          title: '123',
          complexity: 3.0,
          imageUrls: [],
          isInBookmarks: true,
        ),
        RecipeViewModel(id: 22, title: '124', complexity: 3.1, imageUrls: []),
        RecipeViewModel(
          id: 23,
          title: '125',
          complexity: 3.2,
          imageUrls: [],
          isInBookmarks: true,
        ),
      ],
      loadingNextPage: false,
    );
    // when
    when(recipesRepository.getRecipes(lastId: 19))
        .thenAnswer((realInvocation) => Future.value(recipesNextPageResponse));
    sut.emit(baseState);
    sut.add(LoadNextPage());
    // then
    expect(
      sut,
      emitsInOrder([
        expectedState1,
        expectedState2,
      ]),
    );
  });

  test(
      'Bookmarks emits updated items with bokmarked item '
      'and updated bookmarked ids', () {
    // given
    final initialItems = <ListItem>[
      RecipeViewModel(id: 20, title: '122', complexity: 3.9, imageUrls: []),
      RecipeViewModel(
        id: 21,
        title: '123',
        complexity: 3.0,
        imageUrls: [],
        isInBookmarks: true,
      ),
      RecipeViewModel(id: 22, title: '124', complexity: 3.1, imageUrls: []),
      RecipeViewModel(
        id: 23,
        title: '125',
        complexity: 3.2,
        imageUrls: [],
        isInBookmarks: true,
      ),
    ];

    final baseState = initialState.copy(
      listItems: initialItems,
      bookmarkedRecipesIds: {21, 23},
    );
    final expectedState1 = baseState.copy(
      listItems: [
        RecipeViewModel(
          id: 20,
          title: '122',
          complexity: 3.9,
          imageUrls: [],
          isInBookmarks: true,
        ),
        RecipeViewModel(
          id: 21,
          title: '123',
          complexity: 3.0,
          imageUrls: [],
          isInBookmarks: true,
        ),
        RecipeViewModel(id: 22, title: '124', complexity: 3.1, imageUrls: []),
        RecipeViewModel(
          id: 23,
          title: '125',
          complexity: 3.2,
          imageUrls: [],
          isInBookmarks: true,
        ),
      ],
      bookmarkedRecipesIds: {20, 21, 23},
    );
    final expectedState2 = expectedState1.copy(
      listItems: [
        RecipeViewModel(
          id: 20,
          title: '122',
          complexity: 3.9,
          imageUrls: [],
          isInBookmarks: true,
        ),
        RecipeViewModel(id: 21, title: '123', complexity: 3.0, imageUrls: []),
        RecipeViewModel(id: 22, title: '124', complexity: 3.1, imageUrls: []),
        RecipeViewModel(
          id: 23,
          title: '125',
          complexity: 3.2,
          imageUrls: [],
          isInBookmarks: true,
        ),
      ],
      bookmarkedRecipesIds: {20, 23},
    );
    // when
    sut.emit(baseState);
    sut.add(Bookmarks(initialItems[0]));
    sut.add(Bookmarks(initialItems[1]));
    // then
    expect(
      sut,
      emitsInOrder([
        expectedState1,
        expectedState2,
      ]),
    );
  });

  test('Bookmarks set new bookmarked ids to repository', () async {
    // given
    final initialItems = <ListItem>[
      RecipeViewModel(
        id: 21,
        title: '123',
        complexity: 3.0,
        imageUrls: [],
        isInBookmarks: true,
      ),
      RecipeViewModel(id: 22, title: '124', complexity: 3.1, imageUrls: []),
    ];

    final baseState = initialState.copy(
      listItems: initialItems,
      bookmarkedRecipesIds: {21},
    );
    // when
    sut.emit(baseState);
    sut.add(Bookmarks(initialItems[0]));
    sut.add(Bookmarks(initialItems[1]));
    // then
    await untilCalled(bookmarkedRecipesRepository.deleteRecipe(21));
    await untilCalled(bookmarkedRecipesRepository.addRecipe(
      RecipeDbModel(id: 22, title: '124', complexity: 3.1, imageUrls: []),
    ));
    verify(bookmarkedRecipesRepository.deleteRecipe(21)).called(1);
    verify(bookmarkedRecipesRepository.addRecipe(
      RecipeDbModel(id: 22, title: '124', complexity: 3.1, imageUrls: []),
    )).called(1);
  });

  test('SearchQueryChanged loadis recipes with search query', () async {
    // given
    final baseState = initialState.copy(
      bookmarkedRecipesIds: {21},
    );
    final expectedState1 =
        baseState.copy(loadingFirstPage: true, searchQuery: 'pie');
    final expectedState2 = expectedState1.copy(
      listItems: [
        RecipeViewModel(
          id: 21,
          title: 'pie 1',
          complexity: 2,
          imageUrls: [],
          isInBookmarks: true,
        ),
        RecipeViewModel(id: 25, title: 'pie 2', complexity: 2, imageUrls: []),
      ],
      loadingFirstPage: false,
    );
    final expectedState3 =
        expectedState2.copy(listItems: [], setSearchQueryToNull: true);
    // when
    when(recipesRepository.getRecipes(searchQuery: 'pie'))
        .thenAnswer((realInvocation) => Future.value([
              RecipeShortResponse(
                  id: 21, title: 'pie 1', complexity: 2, imageUrls: []),
              RecipeShortResponse(
                  id: 25, title: 'pie 2', complexity: 2, imageUrls: []),
            ]));
    sut.emit(baseState);
    sut.add(SearchQueryChanged('pie'));
    sut.add(SearchQueryChanged('pi'));
    // then
    emitsInOrder([
      expectedState1,
      expectedState2,
      expectedState3,
    ]);
  });

  test('UpdateIsInBookmarks emits state with updated recipe', () {
    // given
    final bookmarkedRecipes = [
      RecipeDbModel(
        id: 1,
        title: '1',
        complexity: 4,
        imageUrls: [],
      ),
    ];
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

    final baseState = initialState.copy(
      listItems: recipesModels,
      bookmarkedRecipesIds: {1, 2},
    );
    final expectedState = baseState.copy(
      listItems: [
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
          isInBookmarks: false,
        ),
      ],
      bookmarkedRecipesIds: {1},
    );
    // when
    when(bookmarkedRecipesRepository.getRecipes())
        .thenAnswer((realInvocation) => Future.value(bookmarkedRecipes));
    sut.emit(baseState);
    sut.add(UpdateIsInBookmarks(recipesModels.last));
    // then
    expect(sut, emits(expectedState));
  });
}

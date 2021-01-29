@Timeout(Duration(seconds: 10))
import 'package:flutter_test/flutter_test.dart';
import 'package:tortiki/bloc/error_handling/index.dart';
import 'package:tortiki/bloc/recipes/index.dart';
import 'package:tortiki/data/database/models/models.dart';
import 'package:tortiki/data/http_client/responses/responses.dart';
import 'package:tortiki/data/repositories/repositories.dart';
import 'package:mockito/mockito.dart';
import 'package:tortiki/ui/reusable/list_items/list_item.dart';
import 'package:tortiki/ui/reusable/list_items/progress_indicator_item.dart';
import 'package:tortiki/ui/screens/main/recipes/recipe/recipe_view_model.dart';

class _MockErrorHandlingBloc extends Mock implements ErrorHandlingBloc {}

class _MockRecipesRepository extends Mock implements RecipesRepository {}

// ignore: must_be_immutable
class _MockPullToRefresh extends Mock implements PullToRefresh {}

class _MockBookmarkedRecipesRepository extends Mock
    implements BookmarkedRecipesRepository {}

void main() {
  RecipesBloc sut;
  _MockErrorHandlingBloc errorHandlingBloc;
  _MockRecipesRepository recipesRepository;
  _MockBookmarkedRecipesRepository bookmarkedRecipesRepository;

  final initialState = RecipesState.initial();

  setUp(() {
    recipesRepository = _MockRecipesRepository();
    bookmarkedRecipesRepository = _MockBookmarkedRecipesRepository();
    errorHandlingBloc = _MockErrorHandlingBloc();

    sut = RecipesBloc(
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

  test('BlocInit loads recipes first page', () {
    // given
    final bookmarkedRecipesStub = [
      RecipeDbModel(id: 21, title: '123', complexity: 3.0, imageUrl: null),
      RecipeDbModel(id: 22, title: '124', complexity: 3.1, imageUrl: null),
    ];
    final recipesResponse = [
      RecipeShortResponse(
          id: 20, title: '122', complexity: 3.9, imageUrl: null),
      RecipeShortResponse(
          id: 21, title: '123', complexity: 3.0, imageUrl: null),
      RecipeShortResponse(
          id: 22, title: '124', complexity: 3.1, imageUrl: null),
      RecipeShortResponse(
          id: 23, title: '125', complexity: 3.2, imageUrl: null),
    ];

    final expectedState1 = initialState.copy(loadingFirstPage: true);
    final expectedState2 = expectedState1.copy(bookmarkedRecipesIds: {21, 22});
    final expectedState3 = expectedState2.copy(
      listItems: [
        RecipeViewModel(id: 20, title: '122', complexity: 3.9, imageUrl: null),
        RecipeViewModel(
          id: 21,
          title: '123',
          complexity: 3.0,
          imageUrl: null,
          isInBookmarks: true,
        ),
        RecipeViewModel(
          id: 22,
          title: '124',
          complexity: 3.1,
          imageUrl: null,
          isInBookmarks: true,
        ),
        RecipeViewModel(id: 23, title: '125', complexity: 3.2, imageUrl: null),
      ],
      loadingFirstPage: false,
    );
    // when
    when(bookmarkedRecipesRepository.getRecipes())
        .thenAnswer((realInvocation) => Future.value(bookmarkedRecipesStub));
    when(recipesRepository.getRecipes())
        .thenAnswer((realInvocation) => Future.value(recipesResponse));
    sut.add(BlocInit());
    // then
    expect(
      sut,
      emitsInOrder([
        expectedState1,
        expectedState2,
        expectedState3,
      ]),
    );
  });

  test('PullToRefresh loads recipes first page', () {
    // given
    final recipesResponse = [
      RecipeShortResponse(
          id: 20, title: '122', complexity: 3.9, imageUrl: null),
      RecipeShortResponse(
          id: 21, title: '123', complexity: 3.0, imageUrl: null),
      RecipeShortResponse(
          id: 22, title: '124', complexity: 3.1, imageUrl: null),
      RecipeShortResponse(
          id: 23, title: '125', complexity: 3.2, imageUrl: null),
    ];

    final baseState = initialState.copy(bookmarkedRecipesIds: {21, 22});
    final expectedState = baseState.copy(listItems: [
      RecipeViewModel(id: 20, title: '122', complexity: 3.9, imageUrl: null),
      RecipeViewModel(
        id: 21,
        title: '123',
        complexity: 3.0,
        imageUrl: null,
        isInBookmarks: true,
      ),
      RecipeViewModel(
        id: 22,
        title: '124',
        complexity: 3.1,
        imageUrl: null,
        isInBookmarks: true,
      ),
      RecipeViewModel(id: 23, title: '125', complexity: 3.2, imageUrl: null),
    ]);
    // when
    sut.emit(baseState);
    when(recipesRepository.getRecipes())
        .thenAnswer((realInvocation) => Future.value(recipesResponse));
    sut.add(PullToRefresh(() {}));
    // then
    expect(
      sut,
      emits(expectedState),
    );
  });

  test('PullToRefresh invokes completion handler of event', () async {
    // given
    final event = _MockPullToRefresh();
    // when
    when(event.onComplete).thenReturn(() {});
    when(recipesRepository.getRecipes())
        .thenAnswer((realInvocation) => Future.value([]));
    sut.add(event);
    // then
    await untilCalled(event.onComplete);
    verify(event.onComplete).called(1);
  });

  test('LoadNextPage loads recipes next page', () {
    // given
    final initialItems = <ListItem>[
      RecipeViewModel(id: 19, title: '111', complexity: 5, imageUrl: null),
    ];
    final recipesNextPageResponse = [
      RecipeShortResponse(
          id: 20, title: '122', complexity: 3.9, imageUrl: null),
      RecipeShortResponse(
          id: 21, title: '123', complexity: 3.0, imageUrl: null),
      RecipeShortResponse(
          id: 22, title: '124', complexity: 3.1, imageUrl: null),
      RecipeShortResponse(
          id: 23, title: '125', complexity: 3.2, imageUrl: null),
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
        RecipeViewModel(id: 19, title: '111', complexity: 5, imageUrl: null),
        RecipeViewModel(id: 20, title: '122', complexity: 3.9, imageUrl: null),
        RecipeViewModel(
          id: 21,
          title: '123',
          complexity: 3.0,
          imageUrl: null,
          isInBookmarks: true,
        ),
        RecipeViewModel(id: 22, title: '124', complexity: 3.1, imageUrl: null),
        RecipeViewModel(
          id: 23,
          title: '125',
          complexity: 3.2,
          imageUrl: null,
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
      RecipeViewModel(id: 20, title: '122', complexity: 3.9, imageUrl: null),
      RecipeViewModel(
        id: 21,
        title: '123',
        complexity: 3.0,
        imageUrl: null,
        isInBookmarks: true,
      ),
      RecipeViewModel(id: 22, title: '124', complexity: 3.1, imageUrl: null),
      RecipeViewModel(
        id: 23,
        title: '125',
        complexity: 3.2,
        imageUrl: null,
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
          imageUrl: null,
          isInBookmarks: true,
        ),
        RecipeViewModel(
          id: 21,
          title: '123',
          complexity: 3.0,
          imageUrl: null,
          isInBookmarks: true,
        ),
        RecipeViewModel(id: 22, title: '124', complexity: 3.1, imageUrl: null),
        RecipeViewModel(
          id: 23,
          title: '125',
          complexity: 3.2,
          imageUrl: null,
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
          imageUrl: null,
          isInBookmarks: true,
        ),
        RecipeViewModel(id: 21, title: '123', complexity: 3.0, imageUrl: null),
        RecipeViewModel(id: 22, title: '124', complexity: 3.1, imageUrl: null),
        RecipeViewModel(
          id: 23,
          title: '125',
          complexity: 3.2,
          imageUrl: null,
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
        imageUrl: null,
        isInBookmarks: true,
      ),
      RecipeViewModel(id: 22, title: '124', complexity: 3.1, imageUrl: null),
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
      RecipeDbModel(id: 22, title: '124', complexity: 3.1, imageUrl: null),
    ));
    verify(bookmarkedRecipesRepository.deleteRecipe(21)).called(1);
    verify(bookmarkedRecipesRepository.addRecipe(
      RecipeDbModel(id: 22, title: '124', complexity: 3.1, imageUrl: null),
    )).called(1);
  });
}

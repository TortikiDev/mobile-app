@Timeout(Duration(seconds: 10))
import 'package:flutter_test/flutter_test.dart';
import 'package:tortiki/bloc/bookmarks/index.dart';
import 'package:tortiki/bloc/error_handling/index.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tortiki/data/database/models/models.dart';
import 'package:tortiki/data/repositories/repositories.dart';
import 'package:tortiki/ui/screens/main/recipes/recipe/recipe_view_model.dart';

class _MockErrorHandlingBloc extends Mock implements ErrorHandlingBloc {}

class _MockBookmarkedRecipesRepository extends Mock
    implements BookmarkedRecipesRepository {}

void main() {
  late BookmarksBloc sut;
  late _MockErrorHandlingBloc errorHandlingBloc;
  late _MockBookmarkedRecipesRepository bookmarksRepository;

  final initialState = BookmarksState.initial();

  setUp(() {
    errorHandlingBloc = _MockErrorHandlingBloc();
    bookmarksRepository = _MockBookmarkedRecipesRepository();

    sut = BookmarksBloc(
      bookmarksRepository: bookmarksRepository,
      errorHandlingBloc: errorHandlingBloc,
    );
  });

  tearDown(() {
    sut.close();
  });

  test('initial state is correct', () {
    expect(sut.state, initialState);
  });

  test('close does not emit new states', () {
    sut.close();
    expectLater(
      sut.stream,
      emitsDone,
    );
  });

  test('BlocInit loads bookmarked recipes', () {
    // given
    final bookmarkedRecipes = [
      RecipeDbModel(
        id: 1,
        title: '1',
        complexity: 4,
        imageUrls: [],
      ),
      RecipeDbModel(
        id: 2,
        title: '2',
        complexity: 3,
        imageUrls: ['http://134.png'],
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

    final expectedState1 = initialState.copy(loading: true);
    final expectedState2 =
        expectedState1.copy(listItems: recipesModels, loading: false);
    // when
    when(() => bookmarksRepository.getRecipes())
        .thenAnswer((realInvocation) => Future.value(bookmarkedRecipes));
    sut.add(BlocInit());
    // then
    expect(
      sut.stream,
      emitsInOrder([
        expectedState1,
        expectedState2,
      ]),
    );
  });

  test('RemoveFromBookmarks emits state without deleted recipe', () {
    // given
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

    final baseState = initialState.copy(listItems: recipesModels);
    final expectedState = baseState.copy(listItems: [
      RecipeViewModel(
        id: 1,
        title: '1',
        complexity: 4,
        imageUrls: [],
        isInBookmarks: true,
      )
    ]);
    // when
    when(() => bookmarksRepository.deleteRecipe(2))
        .thenAnswer((invocation) => Future.value());
    sut.emit(baseState);
    sut.add(RemoveFromBookmarks(recipesModels.last));
    // then
    expect(sut.stream, emits(expectedState));
  });

  test('RemoveFromBookmarks removes recipe from db', () async {
    // given
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

    final baseState = initialState.copy(listItems: recipesModels);
    // when
    when(() => bookmarksRepository.deleteRecipe(2))
        .thenAnswer((invocation) => Future.value());
    sut.emit(baseState);
    sut.add(RemoveFromBookmarks(recipesModels.last));
    // then
    await untilCalled(() => bookmarksRepository.deleteRecipe(2));
    verify(() => bookmarksRepository.deleteRecipe(2)).called(1);
  });

  test('UpdateIsInBookmarks with false flag emits state without deleted recipe',
      () {
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

    final baseState = initialState.copy(listItems: recipesModels);
    final expectedState = baseState.copy(listItems: [
      RecipeViewModel(
        id: 1,
        title: '1',
        complexity: 4,
        imageUrls: [],
        isInBookmarks: true,
      )
    ]);
    // when
    when(() => bookmarksRepository.getRecipes())
        .thenAnswer((realInvocation) => Future.value(bookmarkedRecipes));
    sut.emit(baseState);
    sut.add(UpdateIsInBookmarks(recipesModels.last));
    // then
    expect(sut.stream, emits(expectedState));
  });
}

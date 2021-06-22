@Timeout(Duration(seconds: 10))
import 'package:flutter_test/flutter_test.dart';
import 'package:tortiki/bloc/error_handling/index.dart';
import 'package:tortiki/bloc/recipe_details/index.dart';
import 'package:tortiki/data/database/models/models.dart';
import 'package:tortiki/data/http_client/responses/responses.dart';
import 'package:tortiki/data/repositories/repositories.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tortiki/ui/screens/recipe_details/recipe_header/recipe_header_view_model.dart';

class _MockErrorHandlingBloc extends Mock implements ErrorHandlingBloc {}

class _MockRecipesRepository extends Mock implements RecipesRepository {}

class _MockBookmarkedRecipesRepository extends Mock
    implements BookmarkedRecipesRepository {}

void main() {
  late RecipeDetailsBloc sut;
  late _MockErrorHandlingBloc errorHandlingBloc;
  late _MockRecipesRepository recipesRepository;
  late _MockBookmarkedRecipesRepository bookmarkedRecipesRepository;

  final initialRecipeStub = RecipeResponse(
    id: 123,
    title: 'title',
    complexity: 4.0,
    imageUrls: ['http://123.png'],
  );
  final initialState = RecipeDetailsState.initial(
    recipe: initialRecipeStub,
    isInBookmarks: false,
  );

  setUp(() {
    recipesRepository = _MockRecipesRepository();
    bookmarkedRecipesRepository = _MockBookmarkedRecipesRepository();
    errorHandlingBloc = _MockErrorHandlingBloc();

    sut = RecipeDetailsBloc(
      recipesRepository: recipesRepository,
      bookmarkedRecipesRepository: bookmarkedRecipesRepository,
      errorHandlingBloc: errorHandlingBloc,
      recipe: initialRecipeStub,
      isInBookmarks: false,
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

  test('BlocInit loads recipe', () {
    // given
    final recipeResponse = RecipeResponse(
      id: 123,
      title: 'title',
      complexity: 4.0,
      imageUrls: ['http://123.png'],
      userAvaratUrl: 'http://avatar.png',
      userName: 'name',
      userId: 123,
      userGender: Gender.female,
      description: '12345',
      ingredients: ['1', '2'],
      cookingSteps: '54321',
      myVote: 0,
    );

    final expectedState1 = initialState.copy(loading: true);
    final expectedState2 = expectedState1.copy(
      loading: false,
      recipe: recipeResponse,
      headerViewModel: RecipeHeaderViewModel(
        title: 'title',
        complexity: 4.0,
        authorAvatarUrl: 'http://avatar.png',
        authorName: 'name',
        authorGender: Gender.female,
        authorId: 123,
      ),
    );
    // when
    when(() => recipesRepository.getRecipe(123))
        .thenAnswer((realInvocation) => Future.value(recipeResponse));
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

  test('Bookmarks event emits new state with updated isInBookmarks flag', () {
    // given
    final headerViewModelStub = RecipeHeaderViewModel(
      title: 'title',
      complexity: 4.0,
      authorAvatarUrl: 'http://avatar.png',
      authorName: 'name',
      authorGender: Gender.male,
      authorId: 123,
      isInBookmarks: false,
    );

    final expectedState = initialState.copy(
        headerViewModel: headerViewModelStub.copy(isInBookmarks: true));
    // when
    sut.add(Bookmarks(headerViewModelStub));
    // then
    expect(
      sut.stream,
      emits(expectedState),
    );
  });

  test('Bookmarks event emits new state with updated isInBookmarks flag', () {
    // given
    final headerViewModelStub = RecipeHeaderViewModel(
      title: 'title',
      complexity: 4.0,
      authorAvatarUrl: 'http://avatar.png',
      authorName: 'name',
      authorGender: Gender.male,
      authorId: 123,
      isInBookmarks: false,
    );

    final expectedState = initialState.copy(
        headerViewModel: headerViewModelStub.copy(isInBookmarks: true));
    // when
    sut.add(Bookmarks(headerViewModelStub));
    // then
    expect(
      sut.stream,
      emits(expectedState),
    );
  });

  test('Bookmarks set new bookmarked ids to repository', () async {
    // given
    final recipeResponseStub = RecipeResponse(
      id: 123,
      title: 'title',
      complexity: 4.0,
      imageUrls: ['http://123.png'],
      userAvaratUrl: 'http://avatar.png',
      userName: 'name',
      userGender: Gender.female,
      description: '12345',
      ingredients: ['1', '2'],
      cookingSteps: '54321',
      myVote: 0,
    );
    final headerViewModelStub = RecipeHeaderViewModel(
      title: 'title',
      complexity: 4.0,
      authorAvatarUrl: 'http://avatar.png',
      authorName: 'name',
      authorGender: Gender.male,
      authorId: 123,
      isInBookmarks: false,
    );

    final baseState = initialState.copy(recipe: recipeResponseStub);
    // when
    sut.emit(baseState);
    sut.add(Bookmarks(headerViewModelStub));
    sut.add(Bookmarks(headerViewModelStub.copy(isInBookmarks: true)));
    // then
    await untilCalled(() => bookmarkedRecipesRepository.addRecipe(
          RecipeDbModel(
            id: 123,
            title: 'title',
            complexity: 4.0,
            imageUrls: ['http://123.png'],
          ),
        ));
    await untilCalled(() => bookmarkedRecipesRepository.deleteRecipe(123));

    verify(() => bookmarkedRecipesRepository.addRecipe(
          RecipeDbModel(
            id: 123,
            title: 'title',
            complexity: 4.0,
            imageUrls: ['http://123.png'],
          ),
        )).called(1);
    verify(() => bookmarkedRecipesRepository.deleteRecipe(123)).called(1);
  });

  test('VoteUp event emits new state voted up recipe', () {
    // give
    final expectedState = initialState.copy(
        recipe: initialRecipeStub.copy(myVote: VoteResult.votedUp));
    // when
    sut.add(VoteUp());
    // then
    expect(
      sut.stream,
      emits(expectedState),
    );
  });

  test('VoteDown event emits new state voted down recipe', () {
    // give
    final expectedState = initialState.copy(
        recipe: initialRecipeStub.copy(myVote: VoteResult.votedDown));
    // when
    sut.add(VoteDown());
    // then
    expect(
      sut.stream,
      emits(expectedState),
    );
  });

  test('VoteUp event invokes voteUpRecipe() method of recipe repository',
      () async {
    // give
    // when
    sut.add(VoteUp());
    // then
    await untilCalled(
        () => recipesRepository.voteUpRecipe(recipeId: initialRecipeStub.id));
  });

  test('VoteDown event invokes voteUpRecipe() method of recipe repository',
      () async {
    // give
    // when
    sut.add(VoteDown());
    // then
    await untilCalled(
        () => recipesRepository.voteDownRecipe(recipeId: initialRecipeStub.id));
  });
}

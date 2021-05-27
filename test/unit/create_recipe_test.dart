@Timeout(Duration(seconds: 10))
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:tortiki/bloc/create_recipe/index.dart';
import 'package:tortiki/bloc/error_handling/index.dart';
import 'package:mockito/mockito.dart';
import 'package:tortiki/data/repositories/repositories.dart';

class _MockErrorHandlingBloc extends Mock implements ErrorHandlingBloc {}

class _MockRecipesRepository extends Mock implements RecipesRepository {}

void main() {
  CreateRecipeBloc sut;
  _MockErrorHandlingBloc errorHandlingBloc;
  _MockRecipesRepository recipesRepository;

  final initialState = CreateRecipeState.initial();

  setUp(() {
    errorHandlingBloc = _MockErrorHandlingBloc();
    recipesRepository = _MockRecipesRepository();

    sut = CreateRecipeBloc(
      recipesRepository: recipesRepository,
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
    sut?.close();
    expectLater(
      sut.stream,
      emitsDone,
    );
  });

  test('TitleChanged emits state with changed title and validated state', () {
    // given
    final title = '123';
    // when
    sut.add(TitleChanged(title));
    // then
    expect(
      sut.stream,
      emits(initialState.copy(title: title)),
    );
  });

  test('PlusComplexity emits state with increased complexity', () {
    // given
    // when
    sut.add(PlusComplexity());
    // then
    expect(
      sut.stream,
      emits(initialState.copy(complexity: initialState.complexity + 0.5)),
    );
  });

  test('MinusComplexity emits state with decreased complexity', () {
    // given
    // when
    sut.add(MinusComplexity());
    // then
    expect(
      sut.stream,
      emits(initialState.copy(complexity: initialState.complexity - 0.5)),
    );
  });

  test('DescriptionChanged emits state with changed desciption', () {
    // given
    final description = '123';
    // when
    sut.add(DescriptionChanged(description));
    // then
    expect(
      sut.stream,
      emits(initialState.copy(description: description)),
    );
  });

  test('IngredientsChanged emits state with changed ingredients', () {
    // given
    final ingredients = ['123', '456'];
    // when
    sut.add(IngredientsChanged(ingredients));
    // then
    expect(
      sut.stream,
      emits(initialState.copy(ingredients: ingredients)),
    );
  });

  test('CookingStepsChanged emits state with changed cooking steps', () {
    // given
    final cookingSteps = '123';
    // when
    sut.add(CookingStepsChanged(cookingSteps));
    // then
    expect(
      sut.stream,
      emits(initialState.copy(cookingSteps: cookingSteps)),
    );
  });

  test('PhotoPicked emits state with added new photo', () {
    // given
    final photo = File('123');
    // when
    sut.add(PhotoPicked(photo));
    // then
    expect(
      sut.stream,
      emits(initialState.copy(photos: initialState.photos + [photo])),
    );
  });

  test('PhotoDeleted emits state with delete photo', () {
    // given
    final photo1 = File('123');
    final photo2 = File('456');
    final baseState = initialState.copy(photos: [photo1, photo2]);
    // when
    sut.emit(baseState);
    sut.add(PhotoDeleted(photo1));
    // then
    expect(
      sut.stream,
      emits(initialState.copy(photos: [photo2])),
    );
  });

  test('CreateRecipe does not emit loading state when state is invalid', () {
    // given
    // when
    sut.add(CreateRecipe());
    sut.close();
    // then
    expect(
      sut.stream,
      neverEmits(initialState.copy(creatingRecipe: true)),
    );
  });

  test(
      'CreateRecipe does not invoke repositories createRecipe '
      'method when state is invalid', () {
    // given
    // when
    sut.add(CreateRecipe());
    sut.close();
    // then
    verifyNever(recipesRepository.createRecipe(
      title: anyNamed('title'),
      complexity: anyNamed('complexity'),
      description: anyNamed('description'),
      ingredients: anyNamed('ingredients'),
      cookingSteps: anyNamed('cookingSteps'),
      photos: anyNamed('photos'),
    ));
  });

  test('CreateRecipe flow test', () {
    // given
    final title = 'recipe';
    final description = '123';
    final ingredients = ['1', '2'];
    final cookingSteps = 'cooking';
    final photo1 = File('123');
    final photo2 = File('456');
    final photo3 = File('789');

    final expectedState0 = initialState.copy(title: title);
    final expectedState1 =
        expectedState0.copy(complexity: expectedState0.complexity + 0.5);
    final expectedState2 =
        expectedState1.copy(complexity: expectedState1.complexity - 0.5);
    final expectedState3 = expectedState2.copy(description: description);
    final expectedState4 = expectedState3.copy(ingredients: ingredients);
    final expectedState5 = expectedState4.copy(cookingSteps: cookingSteps);
    final expectedState6 = expectedState5.copy(photos: [photo1]);
    final expectedState7 = expectedState6.copy(canCreateRecipe: true);
    final expectedState8 = expectedState7.copy(photos: [photo1, photo2]);
    final expectedState9 =
        expectedState8.copy(photos: [photo1, photo2, photo3]);
    final expectedState10 = expectedState9.copy(photos: [photo1, photo2]);
    final expectedState11 = expectedState10.copy(creatingRecipe: true);
    final expectedState12 = expectedState11.copy(
        creatingRecipe: false, recipeSuccessfulyCreated: true);

    // when
    when(recipesRepository.createRecipe(
      title: title,
      complexity: initialState.complexity,
      description: description,
      ingredients: ingredients,
      cookingSteps: cookingSteps,
      photos: [photo1, photo2],
    )).thenAnswer((realInvocation) => Future.value());
    sut.add(TitleChanged(title));
    sut.add(PlusComplexity());
    sut.add(MinusComplexity());
    sut.add(DescriptionChanged(description));
    sut.add(IngredientsChanged(ingredients));
    sut.add(CookingStepsChanged(cookingSteps));
    sut.add(PhotoPicked(photo1));
    sut.add(PhotoPicked(photo2));
    sut.add(PhotoPicked(photo3));
    sut.add(PhotoDeleted(photo3));
    sut.add(CreateRecipe());
    // then
    expect(
      sut.stream,
      emitsInOrder([
        expectedState0,
        expectedState1,
        expectedState2,
        expectedState3,
        expectedState4,
        expectedState5,
        expectedState6,
        expectedState7,
        expectedState8,
        expectedState9,
        expectedState10,
        expectedState11,
        expectedState12,
      ]),
    );
  });
}

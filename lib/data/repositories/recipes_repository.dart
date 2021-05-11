import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../http_client/responses/responses.dart';

class RecipesRepository {
  Future<List<RecipeShortResponse>> getRecipes({
    String searchQuery,
    int limit = 24,
    int lastId,
  }) {
    final recipesStub = [
      RecipeShortResponse(
        id: 155,
        title: 'Бисквитный торт',
        complexity: 0.7,
        imageUrls: [
          'https://images.unsplash.com/photo-1457666134378-6b77915bd5f'
              '2?ixid=MXwxMjA3fDB8MHxzZWFyY2h8Nnx8c3BvbmdlJTIwY2FrZXxlbnwwf'
              'HwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=60',
          'https://images.unsplash.com/photo-1570205931109-7ab14fdbd'
              '70b?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8cmFzcGJlcnJ5JTIwcGllf'
              'GVufDB8f'
              'DB8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=60'
        ],
      ),
      RecipeShortResponse(
        id: 156,
        title: 'Малиновый пирог с глазурью',
        complexity: 0.3,
        imageUrls: [
          'https://images.unsplash.com/photo-1570205931109-7ab14fdbd'
              '70b?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8cmFzcGJlcnJ5JTIwcGllf'
              'GVufDB8f'
              'DB8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=60',
          'https://images.unsplash.com/photo-1457666134378-6b77915bd5f'
              '2?ixid=MXwxMjA3fDB8MHxzZWFyY2h8Nnx8c3BvbmdlJTIwY2FrZXxlbnwwf'
              'HwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=60'
        ],
      ),
    ];

    final result = <RecipeShortResponse>[];
    do {
      result.addAll(recipesStub);
    } while (result.length <= limit);
    final fillteredResult = searchQuery != null
        ? result
            .where(
              (e) => e.title.toLowerCase().contains(searchQuery.toLowerCase()),
            )
            .toList()
        : result;
    final limitedResult = fillteredResult
        .getRange(0, min(limit, fillteredResult.length))
        .toList()
        .asMap()
        .map((key, value) => MapEntry(key, value.copy(id: key)))
        .values
        .toList();

    return Future.delayed(Duration(seconds: 2))
        .then((_) => Future.value(limitedResult));
  }

  Future<RecipeResponse> getRecipe(int id) =>
      Future.delayed(Duration(seconds: 2)).then(
        (value) => RecipeResponse(
          id: id,
          title: 'Маффины в шоколадной глазури',
          complexity: 0.5,
          imageUrls: [
            'https://images.unsplash.com/photo-1457666134378-6b77915bd5f'
                '2?ixid=MXwxMjA3fDB8MHxzZWFyY2h8Nnx8c3BvbmdlJTIwY2FrZXxlbnwwf'
                'HwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=60',
            'https://images.unsplash.com/photo-1486427944299-d1955d23e34d',
            'https://images.unsplash.com/photo-1486427944299-d1955d23e34d',
          ],
          userAvaratUrl:
              'https://images.unsplash.com/photo-1510616022132-9976466385a8',
          userName: 'Granny',
          userId: 123,
          description:
              'Чтобы придать обычным кексам более эффектный внешний вид,'
              ' вмешайте в часть теста растопленный шоколад и немного какао. '
              'Выложите в формочки поочерёдно ванильное и шоколадное тесто и с '
              'помощью деревянного шампура создайте на тесте лёгкие мраморные '
              'разводы. При минимуме усилий вы получите шикарные кексы с '
              'изумительным сочетанием ванили и шоколада. Украсьте их '
              'шоколадной глазурью, окунув в ганаш лишь верхушки кексов, чтоб'
              ' сбоку оставался видным их мраморный узор.',
          ingredients: [
            '130 гр. сливочного масла, комнатной температуры',
            '200 гр. сахара',
            '2 больших яйца комнатной температуры',
            '100 гр. сметаны',
            '2 ч. л. ванильного экстракта',
            '180 гр. муки высшего сорта',
            '1 ч. л. разрыхлителя теста',
            '0,5 ч. л. соли',
            '85 гр. тёмного шоколада, растопленного и остывшего',
            '2 ч. л. какао-порошка, просеянного',
          ],
          cookingSteps:
              '''1. Разогрейте духовку до 175°C. Смажьте маслом и присыпьте мукой форму на 12 кексов с отверстиями посередине, стряхнув излишки муки. 

2. С помощью ручного или стационарного миксера с насадкой лопаткой взбейте сливочное масло с сахаром до пышной массы. В отдельной чаше слегка взболтайте вилкой яйца и добавьте их понемногу в масляную смесь, взбивая её на средней скорости миксера. Смешайте сметану с ванилью и также добавьте в тесто. 

3. В отдельную миску просейте муку, разрыхлитель и соль. Добавьте сухую смесь в тесто, взбивая на низкой скорости и соскабливая тесто со стенок чаши миксера, чтоб равномерно всё перемешать. 

4. Переложите треть теста в другую миску. Вмешайте в него растопленный шоколад и какао-порошок. Выложите тесто в 2 кондитерских мешка с простыми наконечниками (или без наконечников) и выдавите в каждую форму для кекса ванильное и шоколадное тесто, чередуя их. Немного перемешайте тесто с помощью бамбукового шампура. 

5. Выпекайте кексы около 20 минут, пока деревянный шампур, вставленный в центр кекса, не выйдет чистым. Остудите кексы в течение 30 минут в форме, затем выложите их, чтоб полностью остудить перед нанесением глазури. 

6. Глазурь: смешайте шоколад, сливки и сливочное масло в металлической миске, установленной над кастрюлей с медленно кипящей водой. Аккуратно помешивайте смесь, пока она не растает. Макните верхушки кексов в глазурь и поставьте их обратно на противень, чтобы шоколад застыл. Вы можете сразу же подавать кексы или положить их в холодильник, если не планируете подавать в ближайшие 4 часа. Кексы можно хранить в холодильнике в течение 2 дней.
        ''',
          myVote: 0,
        ),
      );

  Future<void> createRecipe({
    @required String title,
    @required double complexity,
    @required String description,
    @required List<String> ingredients,
    @required String cookingSteps,
    @required List<File> photos,
  }) =>
      Future.delayed(Duration(seconds: 2));

  Future<void> voteUpRecipe({@required int recipeId}) =>
      Future.delayed(Duration(seconds: 2));

  Future<void> voteDownRecipe({@required int recipeId}) =>
      Future.delayed(Duration(seconds: 2));
}

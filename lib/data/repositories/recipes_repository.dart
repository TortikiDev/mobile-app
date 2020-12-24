import 'dart:async';

import '../http_client/responses/responses.dart';

class RecipesRepository {
  Future<List<RecipeShortResponse>> getRecipes({int limit = 24, int lastId}) {
    final recipesStub = [
      RecipeShortResponse(
        id: 155,
        title: 'Бисквитный торт',
        complexity: 3.5,
        imageUrl: 'https://images.unsplash.com/photo-1457666134378-6b77915bd5f'
        '2?ixid=MXwxMjA3fDB8MHxzZWFyY2h8Nnx8c3BvbmdlJTIwY2FrZXxlbnwwfHwwfA%3D%'
        '3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=60',
      ),
      RecipeShortResponse(
        id: 156,
        title: 'Малиновый пирог',
        complexity: 2.0,
        imageUrl: 'https://images.unsplash.com/photo-1570205931109-7ab14fdbd'
        '70b?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8cmFzcGJlcnJ5JTIwcGllfGVufDB8f'
        'DB8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=60',
      ),
    ];

    final result = <RecipeShortResponse>[];
    do {
      result.addAll(recipesStub);
    } while (result.length <= limit);
    final limitedResult = result
        .getRange(0, limit)
        .toList()
        .asMap()
        .map((key, value) => MapEntry(key, value.copy(id: key)))
        .values
        .toList();

    return Future.delayed(Duration(seconds: 2))
        .then((_) => Future.value(limitedResult));
  }
}

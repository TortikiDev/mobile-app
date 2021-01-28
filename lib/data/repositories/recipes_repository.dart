import 'dart:async';
import 'dart:math';

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
        imageUrl: 'https://images.unsplash.com/photo-1457666134378-6b77915bd5f'
            '2?ixid=MXwxMjA3fDB8MHxzZWFyY2h8Nnx8c3BvbmdlJTIwY2FrZXxlbnwwf'
            'HwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=60',
      ),
      RecipeShortResponse(
        id: 156,
        title: 'Малиновый пирог с глазурью',
        complexity: 0.3,
        imageUrl: 'https://images.unsplash.com/photo-1570205931109-7ab14fdbd'
            '70b?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8cmFzcGJlcnJ5JTIwcGllfGVufDB8f'
            'DB8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=60',
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
}

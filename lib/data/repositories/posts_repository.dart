import 'package:dio/dio.dart';

import '../responses/responses.dart';

// TODO: inject api client and make real requests
class PostsRepository {
  Future<List<PostResponse>> getPosts({int limit = 24, int lastId}) {
    final postsStub = [
      PostResponse(
          id: 123,
          userAvaratUrl:
              'https://images.unsplash.com/photo-1510616022132-9976466385a8',
          userName: 'Granny',
          imageUrl:
              'https://images.unsplash.com/photo-1486427944299-d1955d23e34d',
          description:
              'В качестве рекламы моего рецепта могу сказать следующее.',
          likes: 0,
          liked: false),
      PostResponse(
          id: 124,
          userAvaratUrl: null,
          userName: 'DEady',
          imageUrl:
              'https://images.unsplash.com/photo-1510616022132-9976466385a8',
          description:
              'В качестве рекламы моего рецепта могу сказать следующее: '
              'когда муж моей подруги, капитан рыболовного судна, возвращался'
              ' после 4 - 6 месяцев отсутствия домой, он звонил из Норвегии '
              'или уже из Мурманска и просил меня испечь для него этот торт. '
              'И я пекла. Оля рассказывает, что огромный торт он съедал один,'
              ' никому не давал ни кусочка... говорил: "Это МОЙ торт! Он ДЛЯ'
              ' МЕНЯ сделан!" И все. Ингредиентов - самый минимум!!! '
              'Результат просто превосходный!',
          likes: 1250,
          liked: true)
    ];

    final result = <PostResponse>[];
    do {
      result.addAll(postsStub);
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

  Future<void> likePost({int postId}) => Future.delayed(Duration(seconds: 1));

  Future<void> unlikePost({int postId}) => Future.delayed(Duration(seconds: 1))
      .then((_) => Future.error(DioError(type: DioErrorType.SEND_TIMEOUT)));
}

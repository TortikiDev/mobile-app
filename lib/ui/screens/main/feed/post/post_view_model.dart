import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class PostViewModel extends Equatable {
  final String id;
  final String userAvaratUrl;
  final String userName;
  final String imageUrl;
  final String description;
  final int likes;
  final bool liked;

  PostViewModel(
      {@required this.id,
      @required this.userAvaratUrl,
      @required this.userName,
      @required this.imageUrl,
      @required this.description,
      @required this.likes,
      @required this.liked});

  PostViewModel copy(
          {String id,
          String userAvaratUrl,
          String userName,
          String imageUrl,
          String description,
          bool descriptionExpanded,
          int likes,
          bool liked}) =>
      PostViewModel(
          id: id ?? this.id,
          userAvaratUrl: userAvaratUrl ?? this.userAvaratUrl,
          userName: userName ?? this.userName,
          imageUrl: imageUrl ?? this.imageUrl,
          description: description ?? this.description,
          likes: likes ?? this.likes,
          liked: liked ?? this.liked);

  @override
  List<Object> get props =>
      [id, userAvaratUrl, userName, imageUrl, description, likes, liked];

  @override
  bool get stringify => true;
}

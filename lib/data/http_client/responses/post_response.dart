import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class PostResponse extends Equatable {
  final int id;
  final String userAvaratUrl;
  final String userName;
  final String imageUrl;
  final String description;
  final int likes;
  final bool liked;
  final bool descriptionExpanded;

  PostResponse(
      {@required this.id,
      @required this.userAvaratUrl,
      @required this.userName,
      @required this.imageUrl,
      @required this.description,
      @required this.likes,
      @required this.liked,
      this.descriptionExpanded = false});

  PostResponse copy(
          {int id,
          String userAvaratUrl,
          String userName,
          String imageUrl,
          String description,
          int likes,
          bool liked,
          bool descriptionExpanded}) =>
      PostResponse(
          id: id ?? this.id,
          userAvaratUrl: userAvaratUrl ?? this.userAvaratUrl,
          userName: userName ?? this.userName,
          imageUrl: imageUrl ?? this.imageUrl,
          description: description ?? this.description,
          likes: likes ?? this.likes,
          liked: liked ?? this.liked,
          descriptionExpanded: descriptionExpanded ?? this.descriptionExpanded);

  @override
  List<Object> get props => [
        id,
        userAvaratUrl,
        userName,
        imageUrl,
        description,
        likes,
        liked,
        descriptionExpanded
      ];

  @override
  bool get stringify => true;
}
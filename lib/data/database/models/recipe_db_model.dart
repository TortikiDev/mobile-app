import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class RecipeDbModel extends Equatable {
  final int id;
  final String title;
  final double complexity;
  final List<String> _imageUrls;

  List<String> get imageUrls => _imageUrls;

  RecipeDbModel({
    @required this.id,
    @required this.title,
    @required this.complexity,
    @required List<String> imageUrls,
  }) : _imageUrls = imageUrls;

  factory RecipeDbModel.fromMap(Map<String, dynamic> map) => RecipeDbModel(
        id: map['id'],
        title: map['title'],
        complexity: map['complexity'],
        imageUrls: map['imageUrls'].toString().split('(,/separator/,)'),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'complexity': complexity,
        'imageUrls': imageUrls.join('(,/separator/,)'),
      };

  @override
  List<Object> get props => [id, title, complexity, imageUrls];

  @override
  bool get stringify => true;
}

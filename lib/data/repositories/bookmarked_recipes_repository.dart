import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../database/models/models.dart';

class BookmarkedRecipesRepository {
  final _tableName = 'bookmarked_recipes';
  final Database db;

  BookmarkedRecipesRepository({@required this.db});

  Future<List<RecipeDbModel>> getRecipes() => db.query(_tableName).then(
        (value) => value
            .map(
              (e) => RecipeDbModel.fromMap(e),
            )
            .toList(),
      );

  Future<void> addRecipe(RecipeDbModel recipe) =>
      db.insert(_tableName, recipe.toMap());

  Future<void> deleteRecipe(int id) => db.delete(
        _tableName,
        where: "id = ?",
        whereArgs: [id],
      );
}

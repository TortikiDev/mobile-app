import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../database/models/models.dart';

class BookmarkedRecipesRepository {
  final _tableName = 'bookmarked_recipes';
  final Database _db;

  BookmarkedRecipesRepository({@required Database db}) : _db = db;

  Future<List<RecipeDbModel>> getRecipes() => _db.query(_tableName).then(
        (value) => value
            .map(
              (e) => RecipeDbModel.fromMap(e),
            )
            .toList(),
      );

  Future<void> addRecipe(RecipeDbModel recipe) =>
      _db.insert(_tableName, recipe.toMap());

  Future<void> deleteRecipe(int id) => _db.delete(
        _tableName,
        where: "id = ?",
        whereArgs: [id],
      );
}

import 'package:sqflite/sqflite.dart';

// ignore: one_member_abstracts
abstract class DbFactory {
  Future<Database> createDb();
}

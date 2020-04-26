import 'dart:async';
import 'package:foodcart/models/MenuModel.dart';
import 'package:foodcart/models/Model.dart';
import 'package:sqflite/sqflite.dart';

abstract class DB {
  static Database _db;

  static int get _version => 1;

  static Future<void> init() async {
    if (_db != null) {
      return;
    }

    try {
      String _path = await getDatabasesPath() + 'directory_db.db';
      _db = await openDatabase(_path, version: _version, onCreate: onCreate);
    } catch (ex) {
      print(ex);
    }
  }

  static void onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE CartItems (itemName STRING, id INTEGER PRIMARY KEY, price INTEGER,itemCount INTEGER)');
  }

  /*---------------------------------------------------CartItems-------------------------------------------------------*/

  static Future<List<Map<String, dynamic>>> allSelectedItems() async =>
      _db.query(MenuItemModel.tableName);

  static Future<List<Map<String, dynamic>>> checkItem(MenuItemModel model) async =>
      _db.query(MenuItemModel.tableName, where: 'id = ?', whereArgs: [model.toMap()["id"]]);

  static Future<int> insertMenuItem(MenuItemModel model) async => await _db
      .insert(MenuItemModel.tableName, model.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

  static Future<int> updateItemValue(MenuItemModel model) async => await _db
      .update(MenuItemModel.tableName, model.toMap(), where: 'id = ?', whereArgs: [model.id]);

  static Future<int> deleteOneMenuItem(MenuItemModel model) async =>
      await _db.delete(MenuItemModel.tableName, where: 'id = ?', whereArgs: [model.toMap()["id"]]);

  static Future<int> deleteAllMenuItems() async => await _db.delete(MenuItemModel.tableName);
}

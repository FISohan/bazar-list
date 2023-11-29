import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bazar_list/Models/Bag.dart';
import 'package:bazar_list/Models/bag_dto.dart';
import 'package:bazar_list/Models/product.dart';
import 'package:sqflite/sqflite.dart';

class DbService {
  DbService._();
  static final DbService instance = DbService._();

  factory DbService() => instance;

  Future<Database> get database async {
    try {
      return await init();
    } catch (err) {
      return Future.error("Database init failed.ERR:$err");
    }
  }

  static const String _bagTableName = "bag";
  static const String _productTableName = "product";
  Future<void> _createBagTable(Database db) async {
    const bagTableCreateQuery = '''
       CREATE TABLE bag (
          bag_id INTEGER PRIMARY KEY AUTOINCREMENT ,
          create_time TEXT,
          total_cost INTEGER
       )
    ''';
    try {
      await db.execute(bagTableCreateQuery);
    } catch (err) {
      throw Future.error("Can't Create Bag Table.ERROR: $err");
    }
  }

  Future<void> _createProductTable(Database db) async {
    const String productTableCreateQuery = '''
        CREATE TABLE product (
          product_id INTEGER PRIMARY KEY AUTOINCREMENT ,
          name TEXT NOT NULL ,
          per_unit_price INTEGER ,
          unit_type TEXT ,
          quantity INTEGER ,
          price INTEGER ,
          bag_id REFERENCES bag(bag_id)
       )
        ''';
    try {
      await db.execute(productTableCreateQuery);
    } catch (err) {
      throw Future.error("Can't Create Product Table. ERROR: $err");
    }
  }

  Future<void> _dbOnCreate(Database db, int version) async {
    try {
      await _createProductTable(db);
      await _createBagTable(db);
    } catch (err) {
      throw Future.error("Can't Create Table. ERROR: $err");
    }
  }

  Future<void> _onConfig(Database db) async {
    try {
      await db.execute('''PRAGMA foreign_keys = ON''');
    } catch (err) {
      throw Future.error("Configure failed.ERR:$err");
    }
  }

  Future<List<BagDto>> getAllBag() async {
    List<Map<String, dynamic>> bags;
    try {
      final Database _db = await DbService.instance.database;
      bags = await _db.query(_bagTableName);
      await _db.close();
    } catch (err) {
      return Future.error("Failed to retrieve data.ERR:$err");
    }

    var _bags =
        List.generate(bags.length, (index) => BagDto.fromMap(bags[index]));
    return _bags;
  }

  Future<List<Product>> getProductByBag(int bagId) async {
    late final List<Map<String, dynamic>> products;
    try {
      Database _db = await DbService.instance.database;
      products = await _db
          .query(_productTableName, where: 'bag_id = ?', whereArgs: [bagId]);
      log("Fetch ${products.length} products..");
    } catch (err) {
      return Future.error("Can't retrieve products;Err:: $err");
    }
    return List.generate(
        products.length, (index) => Product.fromMap(products[index]));
  }

  Future<Database> init() async {
    final String directory = await getDatabasesPath();
    final String dbPath = '${directory}bazaarList.db';
    Database db = await openDatabase(dbPath,
        version: 1,
        onConfigure: (Database db) async => await _onConfig(db),
        onCreate: (Database db, int version) async =>
            await _dbOnCreate(db, version));
    return db;
  }

  Future<void> createNewBag(Bag newBag) async {
    try {
      final Database _db = await DbService.instance.database;
      int bagId = await _db.insert(_bagTableName, newBag.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      await Future.wait([
        for (int i = 0; i < newBag.products.length; i++)
          _db.insert(_productTableName, newBag.products[i].toMap(bagId),
              conflictAlgorithm: ConflictAlgorithm.replace)
      ]);
    } catch (err) {
      Future.error("Failed to insert Data:ERR:$err");
    }
  }
}

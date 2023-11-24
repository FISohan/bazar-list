import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bazar_list/Models/Bag.dart';
import 'package:sqflite/sqflite.dart';

class DbService {
  Future<Database> get db async {
    Database db;
    try {
      db = await init();
    } catch (err) {
      return Future.error("Database init failed.ERR:$err");
    }
    return db;
  }

  static const String _bagTableName = "bag";
  static const String _productTableName = "product";
  Future<void> _createBagTable(Database db) async {
    const bagTableCreateQuery = '''
       CREATE TABLE bag (
          bag_id INTEGER PRIMARY KEY AUTOINCREMENT ,
          create_time TEXT
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

  Future<List<Bag?>> getAllBag() async {
    late List<Bag?> bags;
    try{
      final Database _db = await db;
      bags = await _db.query(_bagTableName) as List<Bag?>;
    }catch(err){
      Future.error("Failed to retrieve data.ERR:$err");
    }
    return bags;
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
      final Database _db = await db;
      int bagId = await _db.insert(
          _bagTableName, {'create_time': DateTime.now().toString()},
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

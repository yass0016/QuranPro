import 'dart:io';
import "dart:typed_data";
import 'package:flutter/services.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:quranpro/src/models/chapter.dart';
import 'package:quranpro/src/models/juz.dart';

class SQLiteHelper {
  static final _databaseName = "quran.db";

  final String tableQuranSimple = 'quran_simple';
  final String tableQuranSimpleClean = 'quran_simple_clean';
  final String tableQuranSimpleEnhanced = 'quran_simple_enhanced';
  final String tableQuranSimpleMin = 'quran_simple_min';
  final String tableQuranUthmani = 'quran_uthmani';
  final String tableQuranUthmaniMin = 'quran_uthmani_min';
  final String tableChapters = 'chapters';
  final String tableJuzs = 'juzs';

  // make this a singleton class
  SQLiteHelper._privateConstructor();
  static final SQLiteHelper instance = SQLiteHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, _databaseName);
    var db;

    // try opening (will work if it exists)
    try {
      db = await openDatabase(path, readOnly: true);
    } catch (e) {
      print("Error $e");
    }

    if (db == null) {
      print("Creating new copy from asset");

      ByteData data = await rootBundle.load(join("assets", _databaseName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await new File(path).writeAsBytes(bytes);

      db = await openDatabase(path, readOnly: true);
    } else {
      print("Opening existing database");
    }
    return db;
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(tableQuranSimple);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tableQuranSimple'));
  }

  // Get All Verses in Page
  Future<List<Map<String, dynamic>>> getVersesInPage(int page) async {
    Database db = await instance.database;
    return await db.rawQuery(
        'select q.text, saj.new_juz, saj.juz from quran_simple q JOIN sura_aya_juz saj ON saj.sura = q.sura AND saj.aya = q.aya JOIN pages p ON p.sura = q.sura AND p.aya = q.aya WHERE p.page = $page;');
  }

  // Get All Chapters
  Future<List<Chapter>> getChapters() async {
    Database db = await instance.database;
    List<Chapter> chapters = [];

    var query = await db.rawQuery('select * from $tableChapters');

    query.forEach((row) {
      Chapter chapter = new Chapter(
          row['_id'],
          row['ayas'],
          row['start'],
          row['name'],
          row['tname'],
          row['ename'],
          row['type'],
          row['order'],
          row['rukus']);

      chapters.add(chapter);
    });

    return chapters;
  }

  // Get All Chapters
  Future<List<Juz>> getJuzs() async {
    Database db = await instance.database;
    List<Juz> juzs = [];

    var query = await db.rawQuery('select * from $tableJuzs');

    query.forEach((row) {
      Juz juz = new Juz(row['_id'], row['sura'], row['startingAya'], row['aya'],
          row['name'], row['tname']);

      juzs.add(juz);
    });

    return juzs;
  }

  Future close() async {
    Database db = await instance.database;
    return db.close();
  }
}

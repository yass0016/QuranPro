import 'dart:io';
import "dart:typed_data";
import 'package:flutter/services.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:quranpro/src/models/chapter.dart';
import 'package:quranpro/src/models/juz.dart';

import 'package:shared_preferences/shared_preferences.dart';

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
  final String tableSuraAyaJuz = "sura_aya_juz";
  final String tablePages = "pages";

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

  Future<String> getPageFromChapter(String chapter) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery(
            "select p.page from $tablePages p JOIN $tableChapters c ON p._id = (c.start+1) WHERE c._id = '$chapter'"))
        .toString();
  }

  Future<String> getPageFromJuz(String juz) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery(
        "select p.page from $tablePages p JOIN $tableJuzs j ON p._id = (j.startingAya) WHERE j._id = '$juz'"))
        .toString();
  }

  Future<Chapter> getChapterInfo(String id) async {
    Database db = await instance.database;

    Chapter chapter;

    var query = await db.rawQuery("select * from $tableChapters WHERE _id = '$id'");

    query.forEach((row) {
      chapter = new Chapter(
          row['_id'].toString(),
          row['ayas'].toString(),
          row['start'].toString(),
          row['name'],
          row['tname'],
          row['ename'],
          row['type'],
          row['order'].toString(),
          row['rukus'].toString());
    });

    return chapter;
  }

  // Get All Verses in Page
  Future<List<Map<String, dynamic>>> getVersesInPage(String page) async {
    Database db = await instance.database;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String quranStyle = prefs.getString("quranStyle");

    String tableQuranStyle;

    if (quranStyle == "quran_simple")
      tableQuranStyle = tableQuranSimple;
    else if (quranStyle == "quran_simple_clean")
      tableQuranStyle = tableQuranSimpleClean;
    else if (quranStyle == "quran_simple_enhanced")
      tableQuranStyle = tableQuranSimpleEnhanced;
    else if (quranStyle == "quran_simple_min")
      tableQuranStyle = tableQuranSimpleMin;
    else if (quranStyle == "quran_uthmani")
      tableQuranStyle = tableQuranUthmani;
    else if (quranStyle == "quran_uthmani_min")
      tableQuranStyle = tableQuranUthmaniMin;
    else
      tableQuranStyle = tableQuranSimple;

    return await db.rawQuery(
        "select q.aya, q.sura, q.text, saj.new_juz, saj.juz from $tableQuranStyle q JOIN $tableSuraAyaJuz saj ON saj.sura = q.sura AND saj.aya = q.aya JOIN $tablePages p ON p.sura = q.sura AND p.aya = q.aya WHERE p.page = '$page'");
  }

  // Get All Chapters
  Future<List<Chapter>> getChapters() async {
    Database db = await instance.database;
    List<Chapter> chapters = [];

    var query = await db.rawQuery('select * from $tableChapters');

    query.forEach((row) {
      Chapter chapter = new Chapter(
          row['_id'].toString(),
          row['ayas'].toString(),
          row['start'].toString(),
          row['name'],
          row['tname'],
          row['ename'],
          row['type'],
          row['order'].toString(),
          row['rukus'].toString());

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
      Juz juz = new Juz(
          row['_id'].toString(),
          row['sura'].toString(),
          row['startingAya'].toString(),
          row['aya'].toString(),
          row['name'],
          row['tname']);

      juzs.add(juz);
    });

    return juzs;
  }

  Future close() async {
    Database db = await instance.database;
    return db.close();
  }
}

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBUtil {
  Database? db;

  DBUtil() {
    initDB();
  }

  openDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    db = await openDatabase(path);
  }

  initDB() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    //c:program files/khmer_diction/demo.db
    if (await File(path).exists()) {
    } else {
      ByteData data = await rootBundle.load(join("assets", 'khmer_khmer.db'));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
    }
  }

  Future<List<Map<String, Object?>>> select(String query) async {
    if (db == null) await initDB();
    await openDB();
    return db!.rawQuery(query);
  }
}

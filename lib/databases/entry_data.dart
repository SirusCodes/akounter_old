import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:karate/models/entry.dart';

class DatabaseEntry {
  static DatabaseEntry _databaseEntry;
  static Database _database;

  String entryTable = 'entry_table';
  String colId = 'id';
  String colRoll = 'roll';
  String colName = 'name';
  String colTotal = 'total';
  String colSubTotal = 'subTotal';
  String colAdvBal = 'advBal';
  String colReason = 'reason';
  String colDetailedReason = 'detailedReason';
  String colDate = 'date';
  String colBranch = 'branch';
  String colPending = 'pending';

  DatabaseEntry._createInstance();

  factory DatabaseEntry() {
    if (_databaseEntry == null) {
      _databaseEntry = DatabaseEntry._createInstance();
    }
    return _databaseEntry;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'entry.db';
    // Open/create the database at a given path
    var branchDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return branchDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $entryTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colRoll INTEGER,$colName TEXT,$colTotal INTEGER,$colSubTotal INTEGER,$colAdvBal TEXT,$colReason TEXT,$colDetailedReason TEXT,$colDate TEXT,$colBranch TEXT,$colPending TEXT)');
  }

  //fetching data from database
  Future<List<Map<String, dynamic>>> getBranchEntryMapList() async {
    Database db = await this.database;
    var result = await db.query(entryTable, orderBy: '$colDate DESC');
    return result;
  }

  //insert data to database
  Future<int> insertEntry(Entry entry) async {
    Database db = await this.database;
    var result = await db.insert(entryTable, entry.convertToMap());
    return result;
  }

  //delete data from database
  Future<int> deleteEntry(int id) async {
    Database db = await this.database;
    var result = await db.rawDelete('DELETE FROM $entryTable WHERE $colId=$id');
    return result;
  }

  //update data on database
  Future<int> updateEntry(Entry entry) async {
    Database db = await this.database;
    var result = await db.update(entryTable, entry.convertToMap(),
        where: "$colId=?", whereArgs: [entry.id]);
    return result;
  }

  //get count of name
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $entryTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  //get list
  Future<List<Entry>> getEntryList() async {
    var nameMapList = await getBranchEntryMapList();
    int count = nameMapList.length;
    List<Entry> nameList = List<Entry>();
    for (int i = 0; i < count; i++) {
      nameList.add(Entry.fromMapObject(nameMapList[i]));
    }
    return nameList;
  }

  Future<Null> deleteBranchEntry(String branch) async {
    List<Entry> entryList, list;
    list = await getEntryList();
    entryList = list.where((p) => p.branch == branch).toList();
    for (var i = 0; i < entryList.length; i++) {
      deleteEntry(entryList[i].id);
    }
  }
}

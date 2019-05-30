import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:karate/models/branch.dart';

class DatabaseBranch {
  static DatabaseBranch _databaseBranch;
  static Database _database;

  String branchTable = 'branch_table';
  String colId = 'id';
  String colName = 'name';
  String colBGreen = 'bGreen';
  String colAGreen = 'aGreen';
  String colMember = 'member';
  String colCount = 'count';
  String colPayType = 'payType';

  DatabaseBranch._createInstance();

  factory DatabaseBranch() {
    if (_databaseBranch == null) {
      _databaseBranch = DatabaseBranch._createInstance();
    }
    return _databaseBranch;
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
    String path = directory.path + 'branches.db';
    // Open/create the database at a given path
    var branchDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return branchDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $branchTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT,$colBGreen INTEGER,$colAGreen INTEGER,$colMember INTEGER,$colCount INTEGER,$colPayType INTEGER,' +
            'eOrange INTEGER,eYellow INTEGER,eGreen INTEGER,eBlue INTEGER,ePurple INTEGER,eBrown3 INTEGER,eBrown2 INTEGER,eBrown1 INTEGER,eBlack INTEGER,' +
            'kickpad INTEGER,gloves INTEGER,chestguard INTEGER,footguard INTEGER,card INTEGER,' +
            'dress12 INTEGER,dress13 INTEGER,dress14 INTEGER,dress15 INTEGER,dress16 INTEGER,dress17 INTEGER,dress18 INTEGER,dress19 INTEGER,dress20 INTEGER,dress21 INTEGER,dress22 INTEGER,dress23 INTEGER,dress24 INTEGER,spdress INTEGER,vspdress INTEGER,vvspdress INTEGER)');
  }

  //fetching data from database
  Future<List<Map<String, dynamic>>> getBranchNameMapList() async {
    Database db = await this.database;
    var result = await db.query(branchTable);
    return result;
  }

  //insert data to database
  Future<int> insertName(Branch branch) async {
    Database db = await this.database;
    var result = await db.insert(branchTable, branch.convertToMap());
    return result;
  }

  //delete data from database
  Future<int> deleteName(int id) async {
    Database db = await this.database;
    var result =
        await db.rawDelete('DELETE FROM $branchTable WHERE $colId=$id');
    return result;
  }

  //update data on database
  Future<int> updateName(Branch branch) async {
    Database db = await this.database;
    var result = await db.update(branchTable, branch.convertToMap(),
        where: "$colId=?", whereArgs: [branch.id]);
    return result;
  }

  //get count of name
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $branchTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  //get list
  Future<List<Branch>> getNameList() async {
    var nameMapList = await getBranchNameMapList();
    int count = nameMapList.length;
    List<Branch> nameList = List<Branch>();
    for (int i = 0; i < count; i++) {
      nameList.add(Branch.fromMapObject(nameMapList[i]));
    }
    return nameList;
  }

  Future<Branch> getBranchDetails(String branch) async {
    List<Branch> branchList, updatedList;
    branchList = await getNameList();
    updatedList = branchList.where((p) => p.name == branch);
    return updatedList[0];
  }
}

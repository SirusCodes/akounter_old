import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:karate/models/student.dart';

class DatabaseStudent {
  static DatabaseStudent _databaseStudent;
  static Database _database;

  String studentTable = 'student_table';
  String colId = 'id';
  String colRoll = 'roll';
  String colName = 'name';
  String colBranch = 'branch';
  String colDob = 'dob';
  String colBelt = 'belt';
  String colFee = 'fee';
  String colFromFee = 'fromFee';
  String colNum = 'number';
  String colGender = 'gender';
  String colAdvBal = "advBal";
  String colMember = "member";

  DatabaseStudent._createStudentInstance();

  factory DatabaseStudent() {
    if (_databaseStudent == null) {
      _databaseStudent = DatabaseStudent._createStudentInstance();
    }
    return _databaseStudent;
  }

  Future<Database> get databaseStudent async {
    if (_database == null) {
      _database = await initializeStudentDatabase();
    }
    return _database;
  }

  Future<Database> initializeStudentDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'student.db';
    // Open/create the database at a given path
    var studentDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return studentDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $studentTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colRoll INTEGER,$colName TEXT,$colBranch TEXT,$colBelt INTEGER,$colDob TEXT,$colFee TEXT,$colFromFee TEXT,$colNum TEXT,$colGender INTEGER,$colAdvBal INTEGER,$colMember INTEGER)');
  }

  //fetching all data from db
  Future<List<Map<String, dynamic>>> getStudentMapList() async {
    Database db = await this.databaseStudent;
    var result = await db.query(
      studentTable,
      orderBy: '$colBelt ASC',
    );
    return result;
  }

  //insert student
  Future<int> insertStudent(Student student) async {
    Database db = await this.databaseStudent;
    var result = db.insert(studentTable, student.toMap());
    return result;
  }

  //delete data from db
  Future<int> deleteStudent(int id) async {
    Database db = await this.databaseStudent;
    var result =
        await db.rawDelete('DELETE FROM $studentTable WHERE $colId=$id');
    return result;
  }

  //update data on db
  Future<int> updateStudent(Student student) async {
    Database db = await this.databaseStudent;
    var result = await db.update(studentTable, student.toMap(),
        where: '$colId = ?', whereArgs: [student.id]);
    return result;
  }

  //get count of student
  Future<int> getStudentCount() async {
    Database db = await this.databaseStudent;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $studentTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  //get student list
  Future<List<Student>> getNameList() async {
    var studentMapList = await getStudentMapList();
    int count = studentMapList.length;
    List<Student> nameList = List<Student>();
    for (int i = 0; i < count; i++) {
      nameList.add(Student.fromMapObject(studentMapList[i]));
    }
    return nameList;
  }

  // get student data
  Future<Student> getStudent(int roll, String branch) async {
    List<Student> nameList, studentList;
    nameList = await getNameList();
    studentList =
        nameList.where((p) => p.branch == branch && p.roll == roll).toList();
    return studentList[0];
  }

  // delete students of branch\
  Future<Null> deleteBranchStud(String branch) async {
    List<Student> nameList, studentList;
    nameList = await getNameList();
    studentList = nameList.where((p) => p.branch == branch).toList();
    for (var i = 0; i < studentList.length; i++) {
      deleteStudent(studentList[i].id);
    }
  }

  // batch insert
  Future<Null> batchInsertStud(List<Student> list) async {
    for (Student x in list) {
      insertStudent(x);
    }
  }
}

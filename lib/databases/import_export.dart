import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:karate/databases/branch_data.dart';
import 'package:karate/databases/entry_data.dart';
import 'package:karate/databases/student_data.dart';
import 'package:karate/models/branch.dart';
import 'package:karate/models/entry.dart';
import 'package:karate/models/student.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:csv/csv.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';

class ExpoImpo extends StatefulWidget {
  final String branch;
  ExpoImpo(this.branch);
  @override
  _ExpoImpoState createState() => _ExpoImpoState(this.branch);
}

class _ExpoImpoState extends State<ExpoImpo> {
  GlobalKey<ScaffoldState> _expoImpo = GlobalKey<ScaffoldState>();
  _ExpoImpoState(this.branch);
  List<Student> studentList;
  List<Entry> entryList;
  List<Branch> branchList;
  int count;
  String branch;
  String rows;
  List<dynamic> row = List<dynamic>();

  static String _name,
      _reason,
      _detailedReason,
      _dateEntry,
      _branchEntry,
      _fee,
      _fromFee,
      _advBalEntry,
      _dob,
      _nameStd,
      _branchStd,
      _num,
      _uint8list,
      _nameBranch;
  static int _totalEntry,
      _subTotalEntry,
      _roll,
      _rollStd,
      _belt,
      _gender,
      _advBalStd,
      _memberStd,
      _bGreenData,
      _aGreenData,
      _memberData,
      _count;

  DatabaseStudent _databaseStudent = DatabaseStudent();

  DatabaseEntry _databaseEntry = DatabaseEntry();

  DatabaseBranch _databaseBranch = DatabaseBranch();

  // for expo
  String filePath;

  @override
  void initState() {
    super.initState();
    checkWritePermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _expoImpo,
      appBar: AppBar(
        title: Text('Import/Export'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Import BackUp"),
            leading: Icon(Icons.file_download),
            onTap: () => _importBackUp(),
          ),
          ListTile(
            title: Text("Import Student list"),
            leading: Icon(Icons.file_download),
            onTap: () => _importStudentData(),
          ),
          ListTile(
              title: Text("Import Entry list"),
              leading: Icon(Icons.file_download),
              onTap: () => _importEntryData()),
          ListTile(
            title: Text("Create BackUp"),
            leading: Icon(Icons.file_upload),
            onTap: () {
              row.clear();
              _getBackUp(branch);
            },
          ),
          ListTile(
              title: Text("Export Student list"),
              leading: Icon(Icons.file_upload),
              onTap: () {
                row.clear();
                _exportStudentData();
              }),
          ListTile(
            title: Text("Export Entry list"),
            leading: Icon(Icons.file_upload),
            onTap: () {
              row.clear();
              _exportEntryData();
            },
          ),
        ],
      ),
    );
  }

  void _updateStudentList() {
    final Future<Database> dbFuture =
        _databaseStudent.initializeStudentDatabase();
    dbFuture.then((database) {
      Future<List<Student>> studentListFuture = _databaseStudent.getNameList();
      studentListFuture.then((list) {
        setState(() {
          this.studentList = list.where((p) => p.branch == branch).toList();
        });
      });
    });
  }

  void _updateEntryList() {
    final Future<Database> dbFuture = _databaseEntry.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Entry>> entryListFuture = _databaseEntry.getEntryList();
      entryListFuture.then((list) {
        this.entryList = list.where((p) => p.branch == branch).toList();
      });
    });
  }

  void _updateBranchList() {
    final Future<Database> dbFuture = _databaseBranch.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Branch>> branchListFuture = _databaseBranch.getNameList();
      branchListFuture.then((list) {
        this.branchList = list.where((p) => p.name == branch).toList();
      });
    });
  }

  // export student list
  _exportStudentData() async {
    // location
    String fileName =
        "$filePath$branch(Students)-${DateFormat("dd-MM-yyyy-hh-mm").format(DateTime.now())}.csv";
    print(fileName);
    File file = File(fileName);

    // get list from database
    _updateStudentList();

    //make rows for csv
    for (var i = 0; i < studentList.length; ++i) {
      print("start");
      row.add(studentList[i].roll);
      row.add(studentList[i].name);
      row.add(studentList[i].dob);
      row.add(studentList[i].number);
      row.add(studentList[i].gender);
      row.add(studentList[i].fee);
      row.add(studentList[i].fromFee);
      row.add(studentList[i].branch);
      row.add(studentList[i].belt);
      row.add(studentList[i].advBal);
      row.add(studentList[i].member);
      row.add("\r\n");

      // write to file
      rows = row.toString().replaceAll("[", "").replaceAll("]", "");
      file.writeAsStringSync(rows, mode: FileMode.append);
      row.clear();
    }

    print('done');
    _showSnackBar(context, "File is Exported");
  }

  // import student data
  _importStudentData() async {
    Branch _branch = Branch(
      _nameBranch,
      _bGreenData,
      _aGreenData,
      _memberData,
      _count,
    );

    FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
      allowedFileExtensions: ['csv'],
    );

    _updateBranchList();
    DatabaseBranch _databaseBranch = DatabaseBranch();

    String fileName = await FlutterDocumentPicker.openDocument(params: params);
    if (fileName.isNotEmpty) {
      File file = File(fileName);

      String csv = file.readAsStringSync();
      final res = CsvToListConverter().convert(csv, shouldParseNumbers: false);

      // update branch counter
      List<Branch> branchName =
          branchList.where((p) => p.name == branch).toList();
      _branch = branchName[0];
      _branch.count += res.length;
      print(_branch.count);
      await _databaseBranch.updateName(_branch);

      // print(res);
      for (int i = 1; i <= res.length; i++) {
        Student student = Student(_rollStd, _nameStd, _dob, _branchStd, _belt,
            _fee, _fromFee, _num, _gender, _advBalStd, _memberStd);

        List<dynamic> row = res[i];
        student.roll = _branch.count + i;
        student.name = row[1];
        student.dob = row[2];
        student.number = row[3];
        student.gender = int.parse(row[4]);
        student.fee = row[5];
        student.fromFee = row[6];
        student.branch = row[7];
        student.belt = int.parse(row[8]);
        student.advBal = int.parse(row[9]);
        student.member = int.parse(row[10]);
        _databaseStudent.insertStudent(student);

        print("added ${student.name}");
      }
    }

    _showSnackBar(context, "File is Imported");
  }

  // export entry Data
  _exportEntryData() {
    // location
    String fileName =
        "$filePath$branch(Entry)-${DateFormat("dd-MM-yyyy-hh-mm").format(DateTime.now())}.csv";
    print(fileName);
    File file = File(fileName);

    // get list from database
    _updateEntryList();

    //make rows for csv
    for (var i = 0; i < entryList.length; ++i) {
      print("start");
      row.add(entryList[i].roll);
      row.add(entryList[i].name);
      row.add(entryList[i].branch);
      row.add(entryList[i].advBal);
      row.add(entryList[i].date);
      row.add(entryList[i].detailedReason);
      row.add(entryList[i].pending);
      row.add(entryList[i].reason);
      row.add(entryList[i].subTotal);
      row.add(entryList[i].total);
      row.add("\r\n");

      // write to file
      rows = row.toString().replaceAll("[", "").replaceAll("]", "");
      file.writeAsStringSync(rows, mode: FileMode.append);
      row.clear();
    }
    print("done");
    _showSnackBar(context, "File is Exported");
  }

  // import entry data
  _importEntryData() async {
    FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
      allowedFileExtensions: ['csv'],
    );

    String fileName = await FlutterDocumentPicker.openDocument(params: params);
    if (fileName.isNotEmpty) {
      File file = File(fileName);
      String csv = file.readAsStringSync();
      final res = CsvToListConverter().convert(csv, shouldParseNumbers: false);

      for (int i = 0; i < res.length; i++) {
        Entry entry = Entry(
            _roll,
            _name,
            _totalEntry,
            _subTotalEntry,
            _advBalEntry,
            _reason,
            _detailedReason,
            _dateEntry,
            _branchEntry,
            _uint8list);

        List<dynamic> data = res[i];
        entry.roll = int.parse(data[0]);
        entry.name = data[1];
        entry.branch = data[2];
        entry.advBal = data[3];
        entry.date = data[4];
        entry.detailedReason = data[5];
        entry.pending = data[6];
        entry.reason = data[7];
        entry.subTotal = int.parse(data[8]);
        entry.total = int.parse(data[9]);
        print(entry.name);
        _databaseEntry.insertEntry(entry);
      }
    }
    _showSnackBar(context, "File is Imported");
  }

  // create back up
  _getBackUp(String branch) {
    // update lists
    _updateBranchList();
    _updateEntryList();
    _updateStudentList();

    // get file name
    String fileName =
        "$filePath$branch(BackUp)-${DateFormat("dd-MM-yyyy-hh-mm").format(DateTime.now())}.csv";
    print(fileName);
    File file = File(fileName);

    List<Branch> branchName =
        branchList.where((p) => p.name == branch).toList();

    String branchData =
        "${branchName[0].name},${branchName[0].bGreen},${branchName[0].aGreen},${branchName[0].member},${branchName[0].count},${studentList.length},${entryList.length}\r\n";
    file.writeAsStringSync(branchData, mode: FileMode.append);
    print('branch done');

    // student to csv
    for (int i = 0; i < studentList.length; i++) {
      row.add(studentList[i].roll);
      row.add(studentList[i].name);
      row.add(studentList[i].dob);
      row.add(studentList[i].number);
      row.add(studentList[i].gender);
      row.add(studentList[i].fee);
      row.add(studentList[i].fromFee);
      row.add(studentList[i].branch);
      row.add(studentList[i].belt);
      row.add(studentList[i].advBal);
      row.add(studentList[i].member);
      row.add("\r\n");

      // write to file
      rows = row.toString().replaceAll("[", "").replaceAll("]", "");
      file.writeAsStringSync(rows, mode: FileMode.append);
      row.clear();
    }
    print("studentlist done");
    // entry to csv
    for (var i = 0; i < entryList.length; ++i) {
      print("start");
      row.add(entryList[i].roll);
      row.add(entryList[i].name);
      row.add(entryList[i].branch);
      row.add(entryList[i].advBal);
      row.add(entryList[i].date);
      row.add(entryList[i].detailedReason);
      row.add(entryList[i].pending);
      row.add(entryList[i].reason);
      row.add(entryList[i].subTotal);
      row.add(entryList[i].total);
      row.add("\r\n");

      // write to file
      rows = row.toString().replaceAll("[", "").replaceAll("]", "");
      file.writeAsStringSync(rows, mode: FileMode.append);
      row.clear();
    }
    print("entrylist done");
    _showSnackBar(context, "File is Exported");
  }

  // import backup
  _importBackUp() async {
    Branch _branch = Branch(
      _nameBranch,
      _bGreenData,
      _aGreenData,
      _memberData,
      _count,
    );

    int studentLength, entryLength;

    FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
      allowedFileExtensions: ['csv'],
    );

    String fileName = await FlutterDocumentPicker.openDocument(params: params);
    if (fileName.isNotEmpty) {
      File file = File(fileName);
      String csv = file.readAsStringSync();
      final res = CsvToListConverter().convert(csv, shouldParseNumbers: false);
      List<dynamic> data = res[0];
      _branch.name = data[0];
      _branch.bGreen = int.parse(data[1]);
      _branch.aGreen = int.parse(data[2]);
      _branch.member = int.parse(data[3]);
      _branch.count = int.parse(data[4]);
      studentLength = int.parse(data[5]);
      entryLength = int.parse(data[6]);
      _databaseBranch.insertName(_branch);

      for (int i = 1; i <= studentLength; i++) {
        Student _student = Student(_rollStd, _nameStd, _dob, _branchStd, _belt,
            _fee, _fromFee, _num, _gender, _advBalStd, _memberStd);

        List<dynamic> row = res[i];
        _student.roll = int.parse(row[0]);
        _student.name = row[1];
        _student.dob = row[2];
        _student.number = row[3];
        _student.gender = int.parse(row[4]);
        _student.fee = row[5];
        _student.fromFee = row[6];
        _student.branch = row[7];
        _student.belt = int.parse(row[8]);
        _student.advBal = int.parse(row[9]);
        _student.member = int.parse(row[10]);
        _databaseStudent.insertStudent(_student);

        print("added ${_student.name}");
      }

      for (int i = studentLength; i <= entryLength; i++) {
        Entry _entry = Entry(
            _roll,
            _name,
            _totalEntry,
            _subTotalEntry,
            _advBalEntry,
            _reason,
            _detailedReason,
            _dateEntry,
            _branchEntry,
            _uint8list);

        List<dynamic> data = res[i];
        _entry.roll = int.parse(data[0]);
        _entry.name = data[1];
        _entry.branch = data[2];
        _entry.advBal = data[3];
        _entry.date = data[4];
        _entry.detailedReason = data[5];
        _entry.pending = data[6];
        _entry.reason = data[7];
        _entry.subTotal = int.parse(data[8]);
        _entry.total = int.parse(data[9]);
        print(_entry.name);
        _databaseEntry.insertEntry(_entry);
      }
    }

    _showSnackBar(context, "File is Imported");
  }

  // to check write permissions
  checkWritePermission() async {
    // create file
    Directory dir = await getExternalStorageDirectory();
    Directory('${dir.path}/AKounter/export/')
        .create(recursive: true)
        .then((Directory directory) {
      setState(() {
        filePath = directory.path;
      });
    });
    // get permissions
    SimplePermissions.checkPermission(Permission.WriteExternalStorage)
        .then((checked) {
      if (!checked) {
        SimplePermissions.requestPermission(Permission.WriteExternalStorage);
      }
    });
  }

  // show snackbar
  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    _expoImpo.currentState.showSnackBar(snackBar);
  }
}

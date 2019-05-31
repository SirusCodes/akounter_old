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
import 'package:flushbar/flushbar.dart';

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

  bool _checkSelectBranch = false;

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
      _count,
      _payType;

  DatabaseStudent _databaseStudent = DatabaseStudent();

  DatabaseEntry _databaseEntry = DatabaseEntry();

  DatabaseBranch _databaseBranch = DatabaseBranch();

  // for expo
  String filePath;

  @override
  void initState() {
    super.initState();
    checkWritePermission();
    _updateBranchList();
    _updateEntryList();
    _updateStudentList();
    _checkSelectBranch = branch.isNotEmpty ? true : false;
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
            onTap: () => _importBackUp(context),
          ),
          ListTile(
            enabled: _checkSelectBranch,
            title: Text("Import Student list"),
            leading: Icon(Icons.file_download),
            onTap: () => _importStudentData(context),
          ),
          ListTile(
              enabled: _checkSelectBranch,
              title: Text("Import Entry list"),
              leading: Icon(Icons.file_download),
              onTap: () => _importEntryData(context)),
          ListTile(
            enabled: _checkSelectBranch,
            title: Text("Create BackUp"),
            leading: Icon(Icons.file_upload),
            onTap: () {
              row.clear();
              _getBackUp(branch, context);
            },
          ),
          ListTile(
              enabled: _checkSelectBranch,
              title: Text("Export Student list"),
              leading: Icon(Icons.file_upload),
              onTap: () {
                row.clear();
                _exportStudentData(context);
              }),
          ListTile(
            enabled: _checkSelectBranch,
            title: Text("Export Entry list"),
            leading: Icon(Icons.file_upload),
            onTap: () {
              row.clear();
              _exportEntryData(context);
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
        studentList = list.where((p) => p.branch == branch).toList();
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
  _exportStudentData(BuildContext context) async {
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
  _importStudentData(BuildContext context) async {
    Branch _branch = Branch(
        _nameBranch, _bGreenData, _aGreenData, _memberData, _count, _payType);

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

      List<Branch> branchName =
          branchList.where((p) => p.name == branch).toList();
      _branch = branchName[0];

      for (int i = 0; i <= res.length; i++) {
        Student student = Student(_rollStd, _nameStd, _dob, _branchStd, _belt,
            _fee, _fromFee, _num, _gender, _advBalStd, _memberStd);

        List<dynamic> row = res[i];
        student.roll = row[0];
        student.name = row[1].toString().trimLeft();
        student.dob = row[2].toString().trimLeft();
        student.number = row[3].toString().trimLeft();
        student.gender = int.parse(row[4]);
        student.fee = row[5].toString().trimLeft();
        student.fromFee = row[6].toString().trimLeft();
        student.branch = branch.toString().trimLeft();
        student.belt = int.parse(row[8]);
        student.advBal = int.parse(row[9]);
        student.member = int.parse(row[10]);
        _databaseStudent.insertStudent(student);
        // _branch.count++;
        print(student.roll);
        print("added ${student.name}");
      }

      // update branch counter

      _branch.count = _branch.count + res.length;
      print(_branch.count);
      await _databaseBranch.updateName(_branch);
    }

    _showSnackBar(context, "File is Imported");
  }

  // export entry Data
  _exportEntryData(BuildContext context) {
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
  _importEntryData(BuildContext context) async {
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
        entry.name = data[1].toString().trimLeft();
        entry.branch = branch.toString().trimLeft();
        entry.advBal = data[3].toString().trimLeft();
        entry.date = data[4].toString().trimLeft();
        entry.detailedReason = data[5].toString().trimLeft();
        entry.pending = data[6].toString().trimLeft();
        entry.reason = data[7].toString().trimLeft();
        entry.subTotal = int.parse(data[8]);
        entry.total = int.parse(data[9]);
        print(entry.name);
        _databaseEntry.insertEntry(entry);
      }
    }
    _showSnackBar(context, "File is Imported");
  }

  // create back up
  _getBackUp(String branch, BuildContext context) {
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

    String branchData = "${branchName[0].name},${branchName[0].bGreen},${branchName[0].aGreen},${branchName[0].member},${branchName[0].count},${branchName[0].payType},${studentList.length},${entryList.length}\r\n" +
        "${branchName[0].eOrange},${branchName[0].eYellow},${branchName[0].eGreen},${branchName[0].eBlue},${branchName[0].ePurple},${branchName[0].eBrown3},${branchName[0].eBrown2},${branchName[0].eBrown1},${branchName[0].eBlack}\r\n" +
        "${branchName[0].kickpad},${branchName[0].gloves},${branchName[0].footguard},${branchName[0].chestguard},${branchName[0].card}\r\n" +
        "${branchName[0].dress12},${branchName[0].dress13},${branchName[0].dress14},${branchName[0].dress15},${branchName[0].dress16},${branchName[0].dress17},${branchName[0].dress18},${branchName[0].dress19}\r\n" +
        "${branchName[0].dress20},${branchName[0].dress21},${branchName[0].dress22},${branchName[0].dress23},${branchName[0].dress24},${branchName[0].spdress},${branchName[0].vspdress},${branchName[0].vvspdress}\r\n";
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
  _importBackUp(BuildContext context) async {
    Branch _branch = Branch(
      _nameBranch,
      _bGreenData,
      _aGreenData,
      _memberData,
      _count,
      _payType,
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
      _branch.name = data[0].toString().trimLeft();
      _branch.bGreen = int.parse(data[1]);
      _branch.aGreen = int.parse(data[2]);
      _branch.member = int.parse(data[3]);
      _branch.count = int.parse(data[4]);
      _branch.payType = int.parse(data[5]);
      studentLength = int.parse(data[6]);
      entryLength = int.parse(data[7]);
      data = res[1];
      _branch.eOrange = int.parse(data[0]);
      _branch.eYellow = int.parse(data[1]);
      _branch.eGreen = int.parse(data[2]);
      _branch.eBlue = int.parse(data[3]);
      _branch.ePurple = int.parse(data[4]);
      _branch.eBrown3 = int.parse(data[5]);
      _branch.eBrown2 = int.parse(data[6]);
      _branch.eBrown1 = int.parse(data[7]);
      _branch.eBlack = int.parse(data[8]);
      data = res[2];
      _branch.kickpad = int.parse(data[0]);
      _branch.gloves = int.parse(data[1]);
      _branch.footguard = int.parse(data[2]);
      _branch.chestguard = int.parse(data[3]);
      _branch.card = int.parse(data[4]);
      data = res[3];
      _branch.dress12 = int.parse(data[0]);
      _branch.dress13 = int.parse(data[1]);
      _branch.dress14 = int.parse(data[2]);
      _branch.dress15 = int.parse(data[3]);
      _branch.dress16 = int.parse(data[4]);
      _branch.dress17 = int.parse(data[5]);
      _branch.dress18 = int.parse(data[6]);
      _branch.dress19 = int.parse(data[7]);
      data = res[4];
      _branch.dress20 = int.parse(data[0]);
      _branch.dress21 = int.parse(data[1]);
      _branch.dress22 = int.parse(data[2]);
      _branch.dress23 = int.parse(data[3]);
      _branch.dress24 = int.parse(data[4]);
      _branch.spdress = int.parse(data[5]);
      _branch.vspdress = int.parse(data[6]);
      _branch.vvspdress = int.parse(data[7]);
      _databaseBranch.insertName(_branch);

      for (int i = 5; i <= studentLength + 4; i++) {
        Student _student = Student(_rollStd, _nameStd, _dob, _branchStd, _belt,
            _fee, _fromFee, _num, _gender, _advBalStd, _memberStd);

        List<dynamic> row = res[i];
        _student.roll = int.parse(row[0]);
        _student.name = row[1].toString().trimLeft();
        _student.dob = row[2].toString().trimLeft();
        _student.number = row[3].toString().trimLeft();
        _student.gender = int.parse(row[4]);
        _student.fee = row[5].toString().trimLeft();
        _student.fromFee = row[6].toString().trimLeft();
        _student.branch = row[7].toString().trimLeft();
        _student.belt = int.parse(row[8]);
        _student.advBal = int.parse(row[9]);
        _student.member = int.parse(row[10]);
        _databaseStudent.insertStudent(_student);

        print("added ${_student.name}");
      }

      for (int i = studentLength + 5; i <= entryLength + 5; i++) {
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
        _entry.name = data[1].toString().trimLeft();
        _entry.branch = data[2].toString().trimLeft();
        _entry.advBal = data[3].toString().trimLeft();
        _entry.date = data[4].toString().trimLeft();
        _entry.detailedReason = data[5].toString().trimLeft();
        _entry.pending = data[6].toString().trimLeft();
        _entry.reason = data[7].toString().trimLeft();
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
    Flushbar(
      aroundPadding: EdgeInsets.all(8.0),
      borderRadius: 8,
      message: message,
      duration: Duration(seconds: 2),
    )..show(context);
  }
}

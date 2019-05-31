import 'dart:async';
import 'package:flutter/material.dart';
import 'package:karate/databases/entry_data.dart';
import 'package:karate/databases/student_data.dart';
import 'package:karate/models/entry.dart';
import 'package:karate/models/student.dart';
import 'package:sqflite/sqflite.dart';

class StudentDetail extends StatefulWidget {
  final Student _student;

  StudentDetail(this._student);
  @override
  _StudentDetailState createState() => _StudentDetailState(this._student);
}

class _StudentDetailState extends State<StudentDetail> {
  static String _name, _fee, _dob, _fromFee, _branch, _num;
  static int _roll, _belt, _genderData, _advBal, _member;
  Student _student = Student(_roll, _name, _dob, _branch, _belt, _fee, _fromFee,
      _num, _genderData, _advBal, _member);
  Entry entry;
  DatabaseEntry _databaseEntry = DatabaseEntry();
  DatabaseStudent _databaseStudent = DatabaseStudent();

  _StudentDetailState(this._student);

  List<Entry> entryList, updatedList, branchList;

  var _memberQ = ["Yes", "No"];
  var _belts = [
    "White",
    "Orange",
    "Yellow",
    "Green",
    "Blue",
    "Purple",
    "Brown 3",
    "Brown 2",
    "Brown 1",
    "Black"
  ];

  @override
  void initState() {
    super.initState();
    if (entryList == null) {
      entryList = List<Entry>();
      branchList = List<Entry>();
      updateEntryList();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (entryList == null) {
      entryList = List<Entry>();
      branchList = List<Entry>();
      updateEntryList();
    }

    updatedList = entryList;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(_student.name),
              background: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Roll No. : ${_student.roll}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        "Branch : ${_student.branch}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        "Number : ${_student.number}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Belt : ${_belts[_student.belt]}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        "Fee Paid Till : ${_student.fee}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        "Member : ${_memberQ[_student.member]}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Card(
                  elevation: 3.0,
                  child: ListTile(
                    title: Text(this.updatedList[index].name),
                    trailing: IconButton(
                      icon: Icon(Icons.delete,
                          color: Theme.of(context).primaryColor),
                      onPressed: () {
                        _removeEntry(this.updatedList[index]);
                      },
                    ),
                    subtitle: Text(
                        "${this.updatedList[index].date}  ${this.updatedList[index].reason}  ${this.updatedList[index].total}"),
                    onTap: () {
                      _showSnapshot(updatedList[index]);
                    },
                  ),
                );
              },
              childCount: updatedList.length,
            ),
          ),
        ],
      ),
    );
  }

// remove entry
  _removeEntry(Entry entry) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
            title: Text('Delete'),
            content: Column(
              children: <Widget>[
                Text(
                    "Do you really want to delete entry of ${this.entry.name} ?"),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      width: 70.0,
                      child: RaisedButton(
                        child: Text("Cancel"),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    SizedBox(
                      width: 70.0,
                      child: RaisedButton(
                        child: Text('Yes'),
                        onPressed: () {
                          Navigator.pop(context);
                          _databaseEntry.deleteEntry(entry.id);
                          updateEntryList();
                          checkNUpdateStudData(entry);
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
    );
  }

  // snapshot
  _showSnapshot(Entry entry) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
            content: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Roll No. : ${entry.roll}"),
                Text("Name : ${entry.name}"),
                Text("Branch : ${entry.branch}"),
                Text("Reason : ${entry.reason}"),
                Text("Detalied Reason : ${entry.detailedReason}"),
                Text("Date of Entry : ${entry.date}"),
                Text("Adv/Bal : ${entry.advBal}"),
                Text("Total : ${entry.total}"),
                RaisedButton(
                  child: Center(
                    child: Icon(Icons.edit),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.popAndPushNamed(context, "WrkPrgs");
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) {
                    //       return AddEntry(
                    //           _student, _branch, entry, "Edit Entry");
                    //     },
                    //   ),
                    // );
                  },
                )
              ],
            ),
          ),
    );
  }

  void checkNUpdateStudData(Entry _entry) async {
    List temp;

    int _month, _year;

    if (_entry.advBal != "0") {
      _student.advBal = 0;
      _databaseStudent.updateStudent(_student);
    }

    if (_entry.reason.startsWith("Monthly")) {
      temp = _entry.detailedReason.split(",");

      List temp1 = _student.fee.split("/");

      print(1);
      if (int.parse(temp1[0]) - temp.length < 0) {
        _month = int.parse(temp1[0]) - temp.length + 12;
        _year = int.parse(temp1[1]) - 1;
      } else {
        print(1);
        _month = int.parse(temp1[0]) - temp.length;
        _year = int.parse(temp1[1]);
      }
      print(1);
      _student.fee = "$_month/$_year";

      print(temp.length);
      print(_student.fee);
      _databaseStudent.updateStudent(_student);
    } else if (_entry.reason == "Examination") {
      _student.belt--;
      _databaseStudent.updateStudent(_student);
    }
  }

  void updateEntryList() {
    final Future<Database> dbFuture = _databaseEntry.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Entry>> studentListFuture = _databaseEntry.getEntryList();
      studentListFuture.then((list) {
        this.entryList = list;
      });
    });
  }
}

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:karate/databases/student_data.dart';
import 'package:karate/models/branch.dart';
import 'package:karate/models/student.dart';
import 'package:karate/pages/student_details.dart';
import 'package:sqflite/sqlite_api.dart';

class StudentList extends StatefulWidget {
  final String branch;
  final Branch _branchData;
  StudentList(this.branch, this._branchData);
  @override
  _StudentListState createState() => _StudentListState(branch, _branchData);
}

class _StudentListState extends State<StudentList> {
  static String _name, _nameBranch, _fee, _dob, _fromFee, _branch, _num;
  static int _roll,
      _belt,
      _genderData,
      _advBal,
      _member,
      _bGreen,
      _aGreen,
      _memberBranch,
      _count,
      _payType;

  _StudentListState(this.branch, this._branchData);
  List<Student> studentList, updatedList;
  int count;
  String branch;
  Branch _branchData =
      Branch(_nameBranch, _bGreen, _aGreen, _memberBranch, _count, _payType);

  Student student = Student(_roll, _name, _dob, _branch, _belt, _fee, _fromFee,
      _num, _genderData, _advBal, _member);

  DatabaseStudent _data = DatabaseStudent();
  @override
  void initState() {
    super.initState();
    setState(() {
      if (studentList == null) {
        studentList = List<Student>();
        updateStudentList(branch);
      }
      updatedList = branch != ""
          ? studentList.where((p) => p.branch.startsWith(branch)).toList()
          : studentList;
    });
  }

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
  Widget build(BuildContext context) {
    if (studentList == null) {
      studentList = List<Student>();
      updateStudentList(branch);
    }
    updatedList = branch != ""
        ? studentList.where((p) => p.branch == branch).toList()
        : studentList;

    return Scaffold(
      appBar: AppBar(
        title: Text('Student List'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: StudentSearch(branch, _branchData));
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: updatedList.length,
        itemBuilder: (BuildContext context, int index) {
          Widget normalCard() {
            return Card(
              elevation: 3.0,
              child: ListTile(
                title: Text(this.updatedList[index].name),
                trailing: IconButton(
                  icon:
                      Icon(Icons.delete, color: Theme.of(context).primaryColor),
                  onPressed: () {
                    setState(() {
                      _removeStudent(updatedList[index], index);
                    });
                  },
                ),
                subtitle: Text(
                    "${this.updatedList[index].branch}  ${this.updatedList[index].number}  ${_belts[this.updatedList[index].belt]}  ${this.updatedList[index].fee}"),
                onTap: () async {
                  print(this.updatedList[index].fee);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          StudentDetail(updatedList[index], _branchData),
                    ),
                  );
                },
              ),
            );
          }

          Widget cardWithBelt(String belt) {
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    belt,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                normalCard(),
              ],
            );
          }

          return index == 0
              ? cardWithBelt(_belts[updatedList[index].belt])
              : updatedList[index - 1].belt == updatedList[index].belt
                  ? normalCard()
                  : cardWithBelt(_belts[updatedList[index].belt]);
        },
      ),
    );
  }

  void updateStudentList(String branch) {
    final Future<Database> dbFuture = _data.initializeStudentDatabase();
    dbFuture.then((database) {
      Future<List<Student>> studentListFuture = _data.getNameList();
      studentListFuture.then((list) {
        setState(() {
          this.studentList = list;
        });
      });
    });
  }

  _removeStudent(Student student, int index) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
            title: Text('Delete'),
            content: Column(
              children: <Widget>[
                Text(
                    "Do you really want to delete ${this.studentList[index].name} ?"),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      width: 70.0,
                      child: RaisedButton(
                          child: Text("Cancel"),
                          onPressed: () =>
                              setState(() => Navigator.pop(context))),
                    ),
                    SizedBox(
                      width: 70.0,
                      child: RaisedButton(
                        child: Text('Yes'),
                        onPressed: () {
                          Navigator.pop(context);
                          _data.deleteStudent(student.id);
                          updateStudentList(branch);
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
}

class StudentSearch extends SearchDelegate<String> {
  StudentSearch(this.branch, this._branchData);
  List<Student> studentList, updatedList;
  int count;
  String branch;

  Branch _branchData;

  Student student;
  DatabaseStudent _data = DatabaseStudent();

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
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (studentList == null) {
      studentList = List<Student>();
      updateStudentList(branch);
    }
    updatedList = branch != ""
        ? studentList.where((p) => p.branch == branch).toList()
        : studentList;

    List<Student> suggestedList = query.isEmpty
        ? updatedList
        : updatedList
            .where(
                (sug) => sug.name.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
    return ListView.builder(
      itemCount: suggestedList.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          elevation: 3.0,
          child: ListTile(
            title: Text(suggestedList[index].name),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Theme.of(context).primaryColor),
              onPressed: () {
                _removeStudent(suggestedList[index], index, context);
              },
            ),
            subtitle: Text(
                "${suggestedList[index].branch}  ${suggestedList[index].number}  ${_belts[suggestedList[index].belt]}  ${suggestedList[index].fee}"),
            onTap: () async {
              Student _student = await _data.getStudent(
                  suggestedList[index].roll, suggestedList[index].branch);
              print(_student.name);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      StudentDetail(updatedList[index], _branchData),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void updateStudentList(String branch) {
    final Future<Database> dbFuture = _data.initializeStudentDatabase();
    dbFuture.then((database) {
      Future<List<Student>> studentListFuture = _data.getNameList();
      studentListFuture.then((list) {
        this.studentList = list;
      });
    });
  }

  _removeStudent(Student student, int index, BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
            title: Text('Delete'),
            content: Column(
              children: <Widget>[
                Text(
                    "Do you really want to delete ${this.studentList[index].name} ?"),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      width: 70.0,
                      child: RaisedButton(
                          child: Text("Cancel"),
                          onPressed: () => Navigator.pop(context)),
                    ),
                    SizedBox(
                      width: 70.0,
                      child: RaisedButton(
                        child: Text('Yes'),
                        onPressed: () {
                          Navigator.pop(context);
                          _data.deleteStudent(student.id);
                          updateStudentList(branch);
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
}

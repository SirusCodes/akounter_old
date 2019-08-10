import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:karate/databases/branch_data.dart';
import 'package:karate/databases/entry_data.dart';
import 'package:karate/databases/import_export.dart';
import 'package:karate/databases/student_data.dart';
import 'package:karate/models/branch.dart';
import 'package:karate/models/student.dart';
import 'package:karate/pages/add_entry.dart';
import 'package:karate/pages/lists/entry_list.dart';
import 'package:karate/pages/lists/student_list.dart';
import 'package:karate/widgets/widgets.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:karate/pages/add_branch.dart';
import 'package:karate/pages/add_student.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static String _name;
  static int _bGreenData, _aGreenData, _memberData, _count, _payTypeData;
  TextEditingController addBranchController = TextEditingController();
  DatabaseBranch data = DatabaseBranch();
  int index;
  var selectedBranch = "";
  List<Branch> branchName;
  Branch _branchData = Branch(
      _name, _bGreenData, _aGreenData, _memberData, _count, _payTypeData);

//change selected branch
  Future changeBranch(String _name) async {
    selectedBranch = _name;
  }

// batch delete
  DatabaseStudent _databaseStudent = DatabaseStudent();
  DatabaseEntry _databaseEntry = DatabaseEntry();
//change welcome tag
  Widget newText(String selectedBranch, Color cColor) {
    if (selectedBranch == "") {
      selectedBranch = "none";
    }
    return Text(
      "The Selected Branch is $selectedBranch",
      style:
          TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, color: cColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (branchName == null) {
      branchName = List<Branch>();
      _updateBranchList();
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Home"),
      ),
      drawer: buildDrawer(context),
      //buttons
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: newText(selectedBranch, Colors.black),
              ),
            ),
            //buttons
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  //add student button
                  Container(
                    margin: EdgeInsets.all(10.0),
                    width: 100.0,
                    height: 100.0,
                    child: RaisedButton(
                      elevation: 3.0,
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0)),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 25.0),
                            ),
                            Icon(
                              Icons.group_add,
                              color: Colors.white,
                            ),
                            Text(
                              "Add Student",
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                      onPressed: () {
                        selectedBranch == ""
                            ? Navigator.pushNamed(context, "SelBrnch")
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddStudent(
                                      Student(null, "", "", "", null, null,
                                          null, "", null, null, null),
                                      _branchData,
                                      'Add Student'),
                                ),
                              );
                      },
                    ),
                  ),
                  //add entry button
                  Container(
                    margin: EdgeInsets.all(10.0),
                    width: 100.0,
                    height: 100.0,
                    child: RaisedButton(
                      elevation: 3.0,
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0)),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 25.0),
                            ),
                            Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            Text(
                              "Add Entry",
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                      onPressed: () {
                        selectedBranch == ""
                            ? Navigator.pushNamed(context, "SelBrnch")
                            : showSearch(
                                context: context,
                                delegate: StudentSearchEntry(_branchData),
                              );
                      }, //   action here
                    ),
                  ),
                ],
              ),
            ),
            //branches maker
            Expanded(
              flex: 5,
              child: Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: branchName.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 3.0,
                      child: ListTile(
                        title: Text(
                          branchName[index].name,
                          style: TextStyle(color: Colors.black),
                        ),
                        leading: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddBranch(branchName[index]),
                            ),
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete,
                              color: Theme.of(context).primaryColor),
                          onPressed: () {
                            setState(() {
                              data.deleteName(branchName[index].id);
                              _databaseStudent
                                  .deleteBranchStud(branchName[index].name);
                              _databaseEntry
                                  .deleteBranchEntry(branchName[index].name);
                              _showSnackBar(
                                  context, "Restart the app to see changes");
                              _updateBranchList();
                            });
                          },
                        ),
                        onTap: () {
                          _showSnackBar(
                              context, "${branchName[index].name} is selected");
                          setState(
                            () {
                              print(branchName[index].eOrange);
                              _branchData = branchName[index];
                              changeBranch(branchName[index].name);
                              newText(branchName[index].name, Colors.black);
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Details(),
            )
          ],
        ),
      ),
    );
  }

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          //welcome
          SafeArea(
            child: Container(
              height: 70.0,
              color: Theme.of(context).primaryColor,
              child: Center(child: newText(selectedBranch, Colors.white)),
            ),
          ),
          //add branch
          ListTile(
            title: Text("Add Branch"),
            leading: Icon(Icons.add_box),
            onTap: () {
              Navigator.pop(context);
              navigateToAddBranch(Branch("", null, null, null, null, 0));
            },
          ),
          //add student director
          ListTile(
            title: Text("Add a Student"),
            leading: Icon(Icons.group_add),
            onTap: () {
              Navigator.pop(context);
              selectedBranch == ""
                  ? Navigator.pushNamed(context, "SelBrnch")
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddStudent(
                            Student(null, "", "", "", null, null, null, "",
                                null, null, null),
                            _branchData,
                            'Add Student'),
                      ),
                    );
            },
          ),
          //add entry
          ListTile(
            title: Text("Add Entry"),
            leading: Icon(Icons.add),
            onTap: () {
              Navigator.pop(context);
              selectedBranch == ""
                  ? Navigator.pushNamed(context, "SelBrnch")
                  : showSearch(
                      context: context,
                      delegate: StudentSearchEntry(_branchData));
            },
          ),
          //expansion for lists
          ExpansionTile(
            title: Text("Lists"),
            leading: Icon(Icons.list),
            children: <Widget>[
              //student list action
              ListTile(
                title: Text("Student List"),
                leading: Icon(Icons.group),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          StudentList(selectedBranch, _branchData),
                    ),
                  );
                },
              ),
              //entry list action
              ListTile(
                title: Text("Entry List"),
                leading: Icon(Icons.list),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EntryList(
                        Student(null, "", '', selectedBranch, null, null, null,
                            "", null, null, null),
                        _branchData,
                      ),
                    ),
                  );
                },
              )
            ],
          ),
          // import export
          ListTile(
              title: Text('Import/Export'),
              leading: Icon(Icons.import_export),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExpoImpo(selectedBranch),
                  ),
                );
              })
        ],
      ),
    );
  }

  void _updateBranchList() {
    final Future<Database> dbFuture = data.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Branch>> branchListFuture = data.getNameList();
      branchListFuture.then((list) {
        setState(() {
          this.branchName = list;
        });
      });
    });
  }

  // show snackbar
  void _showSnackBar(BuildContext context, String message) {
    Flushbar(
      margin: EdgeInsets.all(8.0),
      borderRadius: 8,
      message: message,
      duration: Duration(seconds: 2),
    )..show(context);
  }

  void navigateToAddBranch(Branch branch) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddBranch(branch);
    }));
    if (result == true) {
      _updateBranchList();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:karate/databases/branch_data.dart';
import 'package:karate/databases/import_export.dart';
import 'package:karate/models/branch.dart';
import 'package:karate/models/student.dart';
import 'package:karate/pages/add_entry.dart';
import 'package:karate/pages/lists/entry_list.dart';
import 'package:karate/pages/lists/student_list.dart';
import 'package:karate/widgets/widgets.dart';
import 'package:karate/pages/add_branch.dart';
import 'package:karate/pages/add_student.dart';

class MainPage extends StatefulWidget {
  final Branch branch;
  MainPage([this.branch]);

  @override
  State<StatefulWidget> createState() => _MainPageState(this.branch);
}

class _MainPageState extends State<MainPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static String _name;
  static int _bGreenData, _aGreenData, _memberData, _count, _payTypeData;
  TextEditingController addBranchController = TextEditingController();
  DatabaseBranch data = DatabaseBranch();

  var selectedBranch;
  List<Branch> branchName;
  Branch _branchData = Branch(
      _name, _bGreenData, _aGreenData, _memberData, _count, _payTypeData);

  _MainPageState(this._branchData);

  @override
  void initState() {
    super.initState();
    selectedBranch = _branchData.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Home"),
      ),
      drawer: buildDrawer(context),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "The selected branch is $selectedBranch",
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColor),
                  )),
            ),
            // buttons
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
            // spacer
            Expanded(
              flex: 6,
              child: ListView(
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
                            Student(null, "", '', selectedBranch, null, null,
                                null, "", null, null, null),
                            _branchData,
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            // details
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
              child: Center(
                  child: Text("The selected branch is $selectedBranch",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ))),
            ),
          ),
          //add branch
          ListTile(
            title: Text("Add Branch"),
            leading: Icon(Icons.add_box),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddBranch(Branch("", null, null, null, null, 0))));
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
}

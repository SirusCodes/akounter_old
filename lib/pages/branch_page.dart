import 'dart:async';
import 'package:flutter/material.dart';
import 'package:karate/databases/branch_data.dart';
import 'package:karate/databases/entry_data.dart';
import 'package:karate/databases/student_data.dart';
import 'package:karate/models/branch.dart';
import 'package:karate/pages/add_branch.dart';
import 'package:karate/pages/main_page.dart';
import 'package:sqflite/sqflite.dart';

class BranchPage extends StatefulWidget {
  BranchPage({Key key}) : super(key: key);

  @override
  _BranchPageState createState() => _BranchPageState();
}

class _BranchPageState extends State<BranchPage> {
  DatabaseBranch databaseBranch = DatabaseBranch();
  List<Branch> branchList;

  DatabaseStudent _databaseStudent = DatabaseStudent();
  DatabaseEntry _databaseEntry = DatabaseEntry();

  @override
  void initState() {
    _updateBranchList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (branchList == null) {
      branchList = List<Branch>();
      _updateBranchList();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Branches"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddBranch(
                  Branch("", null, null, null, null, 0),
                ),
              ),
            ),
          )
        ],
      ),
      body: _dataDecider(),
    );
  }

  _dataDecider() {
    // if (branchList == null) {
    return buildBranchList();
    // } else {
    //   return buildAddBranchButton();
    // }
  }

  ListView buildBranchList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: branchList.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          elevation: 3.0,
          child: ListTile(
            title: Text(
              branchList[index].name,
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
                  builder: (context) => AddBranch(branchList[index]),
                ),
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Theme.of(context).primaryColor),
              onPressed: () {
                setState(() {
                  databaseBranch.deleteName(branchList[index].id);
                  _databaseStudent.deleteBranchStud(branchList[index].name);
                  _databaseEntry.deleteBranchEntry(branchList[index].name);
                  _updateBranchList();
                });
              },
            ),
            onTap: () {
              print(branchList[index].name);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MainPage(branchList[index])));
            },
          ),
        );
      },
    );
  }

  buildAddBranchButton() {
    return Center(
      child: Container(
        child: IconButton(
          icon: Icon(
            Icons.add,
            size: 100.0,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () =>
              navigateToAddBranch(Branch(null, null, null, null, null, null)),
        ),
      ),
    );
  }

  void _updateBranchList() {
    final Future<Database> dbFuture = databaseBranch.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Branch>> branchListFuture = databaseBranch.getNameList();
      branchListFuture.then((list) {
        setState(() {
          this.branchList = list;
        });
      });
    });
  }

  // navigate to addbranch
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

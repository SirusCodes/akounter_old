import 'package:flutter/material.dart';
import 'package:karate/models/branch.dart';
import 'package:karate/widgets/widgets.dart';
import 'package:karate/databases/branch_data.dart';

class AddBranch extends StatefulWidget {
  final Branch branch;
  AddBranch(this.branch);
  @override
  _AddBranchState createState() => _AddBranchState(this.branch);
}

class _AddBranchState extends State<AddBranch> {
  var _addBranchFormKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController bGreenController = TextEditingController();
  TextEditingController aGreenController = TextEditingController();
  TextEditingController memberController = TextEditingController();
  static String _name;
  static int _bGreen, _aGreen, _member, _count;
  EdgeInsets _padding = EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0);

  DatabaseBranch data = DatabaseBranch();
  var branch = Branch(_name, _bGreen, _aGreen, _member, _count);

  _AddBranchState(this.branch);
  @override
  void initState() {
    super.initState();
    if (branch.id != null) {
      nameController.text = branch.name;
      aGreenController.text = branch.aGreen.toString();
      bGreenController.text = branch.bGreen.toString();
      memberController.text = branch.member.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: cAppBar(context, "Add Branch"),
      body: Form(
        key: _addBranchFormKey,
        child: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // name
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(color: Colors.black),
                    controller: nameController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter a proper name!";
                      }
                    },
                    onSaved: (value) {
                      branch.name = value;
                    },
                    decoration: InputDecoration(
                      hintText: "Branch Name",
                      hintStyle: TextStyle(color: Colors.black26),
                      labelText: "Name",
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 10.0,
                        ),
                      ),
                    ),
                  ),
                ),
                // bgreen
                Padding(
                  padding: _padding,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.black),
                    controller: bGreenController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter Monthly fee before Green";
                      }
                    },
                    onSaved: (value) {
                      branch.bGreen = int.parse(value);
                    },
                    decoration: InputDecoration(
                      hintText: "350",
                      hintStyle: TextStyle(color: Colors.black26),
                      labelText: "Before Green",
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 10.0,
                        ),
                      ),
                    ),
                  ),
                ),
                // agreen
                Padding(
                  padding: _padding,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.black),
                    controller: aGreenController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter Monthly fee after Green";
                      }
                    },
                    onSaved: (value) {
                      branch.aGreen = int.parse(value);
                    },
                    decoration: InputDecoration(
                      hintText: "400",
                      hintStyle: TextStyle(color: Colors.black26),
                      labelText: "After Green",
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 10.0,
                        ),
                      ),
                    ),
                  ),
                ),
                // member
                Padding(
                  padding: _padding,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.black),
                    controller: memberController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter member discount(if not then 0)";
                      }
                    },
                    onSaved: (value) {
                      branch.member = int.parse(value);
                    },
                    decoration: InputDecoration(
                      hintText: "50",
                      hintStyle: TextStyle(color: Colors.black26),
                      labelText: "Member Discount",
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 10.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.check),
          onPressed: () {
            setState(() {
              if (_addBranchFormKey.currentState.validate()) {
                _addBranchFormKey.currentState.save();
                _save();
              }
            });
          }),
    );
  }

  void _save() async {
    branch.count = 0;
    Navigator.pop(context, true);
    branch.id == null
        ? await data.insertName(branch)
        : await data.updateName(branch);
    print("done");
  }
}

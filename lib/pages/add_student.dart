import 'dart:async';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:karate/databases/branch_data.dart';
import 'package:karate/models/branch.dart';
import 'package:karate/models/student.dart';
import 'package:karate/databases/student_data.dart';
import 'package:karate/pages/lists/student_list.dart';

class AddStudent extends StatefulWidget {
  final Student _student;
  final Branch _branchData;
  final String title;
  AddStudent(this._student, this._branchData, this.title);
  @override
  State<StatefulWidget> createState() =>
      _AddStudentState(this._student, this._branchData, this.title);
}

class _AddStudentState extends State<AddStudent> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _addStudentKey = GlobalKey<FormState>();
  static String _name, _dob, _fee, _fromFee, _branch, _num;
  static int _roll,
      _belt,
      _gender,
      _advBal,
      _member,
      _memberStud,
      _bGreen,
      _aGreen,
      _count,
      _payType;
  String title;

  var _student = Student(
    _roll,
    _name,
    _dob,
    _branch,
    _belt,
    _fee,
    _fromFee,
    _num,
    _gender,
    _advBal,
    _memberStud,
  );
  DatabaseStudent _data = DatabaseStudent();
  DatabaseBranch _databaseBranch = DatabaseBranch();
  var _branchData = Branch(_name, _bGreen, _aGreen, _member, _count, _payType);

  _AddStudentState(this._student, this._branchData, this.title);

  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  TextEditingController numController = TextEditingController();

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
  var _months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  var _genders = ['Male', 'Female'];
  var _memberQ = ["Yes", "No"];

  var _currentBeltSelected = "";
  var _currentMonthSelected = "";
  var _currentGenderSelected = "";
  var _currentMonthSelectedFrom = "";
  var _currentMemberSelected = "";

  @override
  void initState() {
    super.initState();
    if (_student.id != null) {
      List temp, temp1;
      temp = _student.fee.split("/");
      temp1 = _student.fromFee.split("/");
      nameController.text = _student.name;
      dobController.text = _student.dob;
      numController.text = _student.number;
      branchController.text = _student.branch;
      _currentBeltSelected = _belts[_student.belt];
      _currentMonthSelected = _months[int.parse(temp[0]) - 1];
      _currentGenderSelected = _genders[_student.gender];
      _currentMonthSelectedFrom = _months[int.parse(temp1[0]) - 1];
      _currentMemberSelected = _memberQ[_student.member];
    } else {
      branchController.text = _branchData.name;
      _currentMonthSelected = _months[0];
      _currentBeltSelected = _belts[0];
      _currentGenderSelected = _genders[0];
      _currentMonthSelectedFrom = _months[0];
      _currentMemberSelected = _memberQ[1];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        StudentList(_branchData.name, _branchData),
                  ),
                ),
            tooltip: 'to list',
          )
        ],
      ),
      body: Form(
        key: _addStudentKey,
        child: ListView(
          children: [
            //name
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                key: Key('name'),
                controller: nameController,
                textCapitalization: TextCapitalization.words,
                style: TextStyle(color: Colors.black),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Enter a valid name!";
                  }
                },
                onSaved: (value) {
                  _student.name = value;
                },
                decoration: InputDecoration(
                  hintText: "Name Surname",
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
            //DOB
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.datetime,
                      key: Key('DOB'),
                      controller: dobController,
                      style: TextStyle(color: Colors.black),
                      // validator: (value) {
                      //   List temp;
                      //   temp = value.split("/");
                      //   String tempStr = temp[2];
                      //   if (temp.length != 3 || tempStr.length != 4) {
                      //     return "Write DOB in DD/MM/YYYY format!";
                      //   }
                      // },
                      onSaved: (value) {
                        _student.dob = value;
                      },
                      decoration: InputDecoration(
                        hintText: "DD/MM/YYYY",
                        hintStyle: TextStyle(color: Colors.black26),
                        labelText: "Date Of Birth",
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
                  IconButton(
                    icon: Icon(Icons.date_range),
                    onPressed: () => _selectDate(context),
                  )
                ],
              ),
            ),
            // phone number
            Padding(
              padding:
                  const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                key: Key('number'),
                controller: numController,
                textCapitalization: TextCapitalization.words,
                style: TextStyle(color: Colors.black),
                // validator: (value) {
                //   if (value.length != 10) {
                //     return "Given Phone No. is incorrect!";
                //   }
                // },
                onSaved: (value) {
                  _student.number = value;
                },
                decoration: InputDecoration(
                  hintText: "1234567890",
                  hintStyle: TextStyle(color: Colors.black26),
                  labelText: "Mobile Number",
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
            //branch selected
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                key: Key('branch'),
                controller: branchController,
                textCapitalization: TextCapitalization.words,
                style: TextStyle(color: Colors.black),
                validator: (value) {
                  if (value != _branchData.name) {
                    return "Please select branch from home page!!";
                  }
                },
                onSaved: (value) {
                  _student.branch = value;
                },
                decoration: InputDecoration(
                  hintText: "Branch Name",
                  hintStyle: TextStyle(color: Colors.black26),
                  labelText: "Branch Name",
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
            //current belt
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Current Belt: "),
                DropdownButton<String>(
                  key: Key('cbelt'),
                  items: _belts.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  value: _currentBeltSelected,
                  onChanged: (String newBeltSelected) {
                    setState(() {
                      belt(newBeltSelected);
                      this._currentBeltSelected = newBeltSelected;
                    });
                  },
                ),
              ],
            ),
            //fee paid till
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Fee paid till: "),
                DropdownButton(
                  items: _months.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  value: _currentMonthSelected,
                  onChanged: (String newMonthSelected) {
                    setState(() {
                      month(newMonthSelected);
                      _currentMonthSelected = newMonthSelected;
                    });
                  },
                )
              ],
            ),
            // record started from
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Fee paid from: "),
                DropdownButton(
                  items: _months.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  value: _currentMonthSelectedFrom,
                  onChanged: (String newMonthSelectedFrom) {
                    setState(() {
                      monthFrom(newMonthSelectedFrom);
                      this._currentMonthSelectedFrom = newMonthSelectedFrom;
                    });
                  },
                )
              ],
            ),
            //Gender
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Gender: "),
                DropdownButton(
                  items: _genders.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  value: _currentGenderSelected,
                  onChanged: (String newGenderSelected) {
                    setState(() {
                      this._currentGenderSelected = newGenderSelected;
                      gender(newGenderSelected);
                    });
                  },
                )
              ],
            ),
            // Member
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Member :"),
                DropdownButton(
                  items: _memberQ.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  value: _currentMemberSelected,
                  onChanged: (String newMemberSelected) {
                    setState(() {
                      _currentMemberSelected = newMemberSelected;
                      member(newMemberSelected);
                    });
                  },
                )
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Center(
          child: Icon(Icons.check),
        ),
        onPressed: () {
          if (_addStudentKey.currentState.validate()) {
            _addStudentKey.currentState.save();
            _save();
          }
        },
      ),
    );
  }

  //date selector
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dobController.text = DateFormat("dd/MM/yyyy").format(picked);
    }
  }

  //save data
  _save() async {
    int result;

    _student.advBal = 0;

    if (_student.belt == null) {
      _student.belt = 0;
    }

    if (_student.fee == null) {
      _student.fee = "01/" + DateFormat("yyyy").format(DateTime.now());
    }
    if (_student.fromFee == null) {
      _student.fromFee = "01/" + DateFormat("yyyy").format(DateTime.now());
    }

    if (_student.gender == null) {
      _student.gender = 0;
    }

    if (_student.branch.isEmpty) {
      _student.branch = _branchData.name;
    }

    if (_student.member == null) {
      _student.member = 1;
    }

    _student.dob = _student.dob ?? "";
    _student.number = _student.number ?? "";

    if (_student.id != null) {
      result = await _data.updateStudent(_student);
      print('updated');
    } else {
      _branchData.count = _branchData.count + 1;
      _student.roll = _branchData.count;
      await _databaseBranch.updateName(_branchData);
      result = await _data.insertStudent(_student);
      print('inserted');
    }
    print(_branchData.count);
    result == 1 ? debugPrint('saved') : debugPrint('fail');

    if (result != 0) {
      _showSnackBar(context, '${nameController.text} is saved/updated!');
    } else {
      _showSnackBar(context, 'Problem Saving Data');
    }
    setState(() {
      _reset();
    });
  }

  //reset text
  _reset() {
    nameController.text = "";
    dobController.text = "";
    numController.text = "";
    _currentBeltSelected = _belts[0];
    _currentMonthSelected = _months[0];
    _currentGenderSelected = _genders[0];
    _currentMonthSelectedFrom = _months[0];
    _currentMemberSelected = _memberQ[1];
    _student.name = "";
    _student.dob = "";
    _student.number = "";
    _student.belt = null;
    _student.fee = null;
    _student.gender = null;
    _student.fromFee = null;
    _student.member = null;
  }

  //snackbar
  void _showSnackBar(BuildContext context, String message) {
    Flushbar(
      aroundPadding: EdgeInsets.all(8.0),
      borderRadius: 8,
      message: message,
      duration: Duration(seconds: 2),
    )..show(context);
  }

  //belt to belt no.
  void belt(String belt) {
    switch (belt) {
      case 'White':
        _student.belt = 0;
        break;
      case 'Orange':
        _student.belt = 1;
        break;
      case 'Yellow':
        _student.belt = 2;
        break;
      case 'Green':
        _student.belt = 3;
        break;
      case 'Blue':
        _student.belt = 4;
        break;
      case 'Purple':
        _student.belt = 5;
        break;
      case 'Brown 3':
        _student.belt = 6;
        break;
      case 'Brown 2':
        _student.belt = 7;
        break;
      case 'Brown 1':
        _student.belt = 8;
        break;
      case 'Black':
        _student.belt = 9;
        break;
    }
  }

  //months to no.
  void month(String month) {
    switch (month) {
      case 'January':
        _student.fee = "01/" + DateFormat("yyyy").format(DateTime.now());
        break;
      case 'February':
        _student.fee = "02/" + DateFormat("yyyy").format(DateTime.now());
        break;
      case 'March':
        _student.fee = "03/" + DateFormat("yyyy").format(DateTime.now());
        break;
      case 'April':
        _student.fee = "04/" + DateFormat("yyyy").format(DateTime.now());
        break;
      case 'May':
        _student.fee = "05/" + DateFormat("yyyy").format(DateTime.now());
        break;
      case 'June':
        _student.fee = "06/" + DateFormat("yyyy").format(DateTime.now());
        break;
      case 'July':
        _student.fee = "07/" + DateFormat("yyyy").format(DateTime.now());
        break;
      case 'August':
        _student.fee = "08/" + DateFormat("yyyy").format(DateTime.now());
        break;
      case 'September':
        _student.fee = "09/" + DateFormat("yyyy").format(DateTime.now());
        break;
      case 'October':
        _student.fee = "10/" + DateFormat("yyyy").format(DateTime.now());
        break;
      case 'November':
        _student.fee = "11/" + DateFormat("yyyy").format(DateTime.now());
        break;
      case 'December':
        _student.fee = "12/" + DateFormat("yyyy").format(DateTime.now());
        break;
    }
  }

  // months from
  void monthFrom(String month) {
    switch (month) {
      case 'January':
        _student.fromFee = "01/" + DateFormat("yyyy").format(DateTime.now());
        break;
      case 'February':
        _student.fromFee = "02/" + DateFormat("yyyy").format(DateTime.now());
        break;
      case 'March':
        _student.fromFee = "03/" + DateFormat("yyyy").format(DateTime.now());
        break;
      case 'April':
        _student.fromFee = "04/" + DateFormat("yyyy").format(DateTime.now());
        break;
      case 'May':
        _student.fromFee = "05/" + DateFormat("yyyy").format(DateTime.now());
        break;
      case 'June':
        _student.fromFee = "06/" + DateFormat("yyyy").format(DateTime.now());
        break;
      case 'July':
        _student.fromFee = "07/" + DateFormat("yyyy").format(DateTime.now());
        break;
      case 'August':
        _student.fromFee = "08/" + DateFormat("yyyy").format(DateTime.now());
        break;
      case 'September':
        _student.fromFee = "09/" + DateFormat("yyyy").format(DateTime.now());
        break;
      case 'October':
        _student.fromFee = "10/" + DateFormat("yyyy").format(DateTime.now());
        break;
      case 'November':
        _student.fromFee = "11/" + DateFormat("yyyy").format(DateTime.now());
        break;
      case 'December':
        _student.fromFee = "12/" + DateFormat("yyyy").format(DateTime.now());
        break;
    }
  }

  //gender to no.
  void gender(String value) {
    if (value == "Male") {
      _student.gender = 0;
    } else {
      _student.gender = 1;
    }
  }

  // member to no.
  void member(String value) {
    value == "Yes" ? _student.member = 0 : _student.member = 1;
  }
}

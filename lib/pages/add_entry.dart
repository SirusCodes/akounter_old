import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:karate/databases/entry_data.dart';
import 'package:karate/databases/student_data.dart';
import 'package:karate/models/branch.dart';
import 'package:karate/models/entry.dart';
import 'package:karate/models/student.dart';
import 'package:karate/pages/lists/entry_list.dart';
import 'package:sqflite/sqflite.dart';

class AddEntry extends StatefulWidget {
  final Student _student;
  final Entry _entry;
  final Branch branch;
  final String _title;
  AddEntry(this._student, this.branch, this._entry, this._title);

  @override
  _AddEntryState createState() =>
      _AddEntryState(this._student, this.branch, this._entry, this._title);
}

class _AddEntryState extends State<AddEntry> {
  // static init
  static String _name,
      _reason,
      _detailedReason,
      _dateEntry,
      _branchentry,
      _fee,
      _fromFee,
      _advBalEntry,
      _dob,
      _nameStd,
      _branchStd,
      _num,
      _uint8list;
  static int _totalEntry,
      _subTotalEntry,
      _roll,
      _rollStd,
      _belt,
      _gender,
      _advBalStd,
      _memberStd;

  // database req
  Entry _entry = Entry(_roll, _name, _totalEntry, _subTotalEntry, _advBalEntry,
      _reason, _detailedReason, _dateEntry, _branchentry, _uint8list);
  Student _student = Student(_rollStd, _nameStd, _dob, _branchStd, _belt, _fee,
      _fromFee, _num, _gender, _advBalStd, _memberStd);
  DatabaseEntry _entrydata = DatabaseEntry();
  DatabaseStudent _databaseStudent = DatabaseStudent();

  Branch _branch;

  bool _monthlyVisible = true,
      _examinationVisible = false,
      _equipVisible = false,
      _dressVisible = false,
      _otherVisible = false,
      _advBalVisible = false,
      _payTypeVisible = false;
  // BoolCheck
  bool _glovesCheck = false,
      _kickpadCheck = false,
      _chestguardCheck = false,
      _footguardCheck = false,
      _spCheck = false,
      _vspCheck = false,
      _vvspCheck = false,
      _advBalCheck = false;

  String _title,
      _date = DateFormat("dd/MM/yyyy").format(DateTime.now()).toString(),
      _examDate = DateFormat("dd/MM/yyyy").format(DateTime.now()).toString(),
      _currentReason = "";

  int _total = 0,
      _subTotal = 0,
      _monthsNoSelected,
      _equipSubTotal = 0,
      _sizeNo = 12,
      _invoiceId,
      _monthlyFee;

  TextEditingController _monthlyController = TextEditingController();
  TextEditingController _advBalController = TextEditingController();
  TextEditingController _dressSizeController = TextEditingController();
  TextEditingController _reasonController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _monthlyIndirectController = TextEditingController();

  List<String> _reasons = [
    'Monthly',
    'Examination',
    'Equipments',
    'Dress',
    'Card',
    'Others'
  ];
  List<int> _monthsNo = [0, 1, 2, 3, 4, 5, 6];
  List<String> _belts = [
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
  List<String> _months = [
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

  @override
  void initState() {
    super.initState();
    _currentReason = _reasons[0];
    _monthsNoSelected = _monthsNo[0];
    _advBalController.text = "0";
    _reasonController.text = "";
    _amountController.text = "";
    checkNUpdate();
  }

  _AddEntryState(this._student, this._branch, this._entry, this._title);

  @override
  Widget build(BuildContext context) {
    if (_advBalController.text.isNotEmpty) {
      _total = _subTotal + int.parse(_advBalController.text);
    } else {
      _advBalController.text = "0";
    }

    // to balance data
    _total = _subTotal - _student.advBal + int.parse(_advBalController.text);

    // innvoice getter
    _payTypeVisible = _branch.payType == 1 && _monthlyVisible ? true : false;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EntryList(
                        Student(
                            0, "", '', _branch.name, 0, "", "", "", 0, 0, 0),
                        _branch,
                      ),
                ),
              );
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Center(
          child: ListView(
            children: <Widget>[
              //
              // Date Selector
              //
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    flex: 1,
                    child: RaisedButton(
                      elevation: 3.0,
                      color: Colors.white,
                      child: Text(_date),
                      onPressed: () => setState(() => _selectDate(context)),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(),
                  )
                ],
              ),
              //
              // Total/Subtotal
              //
              Card(
                elevation: 3.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text("Subtotal : ₹$_subTotal"),
                      Text("Adv/Bal : ₹${_student.advBal}"),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Total : ₹$_total",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20.0),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              //
              // StudentData
              //
              GestureDetector(
                onTap: () => showSearch(
                    context: context, delegate: StudentSearchEntry(_branch)),
                child: Card(
                  elevation: 3.0,
                  child: Column(
                    children: <Widget>[
                      //name
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Name: ${_student.name}',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      //belt,branch,fee
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text('Belt: ${_belts[_student.belt]}'),
                            Text('Branch: ${_student.branch}'),
                            Text('Paid Till: ${_student.fee}')
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //
              // Reason For
              //
              Card(
                elevation: 3.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text('Entry for: '),
                            DropdownButton(
                              items: _reasons.map((String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              value: _currentReason,
                              onChanged: (String _newReason) {
                                setState(() {
                                  _currentReason = _newReason;
                                  showDataCollector(_currentReason);
                                });
                              },
                            ),
                          ],
                        ),
                        // advBal
                        Row(
                          children: <Widget>[
                            Text("Adv/Bal"),
                            Checkbox(
                              activeColor: Theme.of(context).primaryColor,
                              value: _advBalCheck,
                              onChanged: (value) {
                                setState(() {
                                  _advBalCheck = value;
                                  _advBalVisible = value;
                                });
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Visibility(
                        visible: _advBalVisible,
                        child: SizedBox(
                          width: 50.0,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            key: Key('AdvBal'),
                            controller: _advBalController,
                            style: TextStyle(color: Colors.black),
                            onChanged: (value) {
                              setState(() {
                                _total = _subTotal +
                                    _student.advBal +
                                    int.parse(_advBalController.text);
                              });
                            },
                            decoration: InputDecoration(
                              hintText: "±10",
                              hintStyle: TextStyle(color: Colors.black26),
                              labelText: "Adv/Bal",
                              labelStyle: TextStyle(
                                  color: Colors.black, fontSize: 12.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //
              // Main entry
              //
              //
              // Monthly Fees
              //
              buildMonthlyFee(),
              //
              // Invoice card
              //
              invoiceCard(),
              //
              // Examination
              //
              buildExaminationFee(),
              //
              // Equipments
              //
              buildEquipmentFee(),
              //
              // Dress
              //
              buildDressFee(),
              //
              // Others
              //
              buildOthers(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Center(
          child: Icon(Icons.check),
        ),
        onPressed: () {
          _save();
        },
      ),
    );
  }

//
// MONTHLY FEE
//
  Visibility buildMonthlyFee() {
    return Visibility(
      visible: _monthlyVisible,
      child: Card(
        elevation: 3.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(
                    flex: 1,
                  ),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      key: Key('Monthly'),
                      controller: _monthlyController,
                      style: TextStyle(color: Colors.black),
                      onChanged: (value) {
                        setState(() {
                          _monthlyFee = int.parse(_monthlyController.text);
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "400",
                        hintStyle: TextStyle(color: Colors.black26),
                        labelText: "Per Month",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "x",
                      style: TextStyle(
                          fontWeight: FontWeight.w700, wordSpacing: 2.0),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: DropdownButton(
                      items: _monthsNo.map((int value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                      value: _monthsNoSelected,
                      onChanged: (value) {
                        _monthsNoSelected = value;
                        setState(() {
                          _subTotal = _monthlyFee * value;
                        });
                      },
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

//
// EXAMINATION FEE
//
  Visibility buildExaminationFee() {
    return Visibility(
      visible: _examinationVisible,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Center(
                child: _entry.id != null
                    ? Text(_entry.detailedReason)
                    : checkExamination(),
              ),
              Center(
                child: RaisedButton(
                  elevation: 3.0,
                  color: Colors.white,
                  child: Text(_examDate),
                  onPressed: () => setState(() => _selectExamDate(context)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

//
// EQUIP FEE
//
  Visibility buildEquipmentFee() {
    return Visibility(
      visible: _equipVisible,
      child: Card(
        elevation: 3.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Gloves,Kickpad
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  children: [
                    // Gloves
                    Checkbox(
                      activeColor: Theme.of(context).primaryColor,
                      value: _glovesCheck,
                      onChanged: (bool value) {
                        if (value == true) {
                          _equipSubTotal = _equipSubTotal + _branch.gloves;
                        } else {
                          _equipSubTotal = _equipSubTotal - _branch.gloves;
                        }
                        setState(() {
                          _subTotal = _equipSubTotal;
                          _glovesCheck = value;
                        });
                      },
                    ),
                    Text('Gloves'),
                  ],
                ),
                // Kickpad
                Row(
                  children: [
                    Checkbox(
                      activeColor: Theme.of(context).primaryColor,
                      value: _kickpadCheck,
                      onChanged: (bool value) {
                        if (value == true) {
                          _equipSubTotal = _equipSubTotal + _branch.kickpad;
                        } else {
                          _equipSubTotal = _equipSubTotal - _branch.kickpad;
                        }
                        setState(() {
                          _subTotal = _equipSubTotal;
                          _kickpadCheck = value;
                        });
                      },
                    ),
                    Text('Kickpad'),
                  ],
                ),
              ],
            ),
            // chestguard, footguard
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Chest Guard
                Row(
                  children: [
                    Checkbox(
                      activeColor: Theme.of(context).primaryColor,
                      value: _chestguardCheck,
                      onChanged: (bool value) {
                        if (value == true) {
                          _equipSubTotal = _equipSubTotal + _branch.chestguard;
                        } else {
                          _equipSubTotal = _equipSubTotal - _branch.chestguard;
                        }
                        setState(() {
                          _subTotal = _equipSubTotal;
                          _chestguardCheck = value;
                        });
                      },
                    ),
                    Text('Chest Guard'),
                  ],
                ),
                // Foot Guard
                Row(
                  children: [
                    Checkbox(
                      activeColor: Theme.of(context).primaryColor,
                      value: _footguardCheck,
                      onChanged: (bool value) {
                        if (value == true) {
                          _equipSubTotal = _equipSubTotal + _branch.footguard;
                        } else {
                          _equipSubTotal = _equipSubTotal - _branch.footguard;
                        }
                        setState(() {
                          _subTotal = _equipSubTotal;
                          _footguardCheck = value;
                        });
                      },
                    ),
                    Text('Foot Guard'),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

//
// DRESS FEE
//
  Visibility buildDressFee() {
    return Visibility(
      visible: _dressVisible,
      child: Card(
        elevation: 3.0,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      key: Key('Dress'),
                      controller: _dressSizeController,
                      style: TextStyle(color: Colors.black),
                      onChanged: (value) {
                        setState(() => checkDressFee(
                            double.parse(_dressSizeController.text)));
                      },
                      decoration: InputDecoration(
                        hintText: "5.10",
                        hintStyle: TextStyle(color: Colors.black26),
                        labelText: "Height",
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text("Size : $_sizeNo"),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // spcheck
                  Row(
                    children: [
                      Checkbox(
                        activeColor: Theme.of(context).primaryColor,
                        value: _spCheck,
                        onChanged: (bool value) {
                          if (value == true) {
                            _subTotal = _subTotal + _branch.spdress;
                          } else {
                            _subTotal = _subTotal - _branch.spdress;
                          }
                          setState(() {
                            _spCheck = value;
                          });
                        },
                      ),
                      Text("SP")
                    ],
                  ),
                  // vspcheck
                  Row(
                    children: [
                      Checkbox(
                        activeColor: Theme.of(context).primaryColor,
                        value: _vspCheck,
                        onChanged: (bool value) {
                          if (value == true) {
                            _subTotal = _subTotal + _branch.vspdress;
                          } else {
                            _subTotal = _subTotal - _branch.vspdress;
                          }
                          setState(() {
                            _vspCheck = value;
                          });
                        },
                      ),
                      Text("VSP")
                    ],
                  ),
                  // vvspcheck
                  Row(
                    children: [
                      Checkbox(
                        activeColor: Theme.of(context).primaryColor,
                        value: _vvspCheck,
                        onChanged: (bool value) {
                          if (value == true) {
                            _subTotal = _subTotal + _branch.vvspdress;
                          } else {
                            _subTotal = _subTotal - _branch.vvspdress;
                          }
                          setState(() {
                            _vvspCheck = value;
                          });
                        },
                      ),
                      Text("VVSP")
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

//
// OTHERS
//
  Visibility buildOthers() {
    return Visibility(
      visible: _otherVisible,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                // reason
                TextField(
                  keyboardType: TextInputType.text,
                  key: Key('reason'),
                  controller: _reasonController,
                  textCapitalization: TextCapitalization.words,
                  style: TextStyle(color: Colors.black),
                  onChanged: (value) {
                    _entry.detailedReason = value;
                  },
                  decoration: InputDecoration(
                    hintText: "Reason",
                    hintStyle: TextStyle(color: Colors.black26),
                    labelText: "Reason",
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
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    key: Key('amount'),
                    controller: _amountController,
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(color: Colors.black),
                    onChanged: (value) {
                      setState(() {
                        _subTotal = int.parse(value);
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "4000",
                      hintStyle: TextStyle(color: Colors.black26),
                      labelText: "Amount",
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
          ),
        ),
      ),
    );
  }

//
// Invoice data
//
  Visibility invoiceCard() {
    return Visibility(
      visible: _payTypeVisible,
      child: Card(
        elevation: 3.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            keyboardType: TextInputType.number,
            key: Key('Invoice'),
            controller: _monthlyIndirectController,
            style: TextStyle(color: Colors.black),
            onChanged: (value) {
              _invoiceId = int.parse(value);
            },
            decoration: InputDecoration(
              hintText: "565452",
              hintStyle: TextStyle(color: Colors.black26),
              labelText: "Invoice no.",
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
      ),
    );
  }

  void checkNUpdate() {
    // sub=tot

    if (_student.member != 0) {
      // if student is not member
      if (_student.belt <= 3) {
        _monthlyFee = _branch.bGreen;
        _monthlyController.text = _monthlyFee.toString();
      } else {
        _monthlyFee = _branch.aGreen;
        _monthlyController.text = _monthlyFee.toString();
      }
    } else {
      // if student is a member
      if (_student.belt <= 3) {
        _monthlyFee = _branch.bGreen - _branch.member;
        _monthlyController.text = _monthlyFee.toString();
      } else {
        _monthlyFee = _branch.aGreen - _branch.member;
        _monthlyController.text = _monthlyFee.toString();
      }
    }

    // // if to update
    // if (_entry.id != null) {
    //   _name = _entry.name;
    //   _advBalController.text = _entry.advBal;
    //   _date = _entry.date;
    //   _subTotal = _entry.subTotal;
    //   _advBalController.text = _entry.advBal.toString();
    //   _total = _entry.total;
    //   _currentReason = _entry.reason;
    //   showDataCollector(_entry.reason);

    //   // if monthly
    //   if (_entry.reason == "Monthly") {
    //     List months = _entry.detailedReason.split(",");
    //     _monthsNoSelected = months.length;
    //   }
    //   // if equipment
    //   if (_entry.reason == "Equipments") {
    //     List equip = _entry.detailedReason.split(",");
    //     for (var i = 0; i < equip.length; i++) {
    //       if (equip[i] == "Gloves") {
    //         setState(() => _glovesCheck = true);
    //       }
    //       if (equip[i] == "Kickpad") {
    //         setState(() => _kickpadCheck = true);
    //       }
    //       if (equip[i] == "Chest Guard") {
    //         setState(() => _chestguardCheck = true);
    //       }
    //       if (equip[i] == "Foot Guard") {
    //         setState(() => _footguardCheck = true);
    //       }
    //     }
    //   }
    //   // if dress
    //   if (_entry.reason == "Dress") {
    //     List dress = _entry.detailedReason.split("(");
    //     List dressSize = dress[0].split(":");
    //     _dressSizeController.text = dressSize[1];
    //     if (dress[2] == "SP)") {
    //       setState(() {
    //         _spCheck = true;
    //       });
    //     }
    //     if (dress[2] == "VSP)") {
    //       setState(() {
    //         _vspCheck = true;
    //       });
    //     }
    //     if (dress[2] == "VVSP)") {
    //       setState(() {
    //         _vvspCheck = true;
    //       });
    // //     }
    //   }
    //   // if Others
    //   if (_entry.reason == "Others") {
    //     _reasonController.text = _entry.detailedReason;
    //     _amountController.text = _entry.subTotal.toString();
    //   }
    // }
  }

  // show datacolletor
  void showDataCollector(String reason) {
    switch (reason) {
      case "Monthly":
        _monthlyVisible = true;
        _equipVisible =
            _otherVisible = _dressVisible = _examinationVisible = false;
        _subTotal = _monthlyFee;
        break;

      case 'Examination':
        _examinationVisible = true;
        _equipVisible = _otherVisible = _dressVisible = _monthlyVisible = false;
        if (_student.id != null) {
          checkExamFee(_student.belt);
        }
        break;

      case 'Equipments':
        _equipVisible = true;
        _monthlyVisible =
            _otherVisible = _dressVisible = _examinationVisible = false;
        _subTotal = 0;
        break;

      case 'Dress':
        _dressVisible = true;
        _equipVisible =
            _otherVisible = _examinationVisible = _monthlyVisible = false;
        break;

      case 'Card':
        _equipVisible = _examinationVisible =
            _otherVisible = _monthlyVisible = _dressVisible = false;
        _subTotal = _branch.card;
        break;

      case "Others":
        _equipVisible =
            _examinationVisible = _monthlyVisible = _dressVisible = false;
        _otherVisible = true;
    }
  }

  // exammination check
  Text checkExamination() {
    if (_student.belt != 9) {
      return Text("${_belts[_student.belt]} ➟ ${_belts[_student.belt + 1]}");
    } else {
      return Text("Sorry fees after Dan 1 is not supported yet");
    }
  }

  // dress fee decider
  void checkDressFee(double size) {
    if (size <= 3.02) {
      _sizeNo = 12;
      setState(() => _subTotal = _branch.dress12);
    } else if (size <= 3.05) {
      _sizeNo = 13;
      setState(() => _subTotal = _branch.dress13);
    } else if (size <= 3.08) {
      _sizeNo = 14;
      setState(() => _subTotal = _branch.dress14);
    } else if (size <= 3.11) {
      _sizeNo = 15;
      setState(() => _subTotal = _branch.dress15);
    } else if (size <= 4.02) {
      _sizeNo = 16;
      setState(() => _subTotal = _branch.dress16);
    } else if (size <= 4.05) {
      _sizeNo = 17;
      setState(() => _subTotal = _branch.dress17);
    } else if (size <= 4.08) {
      _sizeNo = 18;
      setState(() => _subTotal = _branch.dress18);
    } else if (size <= 4.11) {
      _sizeNo = 19;
      setState(() => _subTotal = _branch.dress19);
    } else if (size <= 5.02) {
      _sizeNo = 20;
      setState(() => _subTotal = _branch.dress20);
    } else if (size <= 5.05) {
      _sizeNo = 21;
      setState(() => _subTotal = _branch.dress21);
    } else if (size <= 5.08) {
      _sizeNo = 22;
      setState(() => _subTotal = _branch.dress22);
    } else if (size <= 5.11) {
      _sizeNo = 23;
      setState(() => _subTotal = _branch.dress23);
    } else if (size <= 6.02) {
      _sizeNo = 24;
      setState(() => _subTotal = _branch.dress24);
    }
  }

  // check exam fee
  void checkExamFee(int belt) {
    switch (belt) {
      case 0:
        setState(() => _subTotal = _branch.eOrange);
        break;
      case 1:
        setState(() => _subTotal = _branch.eYellow);
        break;
      case 2:
        setState(() => _subTotal = _branch.eGreen);
        break;
      case 3:
        setState(() => _subTotal = _branch.eBlue);
        break;
      case 4:
        setState(() => _subTotal = _branch.ePurple);
        break;
      case 5:
        setState(() => _subTotal = _branch.eBrown3);
        break;
      case 6:
        setState(() => _subTotal = _branch.eBrown2);
        break;
      case 7:
        setState(() => _subTotal = _branch.eBrown1);
        break;
      case 8:
        setState(() => _subTotal = _branch.eBlack);
        break;
    }
  }

  // save
  _save() async {
    int result;
    _entry.roll = _student.roll;
    _entry.name = _student.name;
    _entry.total = _total;
    _entry.subTotal = _subTotal;
    if (_branch.payType == 0) {
      _entry.reason = _currentReason;
    } else {
      _entry.reason = "$_currentReason($_invoiceId)";
    }
    _entry.date = _date;
    _entry.branch = _branch.name;
    _entry.pending = "0";

    getDReason(_currentReason);
    if (_advBalController.text == "") {
      _entry.advBal = "0";
      _student.advBal = 0;
    } else {
      _entry.advBal = _advBalController.text;
      _student.advBal = int.parse(_advBalController.text);
    }

    // save or update
    if (_entry.id != null) {
      result = await _entrydata.updateEntry(_entry);
      print('updated');
    } else {
      await _databaseStudent.updateStudent(_student);
      result = await _entrydata.insertEntry(_entry);
      print('inserted');
    }
    result == 1 ? debugPrint('saved') : debugPrint('fail');

    Navigator.pop(context);
  }

  // get detailed results
  void getDReason(String value) {
    List<String> _saveData = List<String>();
    int temp, _month, _year;

    List<String> temp1 = _student.fee.split("/");
    switch (value) {
      case 'Monthly':
        print(1);
        print(2);
        if (int.parse(temp1[0]) + _monthsNoSelected > 12) {
          _month = ((int.parse(temp1[0]) + _monthsNoSelected) % 12);
          _year = (int.parse(temp1[1]) + 1);
          print(3);
        } else {
          _month = (int.parse(temp1[0]) + _monthsNoSelected);
          _year = (int.parse(temp1[1]));
          print(4);
        }
        for (int i = 0; i < _monthsNoSelected; i++) {
          temp = (int.parse(temp1[0]) + i) % 12;
          _saveData.add(_months[temp]);
        }
        _student.fee = "$_month/$_year";
        print(5);
        _entry.detailedReason = _saveData
            .toString()
            .replaceAll("[", "")
            .replaceAll("]", "")
            .replaceAll(",", "/");
        print(6);
        break;
      case 'Examination':
        _entry.detailedReason = _student.belt != 9
            ? "${_belts[_student.belt]} ➟ ${_belts[_student.belt + 1]}($_examDate)"
            : "Sorry fees after Dan 1 is not supported yet";
        _student.belt++;
        break;
      case 'Equipments':
        _entry.detailedReason = checkEquipmentData();
        break;
      case 'Dress':
        checkDressData();
        break;
      case 'Card':
        _entry.detailedReason = 'Card';
        break;
      case 'Others':
        if (_otherVisible) {
          _entry.detailedReason = _reasonController.text;
        }
        break;
    }
  }

  // check equipment data
  String checkEquipmentData() {
    List<String> _saveData = [];
    if (_glovesCheck == true) {
      _saveData.add("Gloves");
    }
    if (_kickpadCheck == true) {
      _saveData.add("Kickpad");
    }
    if (_chestguardCheck == true) {
      _saveData.add("Chest Guard");
    }
    if (_footguardCheck == true) {
      _saveData.add("Foot Guard");
    }
    return _saveData.toString().replaceAll("[", "").replaceAll("]", "");
  }

  // check dress data
  void checkDressData() {
    if (_spCheck == true) {
      _entry.detailedReason =
          "Height : ${_dressSizeController.text} ($_sizeNo)(SP)";
    } else if (_vspCheck == true) {
      _entry.detailedReason =
          "Height : ${_dressSizeController.text} ($_sizeNo)(VSP)";
    } else if (_vvspCheck == true) {
      _entry.detailedReason =
          "Height : ${_dressSizeController.text} ($_sizeNo)(VVSP)";
    } else {
      _entry.detailedReason =
          "Height : ${_dressSizeController.text} ($_sizeNo)(Normal)";
    }
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
      setState(() {
        _date = DateFormat("dd/MM/yyyy").format(picked);
      });
    }
  }

  //date exam selector
  Future<Null> _selectExamDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _examDate = DateFormat("dd/MM/yyyy").format(picked);
      });
    }
  }
}

//
// search
//
class StudentSearchEntry extends SearchDelegate<String> {
  StudentSearchEntry(this.branch);
  List<Student> studentList, updatedList;

  Branch branch;

  static String _name,
      _reason,
      _detailedReason,
      _dateEntry,
      _branch,
      _advBalEntry;
  static int _totalEntry, _subTotalEntry, _roll;
  static String _uint8list;

  Entry _entry = Entry(_roll, _name, _totalEntry, _subTotalEntry, _advBalEntry,
      _reason, _detailedReason, _dateEntry, _branch, _uint8list);
  Student student;
  DatabaseStudent _data = DatabaseStudent();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
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
      updateStudentList();
    }

    updatedList = branch.name != ""
        ? studentList.where((p) => p.branch == branch.name).toList()
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
          elevation: 2.0,
          child: ListTile(
            title: Text(suggestedList[index].name),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEntry(
                      suggestedList[index], branch, _entry, "Add Entry"),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void updateStudentList() {
    final Future<Database> dbFuture = _data.initializeStudentDatabase();
    dbFuture.then((database) {
      Future<List<Student>> studentListFuture = _data.getNameList();
      studentListFuture.then((list) {
        this.studentList = list;
      });
    });
  }
}

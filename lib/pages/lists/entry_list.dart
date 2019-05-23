import 'dart:async';
import 'package:intl/intl.dart';
import 'package:karate/databases/entry_data.dart';
import 'package:flutter/material.dart';
import 'package:karate/databases/student_data.dart';
import 'package:karate/models/entry.dart';
import 'package:karate/models/student.dart';
import 'package:karate/pages/add_entry.dart';
import 'package:sqflite/sqlite_api.dart';

class EntryList extends StatefulWidget {
  final Student _student;
  final String _branch;
  final int _aGreen, _bGreen, _member;
  EntryList(
    this._student,
    this._branch,
    this._aGreen,
    this._bGreen,
    this._member,
  );
  @override
  _EntryListState createState() => _EntryListState(
        this._student,
        this._branch,
        this._aGreen,
        this._bGreen,
        this._member,
      );
}

class _EntryListState extends State<EntryList> {
  static String _name, _fee, _dob, _fromFee, _branchStud, _num;
  static int _roll, _belt, _advBal, _memberStud, _genderStud;

  DatabaseEntry _data = DatabaseEntry();
  Entry entry;
  String _branch,
      _date = DateFormat("dd/MM/yyyy").format(DateTime.now()).toString();
  Student _student;
  int _aGreen, _bGreen, _member, _payType;
  Student _studentUpdate = Student(
    _roll,
    _name,
    _dob,
    _branchStud,
    _belt,
    _fee,
    _fromFee,
    _num,
    _genderStud,
    _advBal,
    _memberStud,
  );
  _EntryListState(
    this._student,
    this._branch,
    this._aGreen,
    this._bGreen,
    this._member,
  );

  DatabaseStudent _databaseStudent = DatabaseStudent();

  List<Entry> entryList, updatedList, dateList;
  @override
  Widget build(BuildContext context) {
    if (entryList == null) {
      entryList = List<Entry>();
      updateEntryList();
    }
    updatedList = _branch != null
        ? entryList.where((p) => p.branch == _branch).toList()
        : entryList;

    dateList = updatedList.where((date) => date.date == _date).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Entry List'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: EntrySearch(_branch));
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          // total amount
          Expanded(
            flex: 1,
            child: Card(
                elevation: 3.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Spacer(),
                    FlatButton(
                      color: Colors.white,
                      child: Text(_date),
                      onPressed: () => setState(() => _selectDate(context)),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward),
                    Spacer(
                      flex: 2,
                    ),
                    Text("₹${totalAmount()}"),
                    Spacer(
                      flex: 2,
                    )
                  ],
                )),
          ),
          //
          // main list
          //
          Expanded(
            flex: 9,
            child: Container(
              child: ListView.builder(
                itemCount: updatedList.length,
                itemBuilder: (BuildContext context, int index) {
                  return index == 0
                      ? cardWithDate(updatedList[index].date, index, context)
                      : updatedList[index - 1].date == updatedList[index].date
                          ? normalCard(index, context)
                          : cardWithDate(
                              updatedList[index].date, index, context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Card normalCard(int index, BuildContext context) {
    return Card(
      elevation: 3.0,
      child: ListTile(
        title: Text(this.updatedList[index].name),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Theme.of(context).primaryColor),
          onPressed: () {
            _removeEntry(this.updatedList[index], index);
          },
        ),
        subtitle: Text(
            "${this.updatedList[index].date}  ${this.updatedList[index].reason}  ${this.updatedList[index].total}"),
        onTap: () {
          _showSnapshot(updatedList[index]);
        },
      ),
    );
  }

  Column cardWithDate(String date, int index, BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            date,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
        ),
        normalCard(index, context),
      ],
    );
  }

  // date selector
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

  // get total amount
  String totalAmount() {
    int total = 0;
    for (int i = 0; i < dateList.length; i++) {
      total += dateList[i].total;
    }
    return total.toString();
  }

  void updateEntryList() {
    final Future<Database> dbFuture = _data.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Entry>> studentListFuture = _data.getEntryList();
      studentListFuture.then((list) {
        setState(() {
          this.entryList = list;
        });
      });
    });
  }

  // remove entry
  _removeEntry(Entry entry, int index) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
            title: Text('Delete'),
            content: Column(
              children: <Widget>[
                Text(
                    "Do you really want to delete entry of ${this.entryList[index].name} ?"),
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
                          _data.deleteEntry(entry.id);
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
                    // Navigator.popAndPushNamed(context, "WrkPrgs");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return AddEntry(_student, _branch, _aGreen, _bGreen,
                              _member, _payType, entry, "Edit Entry");
                        },
                      ),
                    );
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

    switch (_entry.reason) {
      case "Monthly":
        temp = _entry.detailedReason.split(",");
        _studentUpdate =
            await _databaseStudent.getStudent(_entry.roll, _branch);
        List temp1 = _studentUpdate.fee.split("/");

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
        _studentUpdate.fee = "$_month/$_year";

        print(temp.length);
        print(_studentUpdate.fee);
        _databaseStudent.updateStudent(_studentUpdate);
        break;
      case "Examination":
        _studentUpdate =
            await _databaseStudent.getStudent(_entry.roll, _branch);
        _studentUpdate.belt--;
        _databaseStudent.updateStudent(_studentUpdate);
        break;
    }
  }
}

// search
class EntrySearch extends SearchDelegate<String> {
  static String _name, _fee, _dob, _fromFee, _branchStud, _num;
  static int _roll, _belt, _advBal, _memberStud, _genderStud;
  Student _studentUpdate = Student(
    _roll,
    _name,
    _dob,
    _branchStud,
    _belt,
    _fee,
    _fromFee,
    _num,
    _genderStud,
    _advBal,
    _memberStud,
  );

  EntrySearch(
    this.branch,
  );
  List<Entry> entryList, updatedList;
  int count;
  String branch;

  Student student;
  DatabaseEntry _data = DatabaseEntry();
  DatabaseStudent _databaseStudent = DatabaseStudent();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear, color: Theme.of(context).primaryColor),
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
    if (entryList == null) {
      entryList = List<Entry>();
      updateEntryList();
    }
    updatedList = branch != ""
        ? entryList.where((p) => p.branch == branch).toList()
        : entryList;

    List<Entry> suggestedList = query.isEmpty
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
                _removeEntry(suggestedList[index], index, context);
              },
            ),
            subtitle: Text(
                "${suggestedList[index].date}  ${suggestedList[index].reason}  ${suggestedList[index].total}"),
            onTap: () {
              _showSnapshot(suggestedList[index], context);
            },
          ),
        );
      },
    );
  }

  void updateEntryList() {
    final Future<Database> dbFuture = _data.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Entry>> studentListFuture = _data.getEntryList();
      studentListFuture.then((list) {
        this.entryList = list;
      });
    });
  }

  // remove entry
  _removeEntry(Entry entry, int index, BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
            title: Text('Delete'),
            content: Column(
              children: <Widget>[
                Text(
                    "Do you really want to delete ${this.entryList[index].name} ?"),
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
                          _data.deleteEntry(entry.id);
                          checkNUpdateStudData(entryList[index]);
                          updateEntryList();
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
  _showSnapshot(Entry entry, BuildContext context) {
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
                    //       return AddEntry(_student, _branch, _aGreen, _bGreen,
                    //           _member, entry, "Edit Entry");
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

    switch (_entry.reason) {
      case "Monthly":
        temp = _entry.detailedReason.split(",");
        _studentUpdate = await _databaseStudent.getStudent(_entry.roll, branch);
        List temp1 = _studentUpdate.fee.split("/");

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
        _studentUpdate.fee = "$_month/$_year";

        print(temp.length);
        print(_studentUpdate.fee);
        _databaseStudent.updateStudent(_studentUpdate);
        break;
      case "Examination":
        _studentUpdate = await _databaseStudent.getStudent(_entry.roll, branch);
        _studentUpdate.belt--;
        _databaseStudent.updateStudent(_studentUpdate);
        break;
    }
  }
}

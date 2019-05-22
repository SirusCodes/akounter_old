class Entry {
  int _id, _total, _subTotal, _roll;
  String _name, _reason, _detailedReason, _date, _branch, _advBal, _pending;

  Entry(
      this._roll,
      this._name,
      this._total,
      this._subTotal,
      this._advBal,
      this._reason,
      this._detailedReason,
      this._date,
      this._branch,
      this._pending);

  //getter
  int get id => _id;
  int get roll => _roll;
  String get name => _name;
  int get total => _total;
  int get subTotal => _subTotal;
  String get advBal => _advBal;
  String get reason => _reason;
  String get detailedReason => _detailedReason;
  String get date => _date;
  String get branch => _branch;
  String get pending => _pending;

  //setter
  set roll(int newRoll) {
    this._roll = newRoll;
  }

  set name(String newName) {
    if (newName.length <= 255) {
      this._name = newName;
    }
  }

  set total(int newTotal) {
    this._total = newTotal;
  }

  set subTotal(int newSubTotal) {
    this._subTotal = newSubTotal;
  }

  set advBal(String newAdvBal) {
    this._advBal = newAdvBal;
  }

  set reason(String newReason) {
    this._reason = newReason;
  }

  set detailedReason(String newDReason) {
    this._detailedReason = newDReason;
  }

  set date(String newDate) {
    this._date = newDate;
  }

  set branch(String newBranch) {
    this._branch = newBranch;
  }

  set pending(String newList) {
    this._pending = newList;
  }

  //convert to map object
  Map<String, dynamic> convertToMap() {
    var map = Map<String, dynamic>();
    map['id'] = _id;
    map['roll'] = _roll;
    map['name'] = _name;
    map['total'] = _total;
    map['subTotal'] = _subTotal;
    map['advBal'] = _advBal;
    map['reason'] = _reason;
    map['detailedReason'] = _detailedReason;
    map['date'] = _date;
    map['branch'] = _branch;
    map['pending'] = _pending;
    return map;
  }

  //from map
  Entry.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._roll = map['roll'];
    this._name = map['name'];
    this._total = map['total'];
    this._subTotal = map['subTotal'];
    this._advBal = map['advBal'];
    this._reason = map['reason'];
    this._detailedReason = map['detailedReason'];
    this._date = map['date'];
    this._branch = map['branch'];
    this._pending = map['pending'];
  }
}

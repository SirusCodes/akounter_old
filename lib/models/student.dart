class Student {
  int _id;
  int _roll;
  String _name;
  String _branch;
  String _dob;
  int _belt;
  String _fee;
  String _fromFee;
  String _num;
  int _gender;
  int _advBal;
  int _member;

  Student(
      this._roll,
      this._name,
      this._dob,
      this._branch,
      this._belt,
      this._fee,
      this._fromFee,
      this._num,
      this._gender,
      this._advBal,
      this._member);

  //getter
  int get id => _id;
  int get roll => _roll;
  String get name => _name;
  String get branch => _branch;
  String get dob => _dob;
  int get belt => _belt;
  String get fee => _fee;
  String get fromFee => _fromFee;
  String get number => _num;
  int get gender => _gender;
  int get advBal => _advBal;
  int get member => _member;

  //setter
  set roll(int newRoll) {
    this._roll = newRoll;
  }

  set name(String newName) {
    this._name = newName;
  }

  set branch(String newBranch) {
    this._branch = newBranch;
  }

  set dob(String newDOB) {
    this._dob = newDOB;
  }

  set belt(int newBelt) {
    this._belt = newBelt;
  }

  set fee(String newFee) {
    this._fee = newFee;
  }

  set fromFee(String newFromFee) {
    this._fromFee = newFromFee;
  }

  set number(String newNum) {
    this._num = newNum;
  }

  set gender(int newGender) {
    this._gender = newGender;
  }

  set advBal(int newAdvBal) {
    this._advBal = newAdvBal;
  }

  set member(int newMember) {
    this._member = newMember;
  }

  //convert to map obj
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = _id;
    map['roll'] = _roll;
    map['name'] = _name;
    map['branch'] = _branch;
    map['dob'] = _dob;
    map['belt'] = _belt;
    map['fee'] = _fee;
    map['fromFee'] = _fromFee;
    map['number'] = _num;
    map['gender'] = _gender;
    map['advBal'] = _advBal;
    map['member'] = _member;
    return map;
  }

  //from map
  Student.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._roll = map['roll'];
    this._name = map['name'];
    this._branch = map['branch'];
    this._dob = map['dob'];
    this._belt = map['belt'];
    this._fee = map['fee'];
    this._fromFee = map['fromFee'];
    this._num = map['number'];
    this._gender = map['gender'];
    this._advBal = map['advBal'];
    this._member = map['member'];
  }
}

class Branch {
  int _id;
  String _name;
  int _member, _bGreen, _aGreen, _count, _payType;

  Branch(
    this._name,
    this._bGreen,
    this._aGreen,
    this._member,
    this._count,
    this._payType,
  );

  //getter
  int get id => _id;
  String get name => _name;
  int get bGreen => _bGreen;
  int get aGreen => _aGreen;
  int get member => _member;
  int get count => _count;
  int get payType => _payType;

  //setter
  set name(String newName) {
    if (newName.length <= 255) {
      this._name = newName;
    }
  }

  set bGreen(int bgreen) {
    this._bGreen = bgreen;
  }

  set aGreen(int agreen) {
    this._aGreen = agreen;
  }

  set member(int member) {
    this._member = member;
  }

  set count(int newcount) {
    this._count = newcount;
  }

  set payType(int newpay) {
    this._payType = newpay;
  }

  //convert to map object
  Map<String, dynamic> convertToMap() {
    var map = Map<String, dynamic>();
    map['id'] = _id;
    map['name'] = _name;
    map['bGreen'] = _bGreen;
    map['aGreen'] = _aGreen;
    map['member'] = _member;
    map['count'] = _count;
    map['payType'] = _payType;
    return map;
  }

  //from map
  Branch.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._bGreen = map['bGreen'];
    this._aGreen = map['aGreen'];
    this._member = map['member'];
    this._count = map['count'];
    this._payType = map['payType'];
  }
}

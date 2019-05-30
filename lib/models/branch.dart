class Branch {
  int _id;
  String _name;
  int _member, _bGreen, _aGreen, _count, _payType;
  int _eOrange,
      _eYellow,
      _eGreen,
      _eBlue,
      _ePurple,
      _eBrown3,
      _eBrown2,
      _eBrown1,
      _eBlack;
  int _kickpad, _gloves, _chestguard, _footguard, _card;
  int _dress12,
      _dress13,
      _dress14,
      _dress15,
      _dress16,
      _dress17,
      _dress18,
      _dress19,
      _dress20,
      _dress21,
      _dress22,
      _dress23,
      _dress24,
      _spdress,
      _vspdress,
      _vvspdress;

  Branch(this._name, this._bGreen, this._aGreen, this._member, this._count,
      this._payType,
      [this._eOrange,
      this._eYellow,
      this._eGreen,
      this._eBlue,
      this._ePurple,
      this._eBrown3,
      this._eBrown2,
      this._eBrown1,
      this._eBlack,
      this._kickpad,
      this._gloves,
      this._chestguard,
      this._footguard,
      this._card,
      this._dress12,
      this._dress13,
      this._dress14,
      this._dress15,
      this._dress16,
      this._dress17,
      this._dress18,
      this._dress19,
      this._dress20,
      this._dress21,
      this._dress22,
      this._dress23,
      this._dress24,
      this._spdress,
      this._vspdress,
      this._vvspdress]);

  //getter
  int get id => _id;
  String get name => _name;
  int get bGreen => _bGreen;
  int get aGreen => _aGreen;
  int get member => _member;
  int get count => _count;
  int get payType => _payType;
  // exam amount getter
  int get eOrange => _eOrange;
  int get eYellow => _eYellow;
  int get eGreen => _eGreen;
  int get eBlue => _eBlue;
  int get ePurple => _ePurple;
  int get eBrown3 => _eBrown3;
  int get eBrown2 => _eBrown2;
  int get eBrown1 => _eBrown1;
  int get eBlack => _eBlack;
  // misc amount getter
  int get kickpad => _kickpad;
  int get gloves => _gloves;
  int get chestguard => _chestguard;
  int get footguard => _footguard;
  int get card => _card;
  // dress amount getter
  int get dress12 => _dress12;
  int get dress13 => _dress13;
  int get dress14 => _dress14;
  int get dress15 => _dress15;
  int get dress16 => _dress16;
  int get dress17 => _dress17;
  int get dress18 => _dress18;
  int get dress19 => _dress19;
  int get dress20 => _dress20;
  int get dress21 => _dress21;
  int get dress22 => _dress22;
  int get dress23 => _dress23;
  int get dress24 => _dress24;
  int get spdress => _spdress;
  int get vspdress => _vspdress;
  int get vvspdress => _vvspdress;
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

  // Exam fees setter
  set eOrange(int neweOrange) {
    this._eOrange = neweOrange;
  }

  set eYellow(int neweYellow) {
    this._eYellow = neweYellow;
  }

  set eGreen(int neweGreen) {
    this._eGreen = neweGreen;
  }

  set eBlue(int neweBlue) {
    this._eBlue = neweBlue;
  }

  set ePurple(int newePurple) {
    this._ePurple = newePurple;
  }

  set eBrown3(int neweBrown3) {
    this._eBrown3 = neweBrown3;
  }

  set eBrown2(int neweBrown2) {
    this._eBrown2 = neweBrown2;
  }

  set eBrown1(int neweBrown1) {
    this._eBrown1 = neweBrown1;
  }

  set eBlack(int neweBlack) {
    this._eBlack = neweBlack;
  }

  // misc fee setter
  set kickpad(int newkickpad) {
    this._kickpad = newkickpad;
  }

  set gloves(int newgloves) {
    this._gloves = newgloves;
  }

  set chestguard(int newchestguard) {
    this._chestguard = newchestguard;
  }

  set footguard(int newfootguard) {
    this._footguard = newfootguard;
  }

  set card(int newcard) {
    this._card = newcard;
  }

  // dress fee setter
  set dress12(int newdress12) {
    this._dress12 = newdress12;
  }

  set dress13(int newdress13) {
    this._dress13 = newdress13;
  }

  set dress14(int newdress14) {
    this._dress14 = newdress14;
  }

  set dress15(int newdress15) {
    this._dress15 = newdress15;
  }

  set dress16(int newdress16) {
    this._dress16 = newdress16;
  }

  set dress17(int newdress17) {
    this._dress17 = newdress17;
  }

  set dress18(int newdress18) {
    this._dress18 = newdress18;
  }

  set dress19(int newdress19) {
    this._dress19 = newdress19;
  }

  set dress20(int newdress20) {
    this._dress20 = newdress20;
  }

  set dress21(int newdress21) {
    this._dress21 = newdress21;
  }

  set dress22(int newdress22) {
    this._dress22 = newdress22;
  }

  set dress23(int newdress23) {
    this._dress23 = newdress23;
  }

  set dress24(int newdress24) {
    this._dress24 = newdress24;
  }

  set spdress(int newspdress) {
    this._spdress = newspdress;
  }

  set vspdress(int newvspdress) {
    this._vspdress = newvspdress;
  }

  set vvspdress(int newvvspdress) {
    this._vvspdress = newvvspdress;
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
    // exam fee to map
    map['eOrange'] = _eOrange;
    map['eYellow'] = _eYellow;
    map['eGreen'] = _eGreen;
    map['eBlue'] = _eBlue;
    map['ePurple'] = _ePurple;
    map['eBrown3'] = _eBrown3;
    map['eBrown2'] = _eBrown2;
    map['eBrown1'] = _eBrown1;
    // misc fee to map
    map['kickpad'] = _kickpad;
    map['gloves'] = _gloves;
    map['chestguard'] = _chestguard;
    map['footguard'] = _footguard;
    map['card'] = _card;
    // dress fee to map
    map['dress12'] = _dress12;
    map['dress13'] = _dress13;
    map['dress14'] = _dress14;
    map['dress15'] = _dress15;
    map['dress16'] = _dress16;
    map['dress17'] = _dress17;
    map['dress18'] = _dress18;
    map['dress19'] = _dress19;
    map['dress20'] = _dress20;
    map['dress21'] = _dress21;
    map['dress22'] = _dress22;
    map['dress23'] = _dress23;
    map['dress24'] = _dress24;
    map['spdress'] = _spdress;
    map['vspdress'] = _vspdress;
    map['vvspdress'] = _vvspdress;
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
    // exam fee from map
    this._eOrange = map['eOrange'];
    this._eYellow = map['eYellow'];
    this._eGreen = map['eGreen'];
    this._eBlue = map['eBlue'];
    this._ePurple = map['ePurple'];
    this._eBrown3 = map['eBrown3'];
    this._eBrown2 = map['eBrown2'];
    this._eBrown1 = map['eBrown1'];
    this._eBlack = map['eBlack'];
    // misc fee from map
    this._kickpad = map['kickpad'];
    this._gloves = map['gloves'];
    this._chestguard = map['chestguard'];
    this._footguard = map['footguard'];
    this._card = map['card'];
    // dress fee from map
    this._dress12 = map['dress12'];
    this._dress13 = map['dress13'];
    this._dress14 = map['dress14'];
    this._dress15 = map['dress15'];
    this._dress16 = map['dress16'];
    this._dress17 = map['dress17'];
    this._dress18 = map['dress18'];
    this._dress19 = map['dress19'];
    this._dress20 = map['dress20'];
    this._dress21 = map['dress21'];
    this._dress22 = map['dress22'];
    this._dress23 = map['dress23'];
    this._dress24 = map['dress24'];
    this._spdress = map['spdress'];
    this._vspdress = map['vspdress'];
    this._vvspdress = map['vvspdress'];
  }
}

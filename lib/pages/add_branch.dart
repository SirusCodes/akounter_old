import 'package:flushbar/flushbar.dart';
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
  TextEditingController eOrangeController = TextEditingController();
  TextEditingController eYellowController = TextEditingController();
  TextEditingController eGreenController = TextEditingController();
  TextEditingController eBlueController = TextEditingController();
  TextEditingController ePurpleController = TextEditingController();
  TextEditingController eBrown3Controller = TextEditingController();
  TextEditingController eBrown2Controller = TextEditingController();
  TextEditingController eBrown1Controller = TextEditingController();
  TextEditingController eBlackController = TextEditingController();
  TextEditingController kickpadController = TextEditingController();
  TextEditingController glovesController = TextEditingController();
  TextEditingController chestguardController = TextEditingController();
  TextEditingController footguardController = TextEditingController();
  TextEditingController cardController = TextEditingController();
  TextEditingController dress12Controller = TextEditingController();
  TextEditingController dress13Controller = TextEditingController();
  TextEditingController dress14Controller = TextEditingController();
  TextEditingController dress15Controller = TextEditingController();
  TextEditingController dress16Controller = TextEditingController();
  TextEditingController dress17Controller = TextEditingController();
  TextEditingController dress18Controller = TextEditingController();
  TextEditingController dress19Controller = TextEditingController();
  TextEditingController dress20Controller = TextEditingController();
  TextEditingController dress21Controller = TextEditingController();
  TextEditingController dress22Controller = TextEditingController();
  TextEditingController dress23Controller = TextEditingController();
  TextEditingController dress24Controller = TextEditingController();
  TextEditingController spdressController = TextEditingController();
  TextEditingController vspdressController = TextEditingController();
  TextEditingController vvspdressController = TextEditingController();

  static String _name;
  static int _bGreen, _aGreen, _member, _count, _payType;
  static int _eOrange,
      _eYellow,
      _eGreen,
      _eBlue,
      _ePurple,
      _eBrown3,
      _eBrown2,
      _eBrown1,
      _eBlack;
  static int _kickpad, _gloves, _chestguard, _footguard, _card;
  static int _dress12,
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
  EdgeInsets _padding = EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0);

  DatabaseBranch data = DatabaseBranch();
  var branch = Branch(
      _name,
      _bGreen,
      _aGreen,
      _member,
      _count,
      _payType,
      _eOrange,
      _eYellow,
      _eGreen,
      _eBlue,
      _ePurple,
      _eBrown3,
      _eBrown2,
      _eBrown1,
      _eBlack,
      _kickpad,
      _gloves,
      _chestguard,
      _footguard,
      _card,
      _dress12,
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
      _vvspdress);
  bool _indirectCheck = false;

  _AddBranchState(this.branch);
  @override
  void initState() {
    super.initState();
    updateOnStart();
  }

  void updateOnStart() {
    if (branch.id != null) {
      nameController.text = branch.name;
      aGreenController.text = branch.aGreen.toString();
      bGreenController.text = branch.bGreen.toString();
      memberController.text = branch.member.toString();
      editBranch();
      if (branch.payType == 1) {
        _indirectCheck = true;
      }
    } else {
      newBranch();
    }
  }

  editBranch() {
    // exam
    eOrangeController.text = branch.eOrange.toString();
    eYellowController.text = branch.eYellow.toString();
    eGreenController.text = branch.eGreen.toString();
    eBlueController.text = branch.eBlue.toString();
    ePurpleController.text = branch.ePurple.toString();
    eBrown3Controller.text = branch.eBrown3.toString();
    eBrown2Controller.text = branch.eBrown2.toString();
    eBrown1Controller.text = branch.eBrown1.toString();
    eBlackController.text = branch.eBlack.toString();
    // equip
    kickpadController.text = branch.kickpad.toString();
    glovesController.text = branch.gloves.toString();
    chestguardController.text = branch.chestguard.toString();
    footguardController.text = branch.footguard.toString();
    cardController.text = branch.card.toString();
    // dress
    dress12Controller.text = branch.dress12.toString();
    dress13Controller.text = branch.dress13.toString();
    dress14Controller.text = branch.dress14.toString();
    dress15Controller.text = branch.dress15.toString();
    dress16Controller.text = branch.dress16.toString();
    dress17Controller.text = branch.dress17.toString();
    dress18Controller.text = branch.dress18.toString();
    dress19Controller.text = branch.dress19.toString();
    dress20Controller.text = branch.dress20.toString();
    dress21Controller.text = branch.dress21.toString();
    dress22Controller.text = branch.dress22.toString();
    dress23Controller.text = branch.dress23.toString();
    dress24Controller.text = branch.dress24.toString();
    spdressController.text = branch.spdress.toString();
    vspdressController.text = branch.vspdress.toString();
    vvspdressController.text = branch.vvspdress.toString();
  }

  newBranch() {
    // exam
    eOrangeController.text = '500';
    eYellowController.text = '550';
    eGreenController.text = '600';
    eBlueController.text = '650';
    ePurpleController.text = '700';
    eBrown3Controller.text = '800';
    eBrown2Controller.text = '1000';
    eBrown1Controller.text = '1200';
    eBlackController.text = '8500';
    // equip
    kickpadController.text = '550';
    glovesController.text = '450';
    chestguardController.text = '750';
    footguardController.text = '850';
    cardController.text = '30';
    // dress
    dress12Controller.text = '590';
    dress13Controller.text = '600';
    dress14Controller.text = '630';
    dress15Controller.text = '660';
    dress16Controller.text = '690';
    dress17Controller.text = '720';
    dress18Controller.text = '750';
    dress19Controller.text = '780';
    dress20Controller.text = '810';
    dress21Controller.text = '840';
    dress22Controller.text = '870';
    dress23Controller.text = '900';
    dress24Controller.text = '930';
    spdressController.text = '60';
    vspdressController.text = '90';
    vvspdressController.text = '120';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: cAppBar(context, "Add Branch"),
      body: Form(
        key: _addBranchFormKey,
        child: ListView(
          children: <Widget>[
            // check indirect
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Checkbox(
                    onChanged: (bool value) {
                      setState(() {
                        _indirectCheck = value;
                      });
                    },
                    value: _indirectCheck,
                  ),
                  Text(
                    "Indirect Payment   ",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
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
                    validator: (value) => _nameValidator(value),
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
                    validator: (value) => _bGreenValidator(value),
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
                    validator: (value) => _aGreenValidator(value),
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
                    validator: (value) => _memberValidator(value),
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
            buildExaminationFee(),
            buildDressFee(),
            buildEquipmentFee()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.check),
        onPressed: () {
          if (_addBranchFormKey.currentState.validate()) {
            _addBranchFormKey.currentState.save();
            _save();
          }
        },
      ),
    );
  }

  _bGreenValidator(String value) {
    if (value.isEmpty) {
      return "Enter Monthly fee before Green";
    }
  }

  _memberValidator(String value) {
    if (value.isEmpty) {
      return "Enter member discount(if not then 0)";
    }
  }

  _aGreenValidator(String value) {
    if (value.isEmpty) {
      return "Enter Monthly fee after Green";
    }
  }

  _nameValidator(String value) {
    if (value.isEmpty) {
      return "Enter a proper name!";
    }
  }

  ExpansionTile buildEquipmentFee() {
    return ExpansionTile(
      title: Text('Equipment fees'),
      children: <Widget>[
        // gloves,kickpad
        Row(
          children: <Widget>[
            // gloves fees
            Expanded(
              flex: 1,
              child: CTextNumericField(
                label: 'gloves fee',
                hint: '450',
                controller: glovesController,
                onSaved: (value) {
                  branch.gloves = int.parse(value);
                },
              ),
            ),
            // kickpad fees
            Expanded(
              flex: 1,
              child: CTextNumericField(
                label: 'kickpad fee',
                hint: '550',
                controller: kickpadController,
                onSaved: (value) {
                  branch.kickpad = int.parse(value);
                },
              ),
            ),
          ],
        ),
        // chestguard,footguard
        Row(
          children: <Widget>[
            // chestguard fees
            Expanded(
              flex: 1,
              child: CTextNumericField(
                label: 'chestguard fee',
                hint: '750',
                controller: chestguardController,
                onSaved: (value) {
                  branch.chestguard = int.parse(value);
                },
              ),
            ),
            // footguard fees
            Expanded(
              flex: 1,
              child: CTextNumericField(
                label: 'footguard fee',
                hint: '850',
                controller: footguardController,
                onSaved: (value) {
                  branch.footguard = int.parse(value);
                },
              ),
            ),
          ],
        ),
        // card,
        Row(
          children: <Widget>[
            // card fees
            Expanded(
              flex: 1,
              child: CTextNumericField(
                label: 'card fee',
                hint: '30',
                controller: cardController,
                onSaved: (value) {
                  branch.card = int.parse(value);
                },
              ),
            ),
            //  fees
            Expanded(flex: 1, child: Container()),
          ],
        ),
      ],
    );
  }

  ExpansionTile buildDressFee() {
    return ExpansionTile(
      title: Text('Dress fees'),
      children: <Widget>[
        // Dress(12),Dress(13)
        Row(
          children: <Widget>[
            // Dress(12) fees
            Expanded(
              flex: 1,
              child: CTextNumericField(
                label: 'Dress(12) fee',
                hint: '590',
                controller: dress12Controller,
                onSaved: (value) {
                  branch.dress12 = int.parse(value);
                },
              ),
            ),
            // Dress(13) fees
            Expanded(
              flex: 1,
              child: CTextNumericField(
                label: 'Dress(13) fee',
                hint: '600',
                controller: dress13Controller,
                onSaved: (value) {
                  branch.dress13 = int.parse(value);
                },
              ),
            ),
          ],
        ),
        // Dress(14),Dress(15)
        Row(
          children: <Widget>[
            // Dress(14) fees
            Expanded(
              flex: 1,
              child: CTextNumericField(
                label: 'Dress(14) fee',
                hint: '630',
                controller: dress14Controller,
                onSaved: (value) {
                  branch.dress14 = int.parse(value);
                },
              ),
            ),
            // Dress(15) fees
            Expanded(
              flex: 1,
              child: CTextNumericField(
                label: 'Dress(15) fee',
                hint: '660',
                controller: dress15Controller,
                onSaved: (value) {
                  branch.dress15 = int.parse(value);
                },
              ),
            ),
          ],
        ),
        // Dress(16),Dress(17)
        Row(
          children: <Widget>[
            // Dress(16) fees
            Expanded(
              flex: 1,
              child: CTextNumericField(
                label: 'Dress(16) fee',
                hint: '690',
                controller: dress16Controller,
                onSaved: (value) {
                  branch.dress16 = int.parse(value);
                },
              ),
            ),
            // Dress(17) fees
            Expanded(
              flex: 1,
              child: CTextNumericField(
                label: 'Dress(17) fee',
                hint: '720',
                controller: dress17Controller,
                onSaved: (value) {
                  branch.dress17 = int.parse(value);
                },
              ),
            ),
          ],
        ),
        // Dress(18),Dress(19)
        Row(
          children: <Widget>[
            // Dress(18) fees
            Expanded(
              flex: 1,
              child: CTextNumericField(
                label: 'Dress(18) fee',
                hint: '750',
                controller: dress18Controller,
                onSaved: (value) {
                  branch.dress18 = int.parse(value);
                },
              ),
            ),
            // Dress(19) fees
            Expanded(
              flex: 1,
              child: CTextNumericField(
                label: 'Dress(19) fee',
                hint: '780',
                controller: dress19Controller,
                onSaved: (value) {
                  branch.dress19 = int.parse(value);
                },
              ),
            ),
          ],
        ),
        // Dress(20),Dress(21)
        Row(
          children: <Widget>[
            // Dress(20) fees
            Expanded(
              flex: 1,
              child: CTextNumericField(
                label: 'Dress(20) fee',
                hint: '810',
                controller: dress20Controller,
                onSaved: (value) {
                  branch.dress20 = int.parse(value);
                },
              ),
            ),
            // Dress(21) fees
            Expanded(
              flex: 1,
              child: CTextNumericField(
                label: 'Dress(21) fee',
                hint: '840',
                controller: dress21Controller,
                onSaved: (value) {
                  branch.dress21 = int.parse(value);
                },
              ),
            ),
          ],
        ),
        // Dress(22),Dress(23)
        Row(
          children: <Widget>[
            // Dress(22) fees
            Expanded(
              flex: 1,
              child: CTextNumericField(
                label: 'Dress(22) fee',
                hint: '870',
                controller: dress22Controller,
                onSaved: (value) {
                  branch.dress22 = int.parse(value);
                },
              ),
            ),
            // Dress(23) fees
            Expanded(
              flex: 1,
              child: CTextNumericField(
                label: 'Dress(23) fee',
                hint: '900',
                controller: dress23Controller,
                onSaved: (value) {
                  branch.dress23 = int.parse(value);
                },
              ),
            ),
          ],
        ),
        // Dress(24),Dress(SP)
        Row(
          children: <Widget>[
            // Dress(24) fees
            Expanded(
              flex: 1,
              child: CTextNumericField(
                label: 'Dress(24) fee',
                hint: '930',
                controller: dress24Controller,
                onSaved: (value) {
                  branch.dress24 = int.parse(value);
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: CTextNumericField(
                label: 'Dress(SP) fee',
                hint: '60',
                controller: spdressController,
                onSaved: (value) {
                  branch.spdress = int.parse(value);
                },
              ),
            ),
          ],
        ),
        // vspdress,vvspdress
        Row(
          children: <Widget>[
            // vspdress fees
            Expanded(
              flex: 1,
              child: CTextNumericField(
                label: 'Dress(VSP) fee',
                hint: '90',
                controller: vspdressController,
                onSaved: (value) {
                  branch.vspdress = value;
                },
              ),
            ),
            // vvspdress fees
            Expanded(
              flex: 1,
              child: CTextNumericField(
                label: 'Dress(VVSP) fee',
                hint: '120',
                controller: vvspdressController,
                onSaved: (value) {
                  branch.vvspdress = value;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  ExpansionTile buildExaminationFee() {
    return ExpansionTile(
      title: Text("Examination fee"),
      children: <Widget>[
        // orange yellow
        Row(
          children: <Widget>[
            // Orange fee
            Expanded(
              flex: 1,
              child: CTextNumericField(
                label: "Orange fee",
                hint: "500",
                controller: eOrangeController,
                onSaved: (value) {
                  branch.eOrange = int.parse(value);
                },
              ),
            ),
            // Yellow fee
            Expanded(
              flex: 1,
              child: CTextNumericField(
                label: 'Yellow fee',
                hint: '550',
                controller: eYellowController,
                onSaved: (value) {
                  branch.eYellow = int.parse(value);
                },
              ),
            ),
          ],
        ),
        // green blue
        Row(
          children: <Widget>[
            // Green fees
            Expanded(
              flex: 1,
              child: CTextNumericField(
                label: 'Green fee',
                hint: '600',
                controller: eGreenController,
                onSaved: (value) {
                  branch.eGreen = int.parse(value);
                },
              ),
            ),
            // Blue fees
            Expanded(
              flex: 1,
              child: CTextNumericField(
                label: 'Blue fee',
                hint: '650',
                controller: eBlueController,
                onSaved: (value) {
                  branch.eBlue = int.parse(value);
                },
              ),
            ),
          ],
        ),
        //  purple brown3
        Row(
          children: <Widget>[
            // purple fees
            Expanded(
              flex: 1,
              child: CTextNumericField(
                label: 'Purple fee',
                hint: '700',
                controller: ePurpleController,
                onSaved: (value) {
                  branch.ePurple = int.parse(value);
                },
              ),
            ),
            // brown 3 fees
            Expanded(
              flex: 1,
              child: CTextNumericField(
                label: 'Brown3 fee',
                hint: '750',
                controller: eBrown3Controller,
                onSaved: (value) {
                  branch.eBrown3 = int.parse(value);
                },
              ),
            ),
          ],
        ),
        // brown2 brown1
        Row(
          children: <Widget>[
            // Brown2 fees
            Expanded(
              flex: 1,
              child: CTextNumericField(
                label: 'Brown2 fee',
                hint: '800',
                controller: eBrown2Controller,
                onSaved: (value) {
                  branch.eBrown2 = int.parse(value);
                },
              ),
            ),
            // Brown1 fees
            Expanded(
              flex: 1,
              child: CTextNumericField(
                label: 'Brown1 fee',
                hint: '850',
                controller: eBrown1Controller,
                onSaved: (value) {
                  branch.eBrown1 = int.parse(value);
                },
              ),
            ),
          ],
        ),
        // black
        Row(
          children: <Widget>[
            // Black fees
            Expanded(
              flex: 1,
              child: CTextNumericField(
                label: 'Black fee',
                hint: '8500',
                controller: eBlackController,
                onSaved: (value) {
                  branch.eBlack = int.parse(value);
                },
              ),
            ),
            Expanded(flex: 1, child: Container()),
          ],
        ),
      ],
    );
  }

  void _save() async {
    branch.payType = _indirectCheck ? 1 : 0;
    branch.count = 0;
    checkBeforeSave();
    int result = branch.id == null
        ? await data.insertName(branch)
        : await data.updateName(branch);
    if (result != 0) {
      _showSnackBar(context, '${nameController.text} is saved/updated!');
    } else {
      _showSnackBar(context, 'Problem Saving Data');
    }
    setState(() {
      reset();
    });
    Navigator.pop(context);
  }

  // checkBeforeSave
  checkBeforeSave() {
    // examination
    branch.eOrange = branch.eOrange ?? 500;
    branch.eYellow = branch.eYellow ?? 550;
    branch.eGreen = branch.eGreen ?? 600;
    branch.eBlue = branch.eBlue ?? 650;
    branch.ePurple = branch.ePurple ?? 700;
    branch.eBrown3 = branch.eBrown3 ?? 800;
    branch.eBrown2 = branch.eBrown2 ?? 1000;
    branch.eBrown1 = branch.eBrown1 ?? 1200;
    branch.eBlack = branch.eBlack ?? 8500;
    // equip
    branch.kickpad = branch.kickpad ?? 550;
    branch.gloves = branch.gloves ?? 450;
    branch.chestguard = branch.chestguard ?? 750;
    branch.footguard = branch.footguard ?? 850;
    branch.card = branch.card ?? 30;
    // dress
    branch.dress12 = branch.dress12 ?? 590;
    branch.dress13 = branch.dress13 ?? 600;
    branch.dress14 = branch.dress14 ?? 630;
    branch.dress15 = branch.dress15 ?? 660;
    branch.dress16 = branch.dress16 ?? 690;
    branch.dress17 = branch.dress17 ?? 720;
    branch.dress18 = branch.dress18 ?? 750;
    branch.dress19 = branch.dress19 ?? 780;
    branch.dress20 = branch.dress20 ?? 810;
    branch.dress21 = branch.dress21 ?? 840;
    branch.dress22 = branch.dress22 ?? 870;
    branch.dress23 = branch.dress23 ?? 900;
    branch.dress24 = branch.dress24 ?? 930;
    branch.spdress = branch.spdress ?? 60;
    branch.vspdress = branch.vspdress ?? 90;
    branch.vvspdress = branch.vvspdress ?? 120;
  }

  // reset
  reset() {
    aGreenController.text = "";
    nameController.text = "";
    bGreenController.text = "";
    memberController.text = "";
    _indirectCheck = false;
  }

  //snackbar
  void _showSnackBar(BuildContext context, String message) {
    Flushbar(
      margin: EdgeInsets.all(8.0),
      borderRadius: 8,
      message: message,
      duration: Duration(seconds: 2),
    )..show(context);
  }
}

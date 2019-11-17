import 'package:flutter/material.dart';

Widget cAppBar(context, String title) {
  return AppBar(
    centerTitle: true,
    title: Text(title),
    leading: IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
  );
}

Widget cTextField(TextEditingController controller, TextInputType keyboardType,
    Function validator, Function onSaved, BuildContext context) {
  return TextFormField(
    keyboardType: keyboardType,
    style: TextStyle(color: Theme.of(context).primaryColor),
    controller: controller,
    validator: validator,
    onSaved: onSaved,
    decoration: InputDecoration(
      hintText: "400",
      hintStyle: TextStyle(color: Theme.of(context).primaryColor),
      labelText: "After Green",
      labelStyle: TextStyle(color: Theme.of(context).primaryColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: Colors.black,
          width: 10.0,
        ),
      ),
    ),
  );
}

class CTextField extends StatelessWidget {
  CTextField(
      {this.label,
      this.hint,
      this.controller,
      this.keyboardType,
      this.validator,
      this.onSaved});
  final String label, hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Function validator;
  final Function onSaved;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      style: TextStyle(color: Theme.of(context).primaryColor),
      controller: controller,
      validator: validator,
      onSaved: onSaved,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Theme.of(context).primaryColor),
        labelText: label,
        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.black,
            width: 10.0,
          ),
        ),
      ),
    );
  }
}

class CTextNumericField extends StatelessWidget {
  CTextNumericField({this.controller, this.onSaved, this.label, this.hint});
  final String label, hint;
  final TextEditingController controller;

  final Function onSaved;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CTextField(
        controller: controller,
        label: label,
        onSaved: onSaved,
        hint: hint,
        validator: (value) {
          _validator(int.parse(controller.text));

          return null;
        },
        keyboardType: TextInputType.number,
      ),
    );
  }

  _validator(int value) {
    if (value <= 0 || value == null) {
      return "Incorrect value";
    }
  }
}

// details widget
class Details extends StatelessWidget {
  const Details({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Text("Made in ❤ with Karate"),
        ),
        Container(
          child: Text("by Darshan"),
        ),
        //version text
        Container(
          width: 300.0,
          child: Text(
            "v1.7-beta",
            textAlign: TextAlign.right,
          ),
        )
      ],
    );
  }
}

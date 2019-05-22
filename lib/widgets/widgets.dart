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

// SnackBar cSnackBar(String somewords) {
//   return SnackBar(
//     content: Text(somewords),
//     duration: Duration(seconds: 1),
//   );
  
// }

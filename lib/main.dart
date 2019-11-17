import 'package:flutter/material.dart';
import 'package:karate/pages/branch_page.dart';
import 'package:karate/pages/main_page.dart';
import 'package:karate/select_branch.dart';
import 'package:karate/work_in_progress.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var materialApp = MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AKounter',
      home: BranchPage(),
      theme: ThemeData(
        primaryColor: Colors.blueGrey,
        fontFamily: 'GoogleSans',
        splashColor: Colors.black54,
      ),
      routes: {
        "HomePage": (context) => MainPage(),
        "WrkPrgs": (context) => WrkPrgs(),
        "SelBrnch": (context) => SelBrnch(),
      },
    );
    return materialApp;
  }
}

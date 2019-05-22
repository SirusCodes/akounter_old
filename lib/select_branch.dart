import 'package:flutter/material.dart';

class SelBrnch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                  "SELECT BRANCH",
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                ),
              ),

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
                  "v1.3",
                  textAlign: TextAlign.right,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

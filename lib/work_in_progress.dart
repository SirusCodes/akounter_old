import 'package:flutter/material.dart';

class WrkPrgs extends StatelessWidget {
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
                  "WORK IN PROGRESS",
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
                  "v1.5+1",
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

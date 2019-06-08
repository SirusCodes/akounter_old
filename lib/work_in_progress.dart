import 'package:flutter/material.dart';
import 'package:karate/widgets/widgets.dart';

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
              Details()
            ],
          ),
        ),
      ),
    );
  }
}

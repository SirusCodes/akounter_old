import 'package:flutter/material.dart';
import 'package:karate/widgets/widgets.dart';

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
              Details()
            ],
          ),
        ),
      ),
    );
  }
}

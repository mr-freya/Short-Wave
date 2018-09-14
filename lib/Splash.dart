import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  Future<FirebaseUser> _getUser() async {
    user = await _auth.currentUser();
    print("Signed in ${user.uid}");
    return user;
  }

  Future startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
    //String currentUser;
  }

  navigationPage() {
    if (user == null) {
      Navigator.of(context).pushReplacementNamed('/Welcome');
      print("${user.uid}");
      print(user);
    } else {
      userUid = user.uid;
      Navigator.of(context).pushReplacementNamed('/MyHomePage');
      //print("Signed in ${user.uid}");
    }
  }

  @override
  void initState() {
    super.initState();
    _getUser();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Text(
          "SPLOOSH",
          textScaleFactor: 5.0,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Rules1 extends StatelessWidget {
  static final String route = "Welcome";
  final FirebaseUser user;
  final String uid;
  Rules1({this.user, this.uid});
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Container(
                height: 100.0,
                width: 300.0,
                child: Text(
                  "Lastly,",
                  style: TextStyle(color: Colors.blueAccent,
                    fontSize: 46.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    //fontFamily: importing
                  ), //textScaleFactor: 2.0,
                  textAlign: TextAlign.center,
                ),
                margin: const EdgeInsets.only(
                  top: 170.0,
                  bottom: 3.0,
                  left: 16.0,
                  right: 16.0,
                ),
              ),
              new Container(
                height: 100.0,
                width: 300.0,
                child: Text(
                  "RadiYo has a 0-Tolerance Policy For...",
                  style: TextStyle(color: Colors.blueAccent,
                    fontSize: 46.0,
                    fontWeight: FontWeight.bold,
                    //fontStyle: FontStyle.italic,
                    //fontFamily: importing
                  ), //textScaleFactor: 2.0,
                  textAlign: TextAlign.center,
                ),
                margin: const EdgeInsets.only(
                  top: 8.0,
                  bottom: 100.0,
                  left: 16.0,
                  right: 16.0,
                ),
              ),
              new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                        height: 70.0,
                        width: 350.0,
                        margin: const EdgeInsets.only(
                          top: 140.0,
                          bottom: 0.0,
                          left: 8.0,
                          right: 8.0,
                        ),
                        child: new ButtonTheme(
                            minWidth: 350.0,
                            height: 70.0,
                            child: new RaisedButton(
                                color: Colors.black,
                                elevation: 20.0,
                                splashColor: Colors.white,
                                shape: new RoundedRectangleBorder(
                                  //these button are satisfying...!
                                    borderRadius: new BorderRadius.circular(30.0)),
                                child: new Text("CONTINUE       1/7",
                                  style: TextStyle(color: Colors.white,
                                    fontSize: 26.0,
                                    fontWeight: FontWeight.bold,
                                    //fontStyle: FontStyle.italic,
                                    //fontFamily: importing
                                  ), //textScaleFactor: 2.0,
                                  textAlign: TextAlign.center,),
                                  onPressed: () {
                                  BlendMode.color;
                                  Navigator.of(context).pushNamed("/Rules2");
                                  print("pressed");
                                }
                            )
                        )
                    )]
              )
            ]
        )
    );
  }
}

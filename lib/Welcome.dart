import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  //static final String route = "Welcome";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.blue,
        body: new Column(mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'images/planet.png',
                height: 180.0,
                width: 180.0,
              ),
              new Container(
                height: 10.0,
                width: 400.0,
                child: Text(
                  "RadiYo",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold,
                    //fontStyle: FontStyle.italic,
                    //fontFamily: importing
                  ), //textScaleFactor: 2.0,
                  textAlign: TextAlign.center,
                ),
                margin: const EdgeInsets.only(
                  top: 40.0,
                  bottom: 40.0,
                  left: 16.0,
                  right: 16.0,
                ),
              ),
              new Container(
                height: 10.0,
                width: 400.0,
                child: Text(
                  "Your Local Flow",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    //fontFamily: importing
                  ), //textScaleFactor: 2.0,
                  textAlign: TextAlign.center,
                ),
                margin: const EdgeInsets.only(
                  top: 1.0,
                  bottom: 150.0,
                  left: 16.0,
                  right: 16.0,
                ),
              ),
              new Container(
                height: 100.0,
                width: 300.0,
                child: Text(
                  "Anonymously Discuss Life, Politics, and Society, with your Community",
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                    //fontStyle: FontStyle.italic,
                    //fontFamily: importing
                  ), //textScaleFactor: 2.0,
                  textAlign: TextAlign.center,
                ),
                margin: const EdgeInsets.only(
                  top: 8.0,
                  bottom: 80.0,
                  left: 16.0,
                  right: 16.0,
                ),
              ),
              new Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                  Widget>[
                new Container(
                    height: 70.0,
                    width: 350.0,
                    margin: const EdgeInsets.only(
                      top: 0.0,
                      bottom: 0.0,
                      left: 8.0,
                      right: 8.0,
                    ),
                    child: new ButtonTheme(
                        minWidth: 350.0,
                        height: 70.0,
                        child: new RaisedButton(
                            color: Colors.pink,
                            elevation: 20.0,
                            splashColor: Colors.white,
                            shape: new RoundedRectangleBorder(
                                //these button are satisfying...!
                                borderRadius: new BorderRadius.circular(30.0)),
                            child: new Text(
                              "Get Started",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26.0,
                                fontWeight: FontWeight.bold,
                                //fontStyle: FontStyle.italic,
                                //fontFamily: importing
                              ), //textScaleFactor: 2.0,
                              textAlign: TextAlign.center,
                            ),
                            onPressed: () {
                              BlendMode.color;
                              Navigator.of(context).pushNamed("/MySMS");
                              print("pressed");
                            })))
              ])
            ]));
  }
}

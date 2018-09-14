import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'main.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

var controller = new MaskedTextController(mask: '1 (000)-000-0000');

FirebaseUser user;
final FirebaseAuth _auth = FirebaseAuth.instance;

class MySMS extends StatefulWidget {

  @override
  _MySMSState createState() => new _MySMSState();
}

class _MySMSState extends State<MySMS> {
  Future<String> _message = new Future<String>.value('');
  TextEditingController _smsCodeController = new TextEditingController();
  TextEditingController _pncontroller = new TextEditingController();
  String verificationId;

  Future<void> _testVerifyPhoneNumber() async {
    final PhoneVerificationCompleted verificationCompleted =
        (FirebaseUser user) {
      userUid = user.uid;
      setState(() {
        _message = Future < String>.value('signInWithPhoneNumber auto succeeded:$user');
        print("Signed in${user.uid}");
        Navigator.of(context).pushNamed("/Rules1");
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        _message = Future < String>.value('');});};

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
    };

    await _auth.verifyPhoneNumber(
        //phoneNumber: "19142741539",
        phoneNumber: _pncontroller.text,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  Future<String> _testSignInWithPhoneNumber(String smsCode) async {
    final FirebaseUser user = await _auth.signInWithPhoneNumber(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    user.uid == currentUser.uid;

    _smsCodeController.text = "";

    Navigator.of(context).pushNamed("/Rules1");
    print("Signed in ${user.uid}");

    //print("Signed in ${user.uid}"); not here
    return 'signInWithPhoneNumber succeeded: $user';
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.blue,
        body: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Container(
                height: 65.0,
                width: 400.0,
                child: Text(
                  "",),
              ),
              new Image.asset(
                'images/planet.png',
                height: 180.0,
                width: 180.0,
              ),
              visibilityTag
                  ? new Container(
                height: 10.0,
                width: 400.0,
                child: Text(
                  "Enter your Digits",
                  style: TextStyle(color: Colors.black,
                    fontSize: 38.0,
                    fontWeight: FontWeight.bold,
                    //fontStyle: FontStyle.italic,
                    //fontFamily: importing
                  ), //textScaleFactor: 2.0,
                  textAlign: TextAlign.center,
                ),
                margin: const EdgeInsets.only(
                  top: 51.0,
                  bottom: 60.0,
                  left: 16.0,
                  right: 16.0,
                ),
              ) : new Container(
                height: 10.0,
                width: 400.0,
                child: Text(
                  "Enter your Code",
                  style: TextStyle(color: Colors.black,
                    fontSize: 38.0,
                    fontWeight: FontWeight.bold,
                    //fontStyle: FontStyle.italic,
                    //fontFamily: importing
                  ), //textScaleFactor: 2.0,
                  textAlign: TextAlign.center,
                ),
                margin: const EdgeInsets.only(
                  top: 51.0,
                  bottom: 60.0,
                  left: 16.0,
                  right: 16.0,
                ),
              ),
              visibilityTag
                  ? new Container(
                margin: const EdgeInsets.only(
                  top: 59.0,
                  bottom: 8.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: new TextField(controller: controller, maxLength: 16,  keyboardType: TextInputType.number,  maxLengthEnforced: true,
                  decoration: new InputDecoration(
                    hintText: "ex. 9141234569",
                    filled: true,)
                  //controller: _smsCodeController,
                ),
              ) : new Container(
                margin: const EdgeInsets.only(
                  top: 59.0,
                  bottom: 8.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child:  new TextField(controller: controller, maxLength: 6,  keyboardType: TextInputType.number,  maxLengthEnforced: true,
                  decoration: new InputDecoration(
                    hintText: "ex. 19142741539",
                    filled: true,)
                //controller: _smsCodeController,
              ),
              ),
              new Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                  Widget>[new Container(
                  height: 50.0,
                  width: 170.0,
                  margin: const EdgeInsets.only(
                    top: 0.0,
                    bottom: 0.0,
                    left: 8.0,
                    right: 8.0,
                  ),
                  child: new ButtonTheme(
                      minWidth: 30.0,
                      height: 30.0,
                      child: new RaisedButton(
                          color: Colors.pink,
                          elevation: 20.0,
                          splashColor: Colors.white,
                          shape: new RoundedRectangleBorder(
                            //these button ,are satisfying...!
                              borderRadius: new BorderRadius.circular(30.0)),
                          child: new Text("Try Again", style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            //fontStyle: FontStyle.italic,
                            //fontFamily: importing
                          ), //textScaleFactor: 2.0,
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            print("SignedOut");
                            controller.clear();
                            signOut;
                            signOut();
                            BlendMode.color;
                            Navigator.of(context).pushNamed("/MySMS");
                            //Navigator.of(context).pushNamed("/Rules1");
                            print("pressed");
                          })
                  )
              ),

              visibilityTag
                  ? new Row(
                  mainAxisAlignment: MainAxisAlignment.center, children: <
                  Widget>[
                new Container(
                    height: 50.0,
                    width: 170.0,
                    margin: const EdgeInsets.only(
                      top: 0.0,
                      bottom: 0.0,
                      left: 8.0,
                      right: 8.0,
                    ),
                    child: new ButtonTheme(
                        minWidth: 30.0,
                        height: 30.0,
                        child: new RaisedButton(
                            color: Colors.pink,
                            elevation: 20.0,
                            splashColor: Colors.white,
                            shape: new RoundedRectangleBorder(
                              //these button ,are satisfying...!
                                borderRadius: new BorderRadius.circular(30.0)),
                            child: const Text(
                              'Send Secret Code', style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              //fontStyle: FontStyle.italic,
                              //fontFamily: importing
                            ), //textScaleFactor: 2.0,
                              //textScaleFactor: 2.0,
                              textAlign: TextAlign.center,
                            ),
                            onPressed: () {
                              _testVerifyPhoneNumber();
                              controller.clear();
                              _changed(
                                  false, "tag");
                            })
                    )
                )
              ]) : new Row(
                  mainAxisAlignment: MainAxisAlignment.center, children: <
                  Widget>[
                new Container(
                    height: 50.0,
                    width: 170.0,
                    margin: const EdgeInsets.only(
                      top: 0.0,
                      bottom: 0.0,
                      left: 8.0,
                      right: 8.0,
                    ),
                    child: new ButtonTheme(
                      minWidth: 30.0,
                      height: 30.0,
                      child: new RaisedButton(
                          color: Colors.pink,
                          elevation: 20.0,
                          splashColor: Colors.white,
                          shape: new RoundedRectangleBorder(
                            //these button ,are satisfying...!
                              borderRadius: new BorderRadius.circular(30.0)),
                          child: const Text("Continue-->", style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            //fontStyle: FontStyle.italic,
                            //fontFamily: importing
                          ), //textScaleFactor: 2.0,
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            if (_smsCodeController.text != null) {
                              setState(() {
                                _message =
                                    _testSignInWithPhoneNumber(
                                        _smsCodeController.text);
                              });
                            }
                          }
                          ),
                    )
                ),
                new FutureBuilder<String>(
                    future: _message,
                    builder: (_, AsyncSnapshot<String> snapshot) {
                      return new Text(snapshot.data ?? '',
                          style:
                          const TextStyle(
                              color: Color.fromARGB(255, 0, 155, 0)));
                    }),
              ]
              )
              ]
              )
            ]
        )
    )
    ;
  }

  bool visibilityTag = true;
  void _changed(bool visibility, String field) {
    setState(() {
      if (field == "tag") {
        visibilityTag = visibility;
      }
    });

    void signOut() {
      //signing out the *current* user
      _auth.signOut();
      print('Signed Out!');
      userUid = null;
    }
  }
}

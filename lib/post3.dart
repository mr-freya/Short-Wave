import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';
import 'package:firebasetrychat/main.dart';

import 'package:firebasetrychat/timestamp.dart';
import 'package:firebasetrychat/postFunction.dart';

import 'package:firebasetrychat/displayFunction.dart';

ScrollController _postscrollController = new ScrollController();

class Post3 extends StatefulWidget {
  final FirebaseUser user;
  final FirebaseUser currentUser;

  Post3({this.user, this.currentUser, Key key})
      : super(key: key);
  @override
  State createState() => new Post3State();

  void initState() {}
}

class Post3State extends State<Post3>
    with AutomaticKeepAliveClientMixin<Post3> {
  List<MaterialColor> colours = [Colors.teal, Colors.lime, Colors.yellow];
  TextEditingController _controller = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseUser user;
  final FirebaseUser currentUser;

  Post3State({this.user, this.currentUser});

  double sliderValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new RefreshIndicator(
        backgroundColor: Colors.black38,
        color: Colors.purpleAccent,
        displacement: 40.0,
        child: new Container(
            child: new Column(
              children: <Widget>[

                //Add stuff Here

//                new Container(
//
//                  margin: EdgeInsets.all(10.0),
//
//                  child:
//                  new Slider(
//                    //visual
//                      label: "slider",
//                      activeColor: Colors.grey,
//                      //functional
//                      value: sliderValue,
//                      min: 0.0,
//                      max: 100.0,
//                      onChanged: (double newValue) {
//                        setState(() {
//                          sliderValue = newValue;
//                          print("The new value is : " + "$newValue");
//                        });
//                      }
//                  ),
//                ),

                new Row(children: <Widget>[
                  new Container(

                  ),
                  new Container(
                      decoration: new BoxDecoration(
                        color: Colors.blue,
                        border: new Border.all(
                          color: Colors.black,
                          width: .4,
                        ),
                      ),
                      width: 65.0,
                      height: 65.0,
                      margin: EdgeInsets.all(0.0),
                      //color: Colors.green,
                      child: new FlatButton(
                          onPressed: () {
                            indicator = 1;
                            print(indicator);
                            _handleRefresh();
                          },
                          child: Text("Day"))),
                  new Container(
                      decoration: new BoxDecoration(
                        color: Colors.lightBlue,
                        border: new Border.all(
                          color: Colors.black,
                          width: .4,
                        ),
                      ),
                      width: 65.0,
                      height: 65.0,
                      margin: EdgeInsets.all(0.0),
                      // color: Colors.green,
                      child: new FlatButton(
                          onPressed: () {
                            indicator = 2;
                            print(indicator);
                            _handleRefresh();
                          },
                          child: Text("Week"))),
                  new Container(
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        border: new Border.all(
                          color: Colors.black,
                          width: .4,
                        ),
                      ),
                      width: 75.0,
                      height: 65.0,
                      margin: EdgeInsets.all(0.0),
                      //color: Colors.green,
                      child: new FlatButton(
                          onPressed: () {
                            indicator = 3;
                            print(indicator);
                            _handleRefresh();
                          },
                          child: Text("Month"))),
                  new Container(
                      decoration: new BoxDecoration(
                        color: Colors.blueGrey,
                        border: new Border.all(
                          color: Colors.black,
                          width: .4,
                        ),
                      ),
                      width: 65.0,
                      height: 65.0,
                      margin: EdgeInsets.all(0.0),
                      //color: Colors.green,
                      child: new FlatButton(
                          onPressed: () {
                            indicator = 4;
                            print(indicator);
                            _handleRefresh();
                          },
                          child: Text("Year"))),
                ]),
                new Flexible(
                  child: new StreamBuilder(
                    stream: Firestore.instance
                        .collection('jod')
                    //.orderBy('numComm')
                    //.orderBy("timestamp")
                    //.orderBy("votes")
                        .snapshots(),
                    builder: (context, snapshot) {
                      try {
                        return new ListView.builder(
                            controller: _postscrollController,
                            itemCount: snapshot.data.documents.length,
                            reverse: false,
                            itemBuilder: (context, index) {
                              int reversedIndex =
                                  snapshot.data.documents.length - 1 - index;
                              DocumentSnapshot documentsnapshot =
                              snapshot.data.documents[reversedIndex];

                              return new GestureDetector(
                                onTap: () {
                                  docSnap = documentsnapshot;
                                  docID = (documentsnapshot.reference.documentID);
                                  Navigator.of(context).pushNamed("/comments");
                                },

                                child: displayPostController(documentsnapshot)
                                    ? new Card(
                                    margin: const EdgeInsets.only(
                                      //width between
                                        top: 0.0,
                                        bottom: 10.0,
                                        left: 0.0,
                                        right: 0.0),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius
                                          .all(Radius.circular(0.0)),
                                    ),
                                    color: Colors.white,
                                    elevation: 5.0,
                                    child: new Container(
                                      child: new Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            new Row(children: <Widget>[
                                              new Container(
                                                //timestamp
                                                //controls the text distance from the left margin
                                                padding: const EdgeInsets.only(
                                                  left: 15.0,
                                                  top: 10.0,
                                                  bottom: 10.0,
                                                  right: 90.0,
                                                ),
                                                child: new Text(
                                                  getTimestamp(documentsnapshot['timestamp']),
                                                  style: new TextStyle(
                                                    color: Colors.blueGrey,
                                                    //fontWeight: FontWeight.bold,
                                                    fontSize:
                                                    14.0, //should be 16, and grey (as is)
                                                  ),
                                                ),
                                              ),
                                              new FlatButton(
                                                splashColor:
                                                Colors.yellow,
                                                onPressed: () {
                                                  report(
                                                      documentsnapshot);
                                                },
                                                child: new Text(
                                                  "Report",
                                                  style: new TextStyle(
                                                    color: reported(documentsnapshot) == true? Colors.red: Colors.grey,
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                              )
                                            ]),
                                            new Row(children: <Widget>[
                                              new Container(
                                                //controls the text distance from the left margin
                                                padding: const EdgeInsets.only(
                                                  left: 25.0,
                                                  top: 0.0,
                                                  bottom: 0.0,
                                                  right: 0.0,
                                                ),
                                              ),
                                              new Expanded(
                                                child: new SizedBox(
                                                  //just the text
                                                  //height: 250.0,
                                                  width: 265.0,

                                                  child: new Text(
                                                    "${documentsnapshot['text']}",
                                                    textScaleFactor: 1.4,
                                                    style: new TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              new Container(
                                                //button's width
                                                height: 100.0,
                                                width: 0.0,
                                                margin: const EdgeInsets.only(
                                                  top: 0.0,
                                                  bottom: 0.0,
                                                  left: 0.0,
                                                  right: 10.0,
                                                ),
                                              ),
                                            ]),
                                            new Row(
                                              children: <Widget>[
                                                new Container(
                                                  width: 50.0,
                                                  height: 30.0,
                                                  margin: const EdgeInsets.only(
                                                    top: 0.0,
                                                    bottom:15.0,
                                                    left: 10.0,
                                                    right: 5.0,
                                                  ),
                                                  child:
                                                  ButtonTheme(
                                                      minWidth: 10.0,
                                                      height: 10.0,
                                                      child:
                                                      new IconButton(
                                                        icon: new Icon(liked(documentsnapshot) == true? Icons.star: Icons.star_border,),
                                                        tooltip: 'Like a Post',
                                                        onPressed: () { LikePost(
                                                            documentsnapshot); },
                                                      )
                                                  ),
                                                ),
                                                new Container(
                                                    margin: const EdgeInsets.only(
                                                      top: 0.0,
                                                      bottom:0.0,
                                                      left: 0.0,
                                                      right: 15.0,
                                                    ),
                                                    child: new Text(
                                                      "${documentsnapshot['votes']}",
                                                      style:
                                                      TextStyle(
                                                        color: Colors
                                                            .blueGrey,
                                                        fontSize:
                                                        16.0,
                                                        // fontWeight: FontWeight.bold,
                                                        //fontStyle: FontStyle.italic,
                                                        //fontFamily: importing
                                                      ),
                                                      //textScaleFactor: 2.0,
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                    )
                                                ),
                                                new Container(
                                                  padding:
                                                  const EdgeInsets.only(
                                                    left: 0.0,
                                                    top: 00.0,
                                                    bottom: 0.00,
                                                    right: 0.0,
                                                  ),
                                                  child: new IconButton(
                                                    icon: new Icon(Icons.insert_comment),
                                                    tooltip: 'See comments',
                                                    onPressed: () {
                                                    docID =
                                                    (documentsnapshot
                                                        .reference
                                                        .documentID);
                                                    Navigator
                                                        .of(context)
                                                        .pushNamed(
                                                        "/comments"); },
                                                  ),
                                                ),
                                                cum().commen(documentsnapshot),
                                              ],
                                            ),
                                            new Container(
                                              margin: EdgeInsets.only(
                                                top: 0.0,
                                              ),
                                              foregroundDecoration:
                                              new StrikeThroughDecoration(),
                                            ),
                                          ]),
                                    ))
                                    : new Container(),
                              );
                            });
                      } catch (e) {
                        return new Center(child: new CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ],
            )),
        onRefresh: _handleRefresh,
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 1));
    setState(() {});
    return null;
  }

  @override
  bool get wantKeepAlive => true;
}
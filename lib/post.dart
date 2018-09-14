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

class Post extends StatefulWidget {
  final FirebaseUser user;
  final FirebaseUser currentUser;

  Post({this.user, this.currentUser, Key key})
      : super(key: key);

  @override
  State createState() => new PostState();

  void initState() {}
}

class PostState extends State<Post> with AutomaticKeepAliveClientMixin<Post> {
  List<MaterialColor> colours = [Colors.teal, Colors.lime, Colors.yellow];

  final _formKey = GlobalKey<FormState>();
  final FirebaseUser user;
  final FirebaseUser currentUser;

  PostState({this.user, this.currentUser});

  TextEditingController _controller = new TextEditingController();

  void newPost() {
    setState(() {
      CollectionReference cr = Firestore.instance.collection("jod");
      cr.add({
        "text": _controller.text,
        "votes": 0,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
        "user": userUid,
        "voters": [],
        "reporters": [],
        "reports": 0,
        "numComm": 0,
      }).whenComplete(() {
        print("Transaction Complete");
        _controller.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black12,
      body: new RefreshIndicator(
        backgroundColor: Colors.black38,
        color: Colors.purpleAccent,
        displacement: 40.0,
        child: new Container(
            child: new Column(
          children: <Widget>[
            new Flexible(
              child: new StreamBuilder(
                stream: Firestore.instance.collection('jod').snapshots(),
                builder: (context, snapshot) {
                  try {
                    return new Scrollbar(
                        child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
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
                                  _handleRefresh();
                                  docSnap = documentsnapshot;
                                  docID =
                                      (documentsnapshot.reference.documentID);
                                  Navigator.of(context).pushNamed("/comments");
                                },
                                child: new Card(
                                        margin: const EdgeInsets.only(
                                            //width between
                                            top: 0.0,
                                            bottom: 0.0,
                                            left: 0.0,
                                            right: 0.0),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(0.0)),
                                        ),
                                        color: Colors.white,
                                        elevation: 0.0,
                                        child: new Container(
                                          child: new Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                new Container(
                                                  //title text
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 30.0,
                                                    top: 10.0,
                                                    //makes the entire card itself bigger
                                                    bottom: 0.0,
                                                    right: 10.0,
                                                  ),
                                                ),
                                                new Row(children: <Widget>[
                                                  new Container(
                                                    //TIMESTAMP
                                                    //controls the text distance from the left margin
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 15.0,
                                                      top: 0.0,
                                                      bottom: 10.0,
                                                      right: 0.0,
                                                    ),
                                                    child: new Text(
                                                      getTimestamp(
                                                          documentsnapshot[
                                                              'timestamp']),
                                                      style: new TextStyle(
                                                        color: Colors.grey,
                                                        //fontWeight: FontWeight.bold,
                                                        fontSize:
                                                            14.0, //should be 16, and grey (as is)
                                                      ),
                                                    ),
                                                  ),
                                                  new Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 15.0,
                                                      top: 0.0,
                                                      bottom: 10.0,
                                                      right: 0.0,
                                                    ),
                                                    child: new FlatButton(
                                                            splashColor:
                                                                Colors.yellow,
                                                            onPressed: () {
                                                              report(
                                                                  documentsnapshot);
                                                            },
                                                            child: new Text(
                                                              "Report",
                                                              style:
                                                                  new TextStyle(
                                                                color: reported(
                                                                            documentsnapshot) ==
                                                                        true
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .grey,
                                                                fontSize: 15.0,
                                                              ),
                                                            ),
                                                          )
                                                  ),
                                                ]),
                                                new Row(children: <Widget>[
                                                  new Container(
                                                    //controls the text distance from the left margin
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 15.0,
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
                                                    margin:
                                                        const EdgeInsets.only(
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
                                                      width: 180.0,
                                                      height: 50.0,
                                                      margin:
                                                          const EdgeInsets.only(
                                                        top: 0.0,
                                                        bottom: 0.0,
                                                        left: 00.0,
                                                        right: 0.0,
                                                      ),
                                                      child: ButtonTheme(
                                                          shape: new RoundedRectangleBorder(
                                                              borderRadius: new BorderRadius
                                                                      .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          15.0))),
                                                          minWidth: 10.0,
                                                          height: 10.0,
                                                          child: new FlatButton(
                                                              splashColor:
                                                                  Colors.blue,
                                                              onPressed: () {
                                                                LikePost(
                                                                    documentsnapshot);
                                                              },
                                                              child: new Text(
                                                                "Yays: ${documentsnapshot['votes']}",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .blueGrey,
                                                                  fontSize:
                                                                      20.0,
                                                                  // fontWeight: FontWeight.bold,
                                                                  //fontStyle: FontStyle.italic,
                                                                  //fontFamily: importing
                                                                ),
                                                                //textScaleFactor: 2.0,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ))),
                                                    ),
                                                    new Container(
                                                      width: 140.0,
                                                      height: 50.0,
                                                      margin:
                                                          const EdgeInsets.only(
                                                        top: 0.0,
                                                        bottom: 0.0,
                                                        left: 00.0,
                                                        right: 0.0,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: 0.0,
                                                        top: 00.0,
                                                        bottom: 00.0,
                                                        right: 0.0,
                                                      ),
                                                      child: FlatButton(
                                                        shape: new RoundedRectangleBorder(
                                                            borderRadius:
                                                                new BorderRadius
                                                                        .only(
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            15.0))),
                                                        splashColor: Colors.red,
                                                        onPressed: () {
                                                          docSnap = documentsnapshot;
                                                          docID =
                                                              (documentsnapshot
                                                                  .reference
                                                                  .documentID);
                                                          Navigator.of(context)
                                                              .pushNamed(
                                                                  "/comments");
                                                        },
                                                        child: new Text(
                                                          "Replies: ",
                                                          style: new TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 18.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    new Container(
                                                      margin: EdgeInsets.only(
                                                        top: 25.0,
                                                        bottom: 0.0,
                                                      ),
                                                      foregroundDecoration:
                                                          new StrikeThroughDecoration(),
                                                    ),
                                                    cum().commen(
                                                        documentsnapshot),
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
                              );
                            }));
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: new FloatingActionButton(
          child: new Icon(
            Icons.add_box,
            size: 55.0,
          ),
          backgroundColor: Colors.blue, //or transparent
          foregroundColor: Colors.white,
          onPressed: () {
            showBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return new Container(
                      color: Colors.grey,
                      height: 750.0,
                      child: new Column(children: <Widget>[
                        Container(
                          height: 0.0,
                          width: 50.0,
                        ),
                        Container(
                          child: new Form(
                            key: _formKey,
                            child: new TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please Enter A Message';
                                }
                              },
                              maxLines: 12,
                              maxLength: 410,
                              maxLengthEnforced: true,
                              decoration: new InputDecoration(
                                hintText: "What's up? Tell Your Community.",
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              controller: _controller,
                            ),
                          ),
                        ),
                        new Row(children: <Widget>[
                          new Container(
                              height: 45.0,
                              width: 180.0,
                              margin: const EdgeInsets.only(
                                top: 5.0,
                                // bottom: 0.0,
                                // left: 0.0,
                                //right: 0.0,
                              ),
                              child: new ButtonTheme(
                                  minWidth: 100.0,
                                  height: 70.0,
                                  child: new RaisedButton(
                                    color: Colors.red,
                                    elevation: 20.0,
                                    splashColor: Colors.white,
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(0.0)),
                                    child: new Text(
                                      "Back",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                        //fontStyle: FontStyle.italic,
                                        //fontFamily: importing
                                      ), //textScaleFactor: 1.0,
                                      textAlign: TextAlign.center,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(
                                        context,
                                      );
                                    },
                                  ))),
                          new Container(
                              height: 45.0,
                              width: 180.0,
                              margin: const EdgeInsets.only(
                                top: 5.0,
                                // bottom: 0.0,
                                left: 15.0,
                                //right: 0.0,
                              ),
                              child: new ButtonTheme(
                                  minWidth: 100.0,
                                  height: 70.0,
                                  child: new RaisedButton(
                                    color: Colors.blue,
                                    elevation: 20.0,
                                    splashColor: Colors.white,
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(0.0)),
                                    child: new Text(
                                      "Send!",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                        //fontStyle: FontStyle.italic,
                                        //fontFamily: importing
                                      ), //textScaleFactor: 1.0,
                                      textAlign: TextAlign.center,
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        _postscrollController.animateTo(0.0,
                                            curve: Curves.easeOut,
                                            duration: const Duration(
                                                milliseconds: 10));

                                        newPost();
                                        Navigator.pop(
                                          context, //iossuel
                                        );
                                        _handleRefresh;
                                      } else {
                                        print("yeet");
                                      }
                                    },
                                  )))
                        ])
                      ]));
                });
          }),
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

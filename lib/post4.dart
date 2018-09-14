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

class Post4 extends StatefulWidget {
  final FirebaseUser user;
  final FirebaseUser currentUser;

  Post4({this.user, this.currentUser, Key key})
      : super(key: key);

  @override
  State createState() => new Post4State();

  void initState() {}
}

class Post4State extends State<Post4>
    with AutomaticKeepAliveClientMixin<Post4> {
  List<MaterialColor> colours = [Colors.teal, Colors.lime, Colors.yellow];
  TextEditingController _controller = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseUser user;
  final FirebaseUser currentUser;

  Post4State({this.user, this.currentUser});

  void Like(DocumentSnapshot dss) {
    DocumentReference drr =
    Firestore.instance.document("jod/" + dss.reference.documentID);
    List<dynamic> voters = new List();
    bool status = true;
    print(dss["voters"]);
    for (var i = 0; i < dss["voters"].length; i++) {
      voters.add(dss["voters"][i]);
    }

    print(voters.length);
    print(dss["votes"]);
    int votes = dss["votes"];
    setState(() {
      for (var i = 0; i < voters.length; i++) {
        print(i);
        if (voters[i] == userUid) {
          voters.removeAt(i);
          print(voters);
          drr.updateData({'voters': voters});
          print("before");
          print(votes);
          votes = votes - 1;
          drr.updateData({'votes': votes});
          print("after");
          print(votes);
          print(dss.reference.documentID + "was downvoted");
          status = false;
          break;
        }
      }

      if (status == true) {
        voters.add(userUid);
        drr.updateData({'voters': voters});
        votes = votes + 1;
        drr.updateData({'votes': votes});
        print(dss.reference.documentID + "was upvoted");
      }
    });
  }

  void report(DocumentSnapshot dss) {
    DocumentReference drr =
    Firestore.instance.document("jod/" + dss.reference.documentID);
    List<dynamic> reporters = new List();
    bool status = true;
    print(dss["reporters"]);
    for (var i = 0; i < dss["reporters"].length; i++) {
      reporters.add(dss["reporters"][i]);
    }

    print(reporters.length);
    print(dss["reporters"]);
    int reports = dss["reports"];
    setState(() {
      for (var i = 0; i < reporters.length; i++) {
        print(i);
        if (reporters[i] == userUid) {
          reporters.removeAt(i);
          print(reporters);
          drr.updateData({'reporters': reporters});
          print("before");
          print(reports);
          reports = reports - 1;
          drr.updateData({'reports': reports});
          print("after");
          print(reports);
          print(dss.reference.documentID + "was downvoted");
          status = false;
          break;
        }
      }

      if (status == true) {
        reporters.add(userUid);
        drr.updateData({'reporters': reporters});
        reports = reports + 1;
        drr.updateData({'reports': reports});
        print(dss.reference.documentID + "was reported");
      }
    });
  }

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
      backgroundColor: Colors.white,
      body: new RefreshIndicator(
        backgroundColor: Colors.black38,
        color: Colors.purpleAccent,
        displacement: 40.0,
        child: new Container(
            child: new Column(
              children: <Widget>[
                new Row(children: <Widget>[

                  new Row(children: <Widget>[

                    new Container(
                        decoration: new BoxDecoration(
                          color: Colors.grey,
                          border: new Border.all(
                            color: Colors.black,
                            width: .4,
                          ),
                        ),
                        width: 125.0,
                        height: 65.0,
                        margin: EdgeInsets.all(0.0),
                        //color: Colors.green,
                        child: new FlatButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed("/Rules2");
                            },
                            child: Text("My Posts"))),
                    new Container(
                        decoration: new BoxDecoration(
                          color: Colors.blue,
                          border: new Border.all(
                            color: Colors.black,
                            width: .4,
                          ),
                        ),
                        width: 125.0,
                        height: 65.0,
                        margin: EdgeInsets.all(0.0),
                        //color: Colors.green,
                        child: new FlatButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed("/Rules2");
                            },
                            child: Text("My Replies"))),
                    new Container(
                        decoration: new BoxDecoration(
                          color: Colors.lightBlue,
                          border: new Border.all(
                            color: Colors.black,
                            width: .4,
                          ),
                        ),
                        width: 125.0,
                        height: 65.0,
                        margin: EdgeInsets.all(0.0),
                        // color: Colors.green,
                        child: new FlatButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed("/Rules2");
                            },
                            child: Text("My Liked"))),
                  ]),
                ]),
                new Flexible(
                  child: new StreamBuilder(
                    stream: Firestore.instance
                        .collection('jod')
                        .snapshots(),
                    builder: (context, snapshot) {
                      try {
                        return new ListView.builder(
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
                                  docID =
                                  (documentsnapshot.reference.documentID);
                                  Navigator.of(context).pushNamed("/comments");
                                },

                                child: myPost(documentsnapshot)
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
                                    elevation: 0.0,
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
                                                  left: 25.0,
                                                  top: 10.0,
                                                  bottom: 10.0,
                                                  right: 75.0,
                                                ),
                                                child: new Text(
                                                  getTimestamp(
                                                      documentsnapshot['timestamp']),
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
                                                    color: reported(
                                                        documentsnapshot) ==
                                                        true
                                                        ? Colors.red
                                                        : Colors.grey,
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
                                                  width: 130.0,
                                                  height: 30.0,
                                                  margin: const EdgeInsets.only(
                                                    top: 15.0,
                                                    bottom: 15.0,
                                                    left: 0.0,
                                                    right: 105.0,
                                                  ),
                                                  child: ButtonTheme(
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
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .blueGrey,
                                                              fontSize: 20.0,
                                                              // fontWeight: FontWeight.bold,
                                                              //fontStyle: FontStyle.italic,
                                                              //fontFamily: importing
                                                            ),
                                                            //textScaleFactor: 2.0,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ))),
                                                ),
                                                new Container(
                                                  padding:
                                                  const EdgeInsets.only(
                                                    left: 0.0,
                                                    top: 00.0,
                                                    bottom: 00.0,
                                                    right: 0.0,
                                                  ),
                                                  child: FlatButton(
                                                    splashColor: Colors.red,
                                                    onPressed: () {
                                                      docID = (documentsnapshot
                                                          .reference
                                                          .documentID);
                                                      Navigator
                                                          .of(context)
                                                          .pushNamed(
                                                          "/comments");
                                                    },
                                                    child: new Text(
                                                      "Replies:",
                                                      style: new TextStyle(
                                                        color: Colors.blue,
                                                        fontSize: 18.0,
                                                      ),
                                                    ),
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
                        return new Center(
                            child: new CircularProgressIndicator());
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
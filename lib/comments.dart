import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';
import 'package:firebasetrychat/main.dart';
import 'package:firebasetrychat/timestamp.dart';
import 'package:firebasetrychat/postFunction.dart';
import 'package:firebasetrychat/displayFunction.dart';

ScrollController _commentscrollController = new ScrollController();

final _formKey = GlobalKey<FormState>();
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


class Comments extends StatefulWidget {

  @override
  State createState() => new _CommentsState();
}

class _CommentsState extends State<Comments> {
  AsyncSnapshot r(AsyncSnapshot s) {
    return s;
  }

  AsyncSnapshot snap;
  TextEditingController _controller = new TextEditingController();

  void newComment() {
    setState(() {
      CollectionReference cr2 = Firestore.instance.collection("jod/$docID/comm");
      DocumentReference dr2 = Firestore.instance.document("jod/$docID");

      String cont;
      String author;

      cont = _controller.text;
      author = userUid;

      int numberOfComments = docSnap["numComm"];
      numberOfComments = numberOfComments + 1;

      cr2.add({
        "comments": cont,
        "author": author,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
        "voters": [],
        "votes": 0,
        "reporters": [],
        "reports": 0,
      });

      dr2.updateData({"numComm": numberOfComments});

      _controller.clear();
    });
  }

  void Like(DocumentSnapshot dss) {
    DocumentReference drr = Firestore.instance
        .document("jod/" + docID + "/comm/" + dss.reference.documentID);
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
    DocumentReference drr = Firestore.instance
        .document("jod/" + docID + "/comm/" + dss.reference.documentID);
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        backgroundColor: Colors.blueGrey,
        title: new Text("Replies"),
      ),
      backgroundColor: Colors.grey,
      body: RefreshIndicator(
        backgroundColor: Colors.black38,
        color: Colors.purpleAccent,
        displacement: 40.0,
        child: Column(children: <Widget>[
          new Flexible(
              child: new StreamBuilder(
            stream:
                Firestore.instance.collection('jod/$docID/comm').snapshots(),
            builder: (context, snapshot) {
              try {
                return new  Scrollbar(child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _commentscrollController,
                      //itemExtent: 50.0,
                      itemCount: snapshot.data.documents.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          // return the header
                          return new Container(
                              //height: 250.0,
                              width: 500.0,
                              child: new GestureDetector(
                                  onTap: () {
                                    _handleRefresh();
                                  },
                                  child: new Card(
                                      margin: const EdgeInsets.only(
                                          //width between
                                          top: 0.0,
                                          bottom: 5.0,
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 25.0,
                                                    top: 10.0,
                                                    bottom: 10.0,
                                                    right: 75.0,
                                                  ),
                                                ),
                                                new FlatButton(
                                                        splashColor:
                                                            Colors.yellow,
                                                        onPressed: () {
                                                          null;
                                                        },
                                                        child: new Text(
                                                          "Report",
                                                          style: new TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 15.0,
                                                          ),
                                                        ),
                                                      )
                                              ]
                                              ),
                                              new Row(children: <Widget>[
                                                new Container(
                                                  //controls the text distance from the left margin
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                      "${docSnap['text']}",
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
                                                    margin:
                                                        const EdgeInsets.only(
                                                      top: 0.0,
                                                      bottom: 15.0,
                                                      left: 10.0,
                                                      right: 5.0,
                                                    ),
                                                    child: ButtonTheme(
                                                        minWidth: 10.0,
                                                        height: 10.0,
                                                        child: new IconButton(
                                                          icon: new Icon(liked(docSnap) == true? Icons.star: Icons.star_border,),
                                                          tooltip: 'Like a Post',
                                                          onPressed: () {
                                                            //LikePost(docSnap);
                                                            //_handleRefresh();
                                                            },
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
                                                        "${docSnap['votes']}",
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
                                                ],
                                              ),
                                            ]
                                        ),
                                      )
                                  )
                                  )
                          );
                        }
                        index -= 1;
                        DocumentSnapshot documentsnapshot =
                            snapshot.data.documents[index];
                        return new Container(
                            child: new GestureDetector(
                                onTap: () {
                                  _handleRefresh();
                                },
                                child: new Card(
                                    margin: const EdgeInsets.only(
                                        //width between
                                        top: 0.0,
                                        bottom: 0.0,
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
                                                getTimestamp(documentsnapshot[
                                                    'timestamp']),
                                                style: new TextStyle(
                                                  color: Colors.blueGrey,
                                                  //fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      14.0, //should be 16, and grey (as is)
                                                ),
                                              ),
                                            ),
                                            new Container(
                                                height: 20.0,
                                                child: new FlatButton(
                                                  splashColor: Colors.yellow,
                                                  onPressed: () {
                                                    report(documentsnapshot);
                                                    _handleRefresh;
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
                                                ))
                                          ]
                                          ),
                                          new Row(children: <Widget>[
                                            new Container(
                                              height: 20.0,
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
                                                  "${documentsnapshot["comments"]}",
                                                  textScaleFactor: 1.4,
                                                  style: new TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            new Container(
                                              //button's width
                                              height: 00.0,
                                              width: 0.0,
                                              margin: const EdgeInsets.only(
                                                top: 0.0,
                                                bottom: 0.0,
                                                left: 0.0,
                                                right: 10.0,
                                              ),
                                            ),
                                          ]
                                          ),
                                          new Row(children: <Widget>[

                                            new Container(
                                              width: 50.0,
                                              height: 30.0,
                                              margin:
                                              const EdgeInsets.only(
                                                top: 0.0,
                                                bottom: 15.0,
                                                left: 10.0,
                                                right: 5.0,
                                              ),
                                              child: ButtonTheme(
                                                  minWidth: 10.0,
                                                  height: 10.0,
                                                  child: new IconButton(
                                                    icon: new Icon(liked(documentsnapshot) == true? Icons.star: Icons.star_border,),
                                                    tooltip: 'Like a Post',
                                                    onPressed: () { Like(
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

                                          ]
                                          ),
                                          new Container(
                                            margin: EdgeInsets.only(
                                              top: 0.0,
                                            ),
                                            foregroundDecoration:
                                                new StrikeThroughDecoration(),
                                          ),
                                        ]
                                        )
                                    )
                                )
                            )
                        );
                      },
                    )
                );
              } catch (e) {
                return new Center(
                  child: new Text("No Comments To Show Here!"),
                );
              }
            },
          )
          ),
        ]
        ),
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
            _scaffoldKey.currentState
                .showBottomSheet<void>((BuildContext context) {
              return new Container(
                      color: Colors.grey,
                      height: 800.0,
                      child: new Column(children: <Widget>[
                        Container(
                          height: 100.0,
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
                              maxLines: 8,
                              maxLength: 200,
                              maxLengthEnforced: true,
                              decoration: new InputDecoration(
                                hintText: "Reply to this Post",
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
                                  )
                              )
                          ),
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
                                        _commentscrollController.animateTo(0.0,
                                            curve: Curves.easeOut,
                                            duration: const Duration(
                                                milliseconds: 10));
                                        newComment();
                                        _commentscrollController.animateTo(0.0,
                                            curve: Curves.easeOut,
                                            duration: const Duration(
                                                milliseconds: 10));
                                        Navigator.pop(
                                          context, );//iossuel
                                            _commentscrollController.animateTo(0.0,
                                                curve: Curves.easeOut,
                                                duration: const Duration(
                                                    milliseconds: 10));

                                        _handleRefresh;
                                      } else {
                                        print("yeet");
                                      }
                                    },
                                  )
                              )
                          )
                        ]
                        )
                      ]
                      )
              );
                });
          }),
    );
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 1));
    setState(() {});
    return null;
  }
}

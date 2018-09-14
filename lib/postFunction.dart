import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';
import 'package:firebasetrychat/main.dart';
import 'package:firebasetrychat/post.dart';
import 'post.dart';

void LikePost(DocumentSnapshot dss) {
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
}

class cum {
  Widget commen(DocumentSnapshot d) {
    String numberofComments;
    try {
      numberofComments = ("${d['numComm']}");
    } catch (e) {
      numberofComments = "0";
    }
    return new Text(
      numberofComments,
      style: new TextStyle(
        color: Colors.blueGrey,
        //fontWeight: FontWeight.bold,
        fontSize: 16.0, //should be 16 but timestamp messing up
      ),
    );
  }
}
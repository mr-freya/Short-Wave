import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';
import 'package:firebasetrychat/main.dart';
import 'package:firebasetrychat/post.dart';
import 'post.dart';

int indicator; //0,1,2,3,4

bool myPost(DocumentSnapshot dsc) {
  if (dsc["user"] == userUid) {
    return true;
  }
  else {
    return false;
  }
}

bool displayPostController(DocumentSnapshot dcc) {
  int postDate = dcc["timestamp"];
  int timeNow = DateTime.now().millisecondsSinceEpoch;

  if (indicator == null) {
    return true;
  }
  if (indicator == 0) {
    if (timeNow-postDate > 3600000) { //hour
      return false;
    }
    else {
      return true;
    }
  }
  if (indicator == 1) {
    if (timeNow-postDate > 86400000) { //day
      return false;
    }
    else {
      return true;
    }
  }
  if (indicator == 2) {
    if (timeNow-postDate > 604800000) { //week
      return false;
    }
    else {
      return true;
    }
  }
  if (indicator == 3) {
    if (timeNow-postDate > 18446400000) { //month
      return false;
    }
    else {
      return true;
    }
  }
  if (indicator == 4) {
    if (timeNow-postDate > 31449600000) { //year
      return false;
    }
    else {
      return true;
    }
  }
  return true;
}

bool reported(DocumentSnapshot doc) {
  List<dynamic> reporters = new List();

  for (var i = 0; i < doc["reporters"].length; i++) {
    reporters.add(doc["reporters"][i]);
  }

  for (var i = 0; i < reporters.length; i++) {
    print(i);
    if (reporters[i] == userUid) {
      return true;
    }
  }
  return false;
}

bool liked(DocumentSnapshot doc) {
  List<dynamic> voters = new List();

  for (var i = 0; i < doc["voters"].length; i++) {
    voters.add(doc["voters"][i]);
  }

  for (var i = 0; i < voters.length; i++) {
    print(i);
    if (voters[i] == userUid) {
      return true;
    }
  }
  return false;
}

class StrikeThroughDecoration extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback onChanged]) {
    return new _StrikeThroughPainter();
  }
}

class _StrikeThroughPainter extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final paint = new Paint()
      ..strokeWidth = .5
      ..color = Colors.grey
      ..style = PaintingStyle.fill;

    final rect = offset & configuration.size;
    canvas.drawLine(new Offset(rect.left, rect.top + rect.height / 2),
        new Offset(rect.right, rect.top + rect.height / 2), paint);
    canvas.restore();
  }
}
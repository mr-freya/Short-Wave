import 'package:flutter/material.dart';

class Post5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.white,
        body: new Column(children: <Widget>[
          new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  height: 674.0,
                  width: 375.0,
                  color: Colors.grey,
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) =>
                        EntryItem(data[index]),
                    itemCount: data.length,
                  ),
                )
              ]),
        ]));
  }
}

// One entry in the multilevel list displayed by this app.
class Entry {
  Entry(this.title, [this.children = const <Entry>[]]);

  final String title;
  final List<Entry> children;
}

// The entire multilevel list displayed by this app.
final List<Entry> data = <Entry>[
  Entry(
    'Follow Us',
    <Entry>[
      Entry('Facebook: '),
      Entry('Instagram: '),
      Entry('Twitter: '),
    ],
  ),
  Entry(
    'Contact Us',
    <Entry>[
      Entry('Questions, Ideas, or Looking to Contribute? : gmail...'),
      //Entry('Phone'),
    ],
  ),
  Entry(
    'About SentiFlo',
    <Entry>[
      Entry(
          'SentiFlo is a safe place to anonymously discuss Life, Politics, and Society with your community.'),
      Entry('This project is in its early infancy. Its features are currently evolving, and will continue to significantly evolve in the near future.'),

    ],
  ),
  Entry(
    'User Guidelines',
    <Entry>[
      Entry('SentiFlo champions both Free Speech and Decency. Therefore, the following are prohibited:'),
      //Entry(''),
      Entry('•Targeting individual peers'),
      Entry('•Hate Speech/Racism'),
      Entry('•Bullying, Defamation, and Impersonation'),
      Entry('•Promotion of violence or other illegal activity'),
      Entry('•Sexual harassment'),
      Entry('•Spoilers'),
      Entry('•Spam/Commercial Advertisements'),
      //Entry(''),
      //Entry(''),
      //Entry(''),
    ],
  ),
  Entry(
    'Moderation',
    <Entry>[
      Entry('Currently, SentiFlo employs a sensitive “Report” system. Report Inappropriate Posts!'),
      //Entry(''),
      Entry('Community Moderators decide to allow or remove content that violates the User Guidelines and/or reaches Report thresholds. '),
      Entry('Every user has a role in moderating their community SentiFlo. Over time, this will help develop our human moderation and machine learning moderation systems. '),
      Entry('Moderators may decide to take action against a user, including  banning them, if their behavior repeatedly or egregiously breaks the User guidelines.'),
      //Entry('•Promotion of violence or other illegal activity'),
      //Entry('•Sexual harassment'),
      // Entry('•Spoilers'),
     //Entry('•Spam/Commercial Advertisements'),
      //Entry(''),
      //Entry(''),
      //Entry(''),
    ],
  ),
  Entry(
    'Privacy Policy',
    <Entry>[
      Entry('Section C0'),
      Entry('Section C1'),
      Entry(
        'Section C2',
        <Entry>[
          Entry('Item C2.0'),
          Entry('Item C2.1'),
          Entry('Item C2.2'),
          Entry('Item C2.3'),
        ],
      ),
    ],
  ),
  Entry(
    'Terms of Use',
    <Entry>[
      Entry('Section C0'),
      Entry('Section C1'),
      Entry(
        'Section C2',
        <Entry>[
          Entry('Item C2.0'),
          Entry('Item C2.1'),
          Entry('Item C2.2'),
          Entry('Item C2.3'),
        ],
      ),
    ],
  ),
];

class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) return ListTile(title: Text(root.title));
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(root.title, style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      initiallyExpanded: false,
      children: root.children.map(_buildTiles).toList(),
      backgroundColor: Colors.black38,
      leading: Icon(Icons.filter_none),
      // trailing: Icon(Icons.favorite),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}
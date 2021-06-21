import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';

class DetailsNewList extends StatefulWidget {
  String image, desce, title;

  DetailsNewList(this.image, this.title, this.desce);

  @override
  _DetailsNewList createState() => new _DetailsNewList(image, title, desce);
}

class _DetailsNewList extends State<DetailsNewList> {
  String image, title, desce;

  _DetailsNewList(this.image, this.title, this.desce);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: const Color(0xff0e264f),
        actions: <Widget>[
          InkWell(
            onTap: () {
              share();
            },
            child: Icon(Icons.settings),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 5.0),
        child: Column(
          children: <Widget>[
            Image.network(image),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10.0, top: 5.0),
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20.0, top: 15.0),
              child: Text(
                desce,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: title,
        text: title,
        linkUrl: image,
        chooserTitle: 'Example Chooser Title');
  }
}

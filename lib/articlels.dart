import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          body: Container(
            margin: EdgeInsets.only(top: 20.0),
            child: Column(
              children: <Widget>[
                Image.network(image),
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  desce,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),),
        ));
  }
}

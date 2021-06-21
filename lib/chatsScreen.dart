import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:flutter_tech/user_model.dart';

import 'messageModel.dart';

class ChatScreen extends StatefulWidget {
  String user;
  String sm, image;

  ChatScreen({this.user, this.sm, this.image});

  @override
  _ChatScreenState createState() => _ChatScreenState(sm,image);
}

class _ChatScreenState extends State<ChatScreen> {
  String sm,image;

  _ChatScreenState(this.sm, this.image);

  bool test = false;
  String strtest = "";
  final databaseReference = FirebaseDatabase.instance.reference().child("Details");

  addData(String name, message, number, image) {
    Map <String, String> details = {
      'name': name,
      'message': message,
      'number': number,
      'image': image,
    };
    databaseReference.push().set(details);
  }

  _sendMessageArea() {
    print("hii");

    final myController = TextEditingController();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25,
            color: Theme
                .of(context)
                .primaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: myController,
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message..',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25,
            color: Theme
                .of(context)
                .primaryColor,
            onPressed: () {
              addData(widget.user,myController.text,sm,image);
              setState(() {
                strtest = myController.text;
                test = true;
              });
              //_chatBubble()

            },
          ),
        ],
      ),
    );
  }

  _chatBubble(Message message, bool isMe, bool isSameUser) {
    print("hello");
    if (isMe) {
      return Visibility(
          visible: test,
          child: Column(
            children: <Widget>[
              Container(
                  alignment: Alignment.topRight,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(

                          constraints: BoxConstraints(
                            maxWidth: MediaQuery
                                .of(context)
                                .size
                                .width * 0.80,
                          ),
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.lightGreen,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Text(
                            strtest,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Card(
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0)),
                                    color: Colors.black),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, top: 5, bottom: 5, right: 10),
                                  child: Text(
                                    "Get in touch with us on any of our social media",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                EdgeInsets.only(left: 10, bottom: 10, top: 10),
                                child: Row(
                                  children: [

                                    InkWell(
                                      onTap: () {
                                        whatsAppOpen(sm);
                                      },
                                      child: Card(
                                        child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Column(
                                            children: [
                                              Icon(Icons.whatshot_sharp),
                                              Text("Whats App",
                                                style: TextStyle(
                                                    fontSize: 12.0),)
                                            ],
                                          ),
                                        ),
                                      ),)

                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ))


      ;
    } else {
      /*return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Container(child: Column(children: [
                Text(
                  message.text,
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
                ],),),
            ),
          ),
          !isSameUser
              ? Row(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 15,
                  backgroundImage: AssetImage(message.sender.imageUrl),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                message.time,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black45,
                ),
              ),
            ],
          )
              : Container(
            child: null,
          ),
        ],
      );*/
    }
  }

  @override
  Widget build(BuildContext context) {
    int prevUserId;
    return Scaffold(
      backgroundColor: Color(0xFFF0F2F8),
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                  text: widget.user,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  )),
              /*TextSpan(text: '\n'),
              widget.user.isOnline ?
              TextSpan(
                text: 'Online',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              )
                  :
              TextSpan(
                text: 'Offline',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              )*/
            ],
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: false,
              padding: EdgeInsets.all(20),
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                final Message message = messages[index];
                final bool isMe = message.sender.id == currentUser.id;
                final bool isSameUser = prevUserId == message.sender.id;
                prevUserId = message.sender.id;
                return _chatBubble(message, isMe, isSameUser);
              },
            ),
          ),
          _sendMessageArea(),
        ],
      ),
    );
  }
}


void whatsAppOpen(String sm) async {
  bool whatsapp = true;

  if (whatsapp) {
    await FlutterOpenWhatsapp.sendSingleMessage(
        sm, "Hello, Digisoft solution here");
  } else {
    print("Whatsapp não instalado");
  }
}

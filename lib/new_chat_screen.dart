import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'fullimage.dart';

class ChatPage extends StatefulWidget {
  String user, image, userId;
  List sm;

  ChatPage({this.user, this.sm, this.image, this.userId});

  @override
  _ChatPage createState() =>
      _ChatPage(user: user, sm: sm, image: image, userId: userId);
}

class _ChatPage extends State<ChatPage> {
  String user, image, userId, myUserId, groupChatId;
  List sm;
  File imageFile;
  bool isLoading;
  final databaseReference =
      FirebaseDatabase.instance.reference().child("Details");

  addData(String name, message, image, List sm) {
    print("out");
    Map<String, String> details = {
      'name': name,
      'message': message,
      'image': image,
      'anotherUserId':
      userId,
      'sm': jsonEncode(sm),
    };
    databaseReference.push().set(details);
  }

  updateData(
    message,
  ) {
    Map<String, String> details = {
      'message': message,
    };
    databaseReference.child("Details").update(details);
  }

  bool showEmojiPicker = false;
  FocusNode textFieldFocus = FocusNode();
  bool isWriting = false;
  String imageUrl;
  String _localPath;

  TextEditingController textEditingController = TextEditingController();

  ScrollController scrollController = ScrollController();

  _ChatPage({this.user, this.sm, this.image, this.userId});

  @override
  void initState() {
    getGroupChatId();
    // TODO: implement initState
    super.initState();
    imageUrl = '';
  }

  getfile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path);
      imageFile = File(file.path);
      print("ggg$imageFile");

      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });

          uploadFile("pdf");

      }
    } else {
      // User canceled the picker
    }
  }

  openShow(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: ' Select One'),
                    ),
                    SizedBox(
                      width: 320.0,
                      child: RaisedButton(
                        onPressed: () {
                          getImage();
                          Navigator.pop(context);

                        },
                        child: Text(
                          "Image",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: const Color(0xFF1BC0C5),
                      ),
                    ),
                    SizedBox(
                      width: 320.0,
                      child: RaisedButton(
                        onPressed: () {
                          getfile();
                          Navigator.pop(context);

                        },
                        child: Text(
                          "Documents",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: const Color(0xFF1BC0C5),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }


  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    imageFile = File(pickedFile.path);
    print("hhh$imageFile");
    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });

        uploadFile("image");

    }
  }

  Future uploadFile(String type) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        print("hellloooo");
        isLoading = false;
        sendMsg(false, imageUrl, type);
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Toast.show("Image not upload", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    });
  }

  getGroupChatId() async {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    myUserId =
         "c1627919daf1eab31d44b22fd0c0712ba9aadfa1236d4a2e4b2fec8eac1df1a9";
       // "e19799ab02e980ea1cf8bd613434e5f67e2d6a3384a97c4acd0b47bcd37a554e";

    String anotherUserId =userId;
        //"c1627919daf1eab31d44b22fd0c0712ba9aadfa1236d4a2e4b2fec8eac1df1a9";

    print("anotherUserId:$userId my userid:$myUserId");

    if (myUserId.compareTo(anotherUserId) > 0) {
      groupChatId = '$myUserId - $anotherUserId';
    } else {
      groupChatId = '$anotherUserId - $myUserId';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    showKeyboard() => textFieldFocus.requestFocus();

    hideKeyboard() => textFieldFocus.unfocus();

    hideEmojiContainer() {
      setState(() {
        showEmojiPicker = false;
      });
    }

    showEmojiContainer() {
      setState(() {
        showEmojiPicker = true;
      });
    }

    return Scaffold(
        backgroundColor: const Color(0xffffffff),
        appBar: AppBar(
          backgroundColor: const Color(0xff0e264f),
          title: Text(user),
        ),
        body: Column(
          children: [
            Flexible(
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection("messages")
                    .document(groupChatId)
                    .collection(groupChatId)
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemBuilder: (listContext, index) =>
                                buildItem(snapshot.data.documents[index]),
                            itemCount: snapshot.data.documents.length,
                            reverse: true,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          height: 70,
                          color: Colors.white,
                          child: Row(
                            children: [
                              IconButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: () {
                                  openShow(context);
                                  //getfile();
                                  //getImage();
                                },
                                icon: Icon(Icons.image),
                              ),
                              IconButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: () {
                                  if (!showEmojiPicker) {
                                    // keyboard is visible
                                    hideKeyboard();
                                    showEmojiContainer();
                                  } else {
                                    //keyboard is hidden
                                    showKeyboard();
                                    hideEmojiContainer();
                                  }
                                },
                                icon: Icon(Icons.face),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: textEditingController,
                                  focusNode: textFieldFocus,
                                  onTap: () => hideEmojiContainer(),
                                  decoration: InputDecoration.collapsed(
                                    hintText: 'Send a message..',
                                  ),
                                ),
                              ),
                              RawMaterialButton(
                                onPressed: () {
                                  if (snapshot.data.documents.length == 0) {
                                    if (sm != null && sm.length != 0) {
                                      String msg =
                                          textEditingController.text.trim();

                                      sendMsg(true, msg, "text");
                                      textEditingController.clear();
                                    } else {
                                      String msg =
                                          textEditingController.text.trim();
                                      sendMsg(false, msg, "text");
                                      textEditingController.clear();
                                    }
                                  } else {
                                    String msg =
                                        textEditingController.text.trim();
                                    sendMsg(false, msg, "text");
                                    textEditingController.clear();
                                  }
                                },
                                elevation: 2.0,
                                fillColor: const Color(0xff0e264f),
                                child: Icon(
                                  Icons.send,
                                  size: 20.0,
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.all(15.0),
                                shape: CircleBorder(),
                              ),

/*
                      IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            if (snapshot.data.documents.length == 0) {
                              if (sm != null && sm.length != 0) {
                                sendMsg(true);
                                textEditingController.clear();
                              } else {
                                sendMsg(false);
                                textEditingController.clear();
                              }
                            } else {
                              sendMsg(false);
                              textEditingController.clear();
                            }
                          })
*/
                            ],
                          ),
                        )
                      ],
                    );
                  } else {
                    return Center(
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            showEmojiPicker ? Container(child: emojiContainer()) : Container(),
          ],
        ));
  }

  emojiContainer() {
    return EmojiPicker(
      bgColor: Colors.white,
      indicatorColor: Colors.grey,
      rows: 3,
      columns: 7,
      onEmojiSelected: (emoji, category) {
        setState(() {
          isWriting = true;
        });

        textEditingController.text = textEditingController.text + emoji.emoji;
      },
      recommendKeywords: ["face", "happy", "party", "sad"],
      numRecommended: 50,
    );
  }



  sendMsg(bool social, String content, type) async {
    setState(() {
      isWriting = false;
    });

    textEditingController.text = "";

    if (databaseReference.child("Details") != null) {
      print("innhhhh");

      FirebaseDatabase.instance
          .reference()
          .child('Details')
          .orderByChild('anotherUserId')
          .equalTo(
              "c1627919daf1eab31d44b22fd0c0712ba9aadfa1236d4a2e4b2fec8eac1df1a9")
          .once()
          .then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> children = snapshot.value;
        children.forEach((key, value) {
          FirebaseDatabase.instance
              .reference()
              .child('Details')
              .child(key)
              .remove();
        });
      });
      /*databaseReference.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, values) {

          print(values["anotherUserId"]);

          if (values["anotherUserId"] == userId) {
            print("llll");

           // databaseReference.remove();
          }
        });
      });*/
    }
    addData(user, content, image, sm);

    /*  String useAnor= Firestore.instance.collection('Details').document(userId) as String;
    if (useAnor !=userId){
      print("workin");
      addData(user, msg,  image,sm);


      print("snapShot $useAnor");
      //it exists
    }
    else{
      print("no workin");
      Firestore.instance.collection('Details').document(userId).updateData({ "message":msg});


      //not exists
    }

*/

    /// Upload images to firebase and returns a URL
    if (content.isNotEmpty) {
      print('thisiscalled $content');
      var ref = Firestore.instance
          .collection('messages')
          .document(groupChatId)
          .collection(groupChatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(ref, {
          "senderId": myUserId,
          "anotherUserId":
              "c1627919daf1eab31d44b22fd0c0712ba9aadfa1236d4a2e4b2fec8eac1df1a9",
          "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
          'content': content,
          'socialMedia': social,
          "type": type,
        });
      });

      scrollController.animateTo(0.0,
          duration: Duration(milliseconds: 100), curve: Curves.bounceInOut);
    } else {
      print('Please enter some text to send');
    }
  }

  buildItem(doc) {
    print(doc['senderId']);
    print(doc['content']);
    print(doc['type']);
    return Padding(
      padding: EdgeInsets.only(
          top: 8.0,
          left: ((doc['senderId'] == myUserId) ? 64 : 0),
          right: ((doc['senderId'] == myUserId) ? 0 : 250)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color:
                ((doc['senderId'] == myUserId) ? Colors.white : Colors.white),
            borderRadius: BorderRadius.circular(8.0)),
        child: ((doc['senderId'] == myUserId)
            //   ? (doc['type'] == 'text')
            ? Container(
                alignment: Alignment.topRight,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      (doc['type'] == 'text')
                          ? Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.80,
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
                                '${doc['content']}',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : (doc['type'] == 'image')
                              ? Container(
                                  height: 200.0,
                                  width: 200.0,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => FullPhoto(
                                                  url: doc['content'])));
                                    },
                                    child: Image.network(doc['content']),
                                  )

                                  // margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
                                  )
                              : Container(
                                  height: 50.0,
                                  width: 200.0,
                                  child: InkWell(
                                    onTap: () async {
                                      print("pdf");
                                      print(doc['content']);
                                      final externalDir =
                                          await getExternalStorageDirectory();
                                      final id = FlutterDownloader.enqueue(
                                          url: doc['content'],
                                          savedDir: externalDir.path,
                                          fileName: "Download",
                                          showNotification: true,
                                          openFileFromNotification: true);

                                      print(externalDir.path);
                                      /* final status =
                                          await Permission.storage.request();

                                      if (status.isGranted) {
                                        final externalDir =
                                            await getExternalStorageDirectory();
                                        final id = FlutterDownloader.enqueue(
                                            url: doc['content'],
                                            savedDir: externalDir.path,
                                            fileName: "download",
                                            openFileFromNotification: true);
                                      } else {
                                        print("permission denied");
                                      }
                                     */ //     _downloadFile(doc['content'],"flutter_tech");
                                      // downloadFile(doc['content'],"flutter_tech","download");
                                    },
                                    child: Card(
                                      child: Image.asset("assest/pdf.png"),
                                    ),
                                  ),
                                ),
                      (doc['socialMedia'] == true)
                          ? Card(
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
                                          left: 10,
                                          top: 5,
                                          bottom: 5,
                                          right: 10),
                                      child: Text(
                                        "Get in touch with us on any of our social media",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 10, bottom: 10, top: 10),
                                    child: Expanded(
                                      child: SizedBox(
                                        height: 60,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (listContext, index) =>
                                              buildItemSocial(sm[index]),
                                          itemCount: sm.length,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Text(
                              "",
                              style: TextStyle(fontSize: 1.0),
                            ),
                    ],
                  ),
                ))
            : (doc['type'] == 'text')
                ? Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.80,
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey,
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
                      '${doc['content']}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                : (doc['type'] == 'image')
                    ? Container(
                        height: 200.0,
                        width: 200.0,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FullPhoto(url: doc['content'])));
                          },
                          child: Image.network(doc['content']),
                        )

                        // margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
                        )
                    : Container(
                        height: 50.0,
                        width: 200.0,
                        child: InkWell(
                          onTap: () async {
                            print("pdf");
                            print(doc['content']);
                            final externalDir =
                                await getExternalStorageDirectory();
                            final id = FlutterDownloader.enqueue(
                                url: doc['content'],
                                savedDir: externalDir.path,
                                fileName: "Download",
                                showNotification: true,
                                openFileFromNotification: true);

                            print(externalDir.path);
                            /* final status =
                                          await Permission.storage.request();

                                      if (status.isGranted) {
                                        final externalDir =
                                            await getExternalStorageDirectory();
                                        final id = FlutterDownloader.enqueue(
                                            url: doc['content'],
                                            savedDir: externalDir.path,
                                            fileName: "download",
                                            openFileFromNotification: true);
                                      } else {
                                        print("permission denied");
                                      }
                                     */ //     _downloadFile(doc['content'],"flutter_tech");
                            // downloadFile(doc['content'],"flutter_tech","download");
                          },
                          child: Card(
                            child: Image.asset("assest/pdf.png"),
                          ),
                        ),
                      )),

        /*Text('${doc['content']}')*/
      ),
    );
  }

  buildItemSocial(sm) {
    return InkWell(
      onTap: () {
        if (sm['social_media'] == "Whatsapp") {
          whatsAppOpen(sm['social_media_number']);
        } else {
          _openMap(sm['social_media'], sm['social_media_number'], context);
        }
      },
      child: Card(
        child: Container(
          height: 70,
          width: 60,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Column(
              children: [
                imageSocial(sm['social_media']),

/*                 Icon(
              Icons.whatshot_sharp)*/
                Text(
                  sm['social_media'],
                  style: TextStyle(fontSize: 10.0),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


var httpClient = new HttpClient();

Future<File> _downloadFile(String url, String filename) async {
  var request = await httpClient.getUrl(Uri.parse(url));
  var response = await request.close();
  print("in");

  var bytes = await consolidateHttpClientResponseBytes(response);
  String dir = (await getApplicationDocumentsDirectory()).path;
  File file = new File('$dir/$filename');
  await file.writeAsBytes(bytes);
  return file;
}

Future<String> downloadFile(String url, String fileName, String dir) async {
  HttpClient httpClient = new HttpClient();
  print("in");

  File file;
  String filePath = '';
  String myUrl = '';

  try {
    myUrl = url + '/' + fileName;
    print(myUrl);
    print("working");
    var request = await httpClient.getUrl(Uri.parse(myUrl));
    print("re$request");

    var response = await request.close();
    if (response.statusCode == 200) {
      print("workingeee");

      var bytes = await consolidateHttpClientResponseBytes(response);
      filePath = '$dir/$fileName';
      file = File(filePath);
      await file.writeAsBytes(bytes);
      print("out$file");
      print("out");
    } else
      filePath = 'Error code: ' + response.statusCode.toString();
  } catch (ex) {
    filePath = 'Can not fetch url';
  }

  return filePath;
}


_openMap(String social, num, BuildContext context) async {
  const url = 'https://www.google.com/maps/search/?api=1&query=52.32,4.917';
  if (await canLaunch('$social:$num')) {
    await launch('$social:$num');
  } else {
    Toast.show("App not Installed", context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

    throw 'Could not launch $social';
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

Widget imageSocial(String social) {
  switch (social) {
    case "Whatsapp":
      {
        return Container(
          // margin: EdgeInsets.all(8),
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: AssetImage('assest/whatapp.png'), fit: BoxFit.cover),
          ),
        );

        print("Whatsapp");
      }
      break;

    case "IMO":
      {
        return Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: AssetImage('assest/imo.png'), fit: BoxFit.cover),
          ),
        );

        print("IMO");
      }
      break;

    case "Viber":
      {
        return Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: AssetImage('assest/viber.png'), fit: BoxFit.cover),
          ),
        );

        print("Signal");
      }
      break;
    case "Signal":
      {
        return Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: AssetImage('assest/signal.png'), fit: BoxFit.cover),
          ),
        );

        print("Signal");
      }
      break;

    case "Skype":
      {
        return Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: AssetImage('assest/skype.png'), fit: BoxFit.cover),
          ),
        );

        print("Poor");
      }
      break;

    //  default: { print("Invalid choice"); }
    // break;
  }


/*
  void launchApp() {
    if (await canLaunch ('skype:username')
    ) {
    final bool nativeAppLaunchSucceeded = await launch(
    'skype:username',
    );
    if (!nativeAppLaunchSucceeded) {
    // Do something else
    }
    }
  }
*/
}

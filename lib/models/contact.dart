import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  String name;
  String chatcontent;

  Contact({this.name, this.chatcontent}) : super() {
    if (name == null) name = '';
    if (chatcontent == null) chatcontent = '';
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> mapObj = Map<String, dynamic>();
    mapObj["name"] = name;
    mapObj["chat_content"] = chatcontent;
    return mapObj;
  }

  Contact.fromDocumentSnapshot(DocumentSnapshot doc) {
    name = doc['name'];
    chatcontent = doc['chat_content'];
  }
}

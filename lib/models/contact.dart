import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  String name;
  String content;

  Contact({this.name, this.content}) : super() {
    if (name == null) name = '';
    if (content == null) content = '';
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> mapObj = Map<String, dynamic>();
    mapObj["name"] = name;
    mapObj["chat_content"] = content;
    return mapObj;
  }

  Contact.fromDocumentSnapshot(DocumentSnapshot doc) {
    name = doc['name'];
    content = doc['chat_content'];
  }
}

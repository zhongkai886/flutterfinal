import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  String name;
  String cellPhone;

  Contact({this.name, this.cellPhone}) : super() {
    if (name == null) name = '';
    if (cellPhone == null) cellPhone = '';
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> mapObj = Map<String, dynamic>();
    mapObj["name"] = name;
    mapObj["cellPhone"] = cellPhone;
    return mapObj;
  }

  Contact.fromDocumentSnapshot(DocumentSnapshot doc) {
    name = doc['name'];
    cellPhone = doc['cellPhone'];
  }
}

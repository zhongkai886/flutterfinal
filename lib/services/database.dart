import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfinal/models/contact.dart';

class Database {
  static final Firestore _db = Firestore.instance;

  //C (Create)
  static Future<void> addContact(Contact contact) async {
    await _db.collection('chat').document().setData(contact.toMap());
  }

  //R (Read)
  static Stream<QuerySnapshot> getContactsSnapshots() {
    return _db.collection('chat').snapshots();
  }

  //U (Update)
  static Future<void> updateContact(String docId, Contact contact) async {
    await _db
        .collection('chat')
        .document(docId)
        .updateData(contact.toMap());
  }

  //D (Delete)
  static Future<void> deleteContact(String docId) async {
    await _db.collection('chat').document(docId).delete();
  }
}

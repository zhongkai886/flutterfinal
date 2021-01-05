import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfinal/models/contact.dart';

class Database {
  static final Firestore _db = Firestore.instance;

  //C (Create)
  static Future<void> addContact(Contact contact) async {
    await _db.collection('contacts').document().setData(contact.toMap());
  }

  //R (Read)
  static Stream<QuerySnapshot> getContactsSnapshots() {
    print('_db.collection(contacts).snapshots()');
    return _db.collection('contacts').snapshots();
  }

  //U (Update)
  static Future<void> updateContact(String docId, Contact contact) async {
    await _db
        .collection('contacts')
        .document(docId)
        .updateData(contact.toMap());
  }

  //D (Delete)
  static Future<void> deleteContact(String docId) async {
    await _db.collection('contacts').document(docId).delete();
  }
}

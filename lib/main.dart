import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfinal/models/contact.dart';
import 'models/contact.dart';
import 'services/database.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AppHome(),
    );
  }
}

class AppHome extends StatefulWidget {
  @override
  _AppHomeState createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: HomeBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return ContactEditAlertDialog();
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ContactEditAlertDialog extends StatefulWidget {
  final String docId;
  final Contact contact;

  ContactEditAlertDialog({this.docId, this.contact}) : super();

  @override
  _ContactEditAlertDialogState createState() =>
      _ContactEditAlertDialogState(docId: docId, contact: contact);
}

class _ContactEditAlertDialogState extends State<ContactEditAlertDialog> {
  String docId;
  Contact contact;

  _ContactEditAlertDialogState({this.docId, this.contact}) : super() {
    if (contact == null) {
      contact = Contact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text((docId != null && docId.length > 0) ? '編輯聯絡人' : '新增聯絡人'),
      content: Container(
        constraints: BoxConstraints(minHeight: 40, maxHeight: 160),
        child: Column(
          children: [
            TextFormField(
              initialValue: (contact != null) ? contact.name : '',
              decoration: InputDecoration(
                labelText: "Name",
              ),
              onChanged: (value) => contact.name = value,
            ),
            TextFormField(
              initialValue: (contact != null) ? contact.cellPhone : '',
              decoration: InputDecoration(
                labelText: "Cell Phone",
              ),
              onChanged: (value) => contact.cellPhone = value,
            )
          ],
        ),
      ),
      actions: _genActions(),
    );
  }

  List<Widget> _genActions() {
    List<Widget> actions = new List<Widget>();
    actions.add(FlatButton(
      onPressed: () async {
        if (contact.name != null && contact.name.length > 0) {
          if (docId != null && docId.length > 0) {
            await Database.updateContact(docId, contact);
          } else {
            await Database.addContact(contact);
          }
        }
        Navigator.pop(context, true);
      },
      child: Text('OK'),
    ));
    actions.add(FlatButton(
      onPressed: () {
        Navigator.pop(context, true);
      },
      child: Text('Cancel'),
    ));
    if (docId != null && docId.length > 0) {
      actions.add(FlatButton(
          onPressed: () async {
            await Database.deleteContact(docId);
            Navigator.pop(context, true);
          },
          child: Text(
            'Delete',
            style: TextStyle(color: Colors.red),
          )));
    }
    return actions;
  }
}

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ContactListView(),
    );
  }
}

class ContactListView extends StatefulWidget {
  @override
  _ContactListViewState createState() => _ContactListViewState();
}

class _ContactListViewState extends State<ContactListView> {
  int _contactCount = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Database.getContactsSnapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          _contactCount = snapshot.data.documents.length;
          return ListView.builder(
            itemBuilder: (context, index) {
              Contact contact =
              Contact.fromDocumentSnapshot(snapshot.data.documents[index]);
              String contactDocId = snapshot.data.documents[index].documentID;
              return ListTile(
                title: Text(contact.name),
                subtitle: Text(contact.cellPhone),
                onTap: () {
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) {
                        return ContactEditAlertDialog(
                          docId: contactDocId,
                          contact: contact,
                        );
                      });
                },
              );
            },
            itemCount: _contactCount,
          );
        });
  }
}

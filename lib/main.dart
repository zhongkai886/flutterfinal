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
      appBar: AppBar(title: Text('Home'),centerTitle: true),
      body: HomeBody(),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 45.0,
          color: Colors.blueAccent,
        ),
      ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

    );
  }
}
//dialog的畫面和接收值
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
      title: Text((docId != null && docId.length > 0) ? '編輯聯絡人' : 'Add Article'),
      content: Container(
        constraints: BoxConstraints(minHeight: 40, maxHeight: 160),
        child: Column(
          children: [
            TextFormField(
              initialValue: (contact != null) ? contact.name : '',
              decoration: InputDecoration(
                labelText: "Title",
              ),
              onChanged: (value) => contact.name = value,
            ),
            TextFormField(
              initialValue: (contact != null) ? contact.content : '',
              decoration: InputDecoration(
                labelText: "Content",
              ),
              onChanged: (value) => contact.content = value,
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
          //製作列表 ListView
          return ListView.builder(
            itemBuilder: (context, index) {
              Contact contact =
              Contact.fromDocumentSnapshot(snapshot.data.documents[index]);
              String contactDocId = snapshot.data.documents[index].documentID;
              return ListTile(
                leading: Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
                title: Text(contact.name,style:new TextStyle(fontSize: 20)),
                subtitle: Text(contact.content,style:new TextStyle(fontSize: 16)),
                onTap: () {
                  Navigator.push(
                    context,MaterialPageRoute(builder: (context) => MessageContent(name: contact.name,content: contact.content)
                  ),
                  );
                },
              );
            },
            itemCount: _contactCount,
          );
        });
  }
}
class MessageContent extends StatelessWidget {
  String name;
  String content;
  MessageContent({this.name,this.content}) : super(){}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle:true,
        title: Text('Article page'),
      ),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(10.0),
            child: Text(name,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 25)),),
          Padding(padding: const EdgeInsets.all(10.0),
            child: Text(content,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 20,color: Colors.black54)),)
        ],
      ),
    );
  }
}

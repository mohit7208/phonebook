import 'dart:async';
import 'package:flutter/material.dart';
import 'package:phonebook/models/contact.dart';
import 'package:phonebook/utils/database_helper.dart';
import 'package:phonebook/screens/contact_detail.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Contact> contactList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (contactList == null) {
      contactList = List<Contact>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(
              Contact(
                '',
                '',
              ),
              'Add Contact');
        },
        tooltip: 'Add Contact',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getNoteListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Text(
                this.contactList[position].title.substring(0, 1) ?? '',
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              this.contactList[position].title,
              style: titleStyle,
            ),
            subtitle: Text(this.contactList[position].description),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              onTap: () {
                _delete(context, contactList[position]);
              },
            ),
            onTap: () {
              navigateToDetail(this.contactList[position], 'Edit Contact');
            },
          ),
        );
      },
    );
  }

  void _delete(BuildContext context, Contact note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Contact Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Contact contact, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(contact, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Contact>> noteListFuture = databaseHelper.getContactList();
      noteListFuture.then((contactList) {
        setState(() {
          this.contactList = contactList;
          this.count = contactList.length;
        });
      });
    });
  }
}

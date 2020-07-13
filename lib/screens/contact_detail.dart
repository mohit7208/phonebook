import 'dart:async';
import 'package:flutter/material.dart';
import 'package:phonebook/models/contact.dart';
import 'package:phonebook/utils/database_helper.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Contact contact;

  NoteDetail(this.contact, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.contact, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Contact contact;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  NoteDetailState(this.contact, this.appBarTitle);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    titleController.text = contact.title;
    descriptionController.text = contact.description;

    return WillPopScope(
        onWillPop: () {
          // Write some code to control things, when user press Back navigation button in device navigationBar
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Write some code to control things, when user press back button in AppBar
                  moveToLastScreen();
                }),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  // Second Element
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextField(
                      controller: titleController,
                      style: textStyle,
                      onChanged: (value) {
                        updateTitle();
                      },
                      decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),

                  // Third Element
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextFormField(
                      controller: descriptionController,
                      style: textStyle,
                      onChanged: (value) {
                        updateDescription();
                      },
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.length != 10) {
                          return 'Enter valid 10 digit number';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: 'Number',
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),

                  // Fourth Element
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              'Save',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  _save();
                                });
                              }
                            },
                          ),
                        ),
                        Container(
                          width: 5.0,
                        ),
                        Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              'Delete',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                _delete();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Update the title of Note object
  void updateTitle() {
    contact.title = titleController.text;
  }

  // Update the description of Note object
  void updateDescription() {
    contact.description = descriptionController.text;
  }

  // Save data to database
  void _save() async {
    moveToLastScreen();

    // note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (contact.id != null) {
      // Case 1: Update operation
      result = await helper.updateNote(contact);
    } else {
      // Case 2: Insert Operation
      result = await helper.insertNote(contact);
    }

    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Contact Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Contact');
    }
  }

  void _delete() async {
    moveToLastScreen();

    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (contact.id == null) {
      _showAlertDialog('Status', 'No Contact was deleted');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await helper.deleteNote(contact.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Contact Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Contact');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}

import 'package:flutter/material.dart';
import 'package:phonebook/screens/contact_list.dart';
import 'package:phonebook/screens/contact_detail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phonebook',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: NoteList(),
    );
  }
}

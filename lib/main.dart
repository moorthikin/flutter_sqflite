import 'package:flutter/material.dart';
import 'package:flutter_sqflite/screens/addnote.dart';
import 'package:flutter_sqflite/screens/notescreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        routes: {"/note": (context) => NewNoteScreen()},
        home: NoteScreen());
  }
}

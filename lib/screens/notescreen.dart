import 'package:flutter/material.dart';
import 'package:flutter_sqflite/Database/db.dart';
import 'package:flutter_sqflite/model/note_model.dart';
import 'package:flutter_sqflite/screens/addnote.dart';
import 'package:flutter_sqflite/utili/colors.dart';
import 'package:flutter_sqflite/widget/note_widget.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text(
          "SQF Lite APP",
          style: TextStyle(color: textcolor),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewNoteScreen(),
              ));
          setState(() {});
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(
            "Add Note",
            style: TextStyle(color: textcolor),
          ),
        ),
        backgroundColor: primary,
      ),
      body: FutureBuilder<List<Note>?>(
        future: DatabaseHelper.getAllNotes(),
        builder: (context, AsyncSnapshot<List<Note>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.hasError.toString()),
            );
          } else if (snapshot.hasData) {
            if (snapshot.hasData != null) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return NoteWidget(
                        note: snapshot.data![index],
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewNoteScreen(
                                  note: snapshot.data![index],
                                ),
                              ));
                        },
                        onLongPress: () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Are You Sure Want to Delete"),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () async {
                                        await DatabaseHelper.deleteNote(
                                            snapshot.data![index]);
                                        Navigator.pop(context);
                                      },
                                      child: Text("Yes")),
                                  ElevatedButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                      },
                                      child: Text("No")),
                                ],
                              );
                            },
                          );
                        });
                  });
            }
            return const Center(
              child: Text('No notes yet'),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

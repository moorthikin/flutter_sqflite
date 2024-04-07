import 'package:flutter/material.dart';
import 'package:flutter_sqflite/Database/db.dart';
import 'package:flutter_sqflite/model/note_model.dart';
import 'package:flutter_sqflite/screens/notescreen.dart';
import 'package:flutter_sqflite/utili/colors.dart';

class NewNoteScreen extends StatelessWidget {
  NewNoteScreen({super.key, this.note});
  final Note? note;
  final notecontroller = TextEditingController();

  final descriptioncontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (note != null) {
      notecontroller.text = note!.title;
      descriptioncontroller.text = note!.description;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(
          note == null ? "Add New Note" : "Edit Note",
          style: TextStyle(color: textcolor),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteScreen(),
                ));
          },
          icon: Icon(Icons.arrow_back_ios),
          color: textcolor,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 35),
            child: TextFormField(
              key: _formkey,
              controller: notecontroller,
              decoration: InputDecoration(
                filled: false,
                hintText: " Your Note",
              ),
              // validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return "Please add the note";
              //   } else if (value.length < 3) {
              //     return "Atleast must be 3 characters";
              //   }
              //   return null;
              // },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 35),
            child: TextFormField(
              // key: _formkey1,
              controller: descriptioncontroller,
              decoration:
                  InputDecoration(filled: false, hintText: " Your Description"),
              // validator: (value) {
              //   if (value!.isEmpty) {
              //     return "Please add the Description";
              //   } else if (value.length < 3) {
              //     return "Atleast must be 3 characters";
              //   }
              //   return null;
              // },
            ),
          ),
          SizedBox(
            height: 60,
          ),
          GestureDetector(
            onTap: () async {
              final title = notecontroller.value.text;
              final description = descriptioncontroller.value.text;

              if (title.isEmpty || description.isEmpty) {
                return null;
              }

              final Note model =
                  Note(title: title, description: description, id: note?.id);

              if (note == null) {
                await DatabaseHelper.addNote(model);
              } else {
                await DatabaseHelper.updateNote(model);
              }
              Navigator.pop(context);
            },
            child: Container(
              height: 50,
              width: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: buttonColor,
              ),
              child: Center(
                child: Text(
                  note == null ? "Save" : "Update",
                  style:
                      TextStyle(color: textcolor, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_sqflite/Database/db.dart';
import 'package:flutter_sqflite/model/note_model.dart';
import 'package:flutter_sqflite/screens/notescreen.dart';
import 'package:flutter_sqflite/utili/colors.dart';

class NewNoteScreen extends StatefulWidget {
  NewNoteScreen({super.key, this.note});
  final Note? note;

  @override
  State<NewNoteScreen> createState() => _NewNoteScreenState();
}

class _NewNoteScreenState extends State<NewNoteScreen> {
  final notecontroller = TextEditingController();
  final descriptioncontroller = TextEditingController();
  String selectedPriority = 'Low';
  DateTime? selectedDeadline;

  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      notecontroller.text = widget.note!.title;
      descriptioncontroller.text = widget.note!.description;
      selectedPriority = widget.note!.priority;
      if (widget.note!.deadline != null && widget.note!.deadline!.isNotEmpty) {
        selectedDeadline = DateTime.tryParse(widget.note!.deadline!);
      }
    }
  }

  @override
  void dispose() {
    notecontroller.dispose();
    descriptioncontroller.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDeadline ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 10),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDeadline = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(
          widget.note == null ? "Add New Note" : "Edit Note",
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
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
            child: DropdownButtonFormField<String>(
              value: selectedPriority,
              decoration: const InputDecoration(
                hintText: 'Priority',
              ),
              items: const ['Low', 'Medium', 'High']
                  .map((priority) => DropdownMenuItem<String>(
                        value: priority,
                        child: Text(priority),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedPriority = value;
                  });
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
            child: InkWell(
              onTap: _pickDeadline,
              child: InputDecorator(
                decoration: const InputDecoration(
                  hintText: 'Deadline Date',
                ),
                child: Text(
                  selectedDeadline == null
                      ? 'Select deadline date'
                      : '${selectedDeadline!.year.toString().padLeft(4, '0')}-${selectedDeadline!.month.toString().padLeft(2, '0')}-${selectedDeadline!.day.toString().padLeft(2, '0')}',
                ),
              ),
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

              final Note model = Note(
                  title: title,
                  description: description,
                  priority: selectedPriority,
                  deadline: selectedDeadline?.toIso8601String(),
                  id: widget.note?.id);

              if (widget.note == null) {
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
                  widget.note == null ? "Save" : "Update",
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

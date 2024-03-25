import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/Api.dart';
import 'package:my_app/Classes/Note.dart';
import 'dart:typed_data';
import 'dart:convert';

import 'package:my_app/Classes/todos.dart';
import 'package:my_app/GlobalDart.dart';
import 'package:my_app/Widgets/SnackBarMsg.dart';

class EditNote extends StatefulWidget {
  final Note note;
  final void Function()? reloadgrid;
  EditNote({super.key, required this.note, this.reloadgrid});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    TextEditingController noteTextController =
        TextEditingController(text: widget.note.text);
    //noteTextController.text = widget.note.title;

    @override
    void dispose() {
      noteTextController.dispose();
      super.dispose();
    }

    /*@override
    void initState() {
      super.initState();
      // Pre-fill the text controllers with existing profile data
      noteTextController.text = widget.note.title;
    }

    @override
    void setState() {
      super.initState();
      // Pre-fill the text controllers with existing profile data
      noteTextController.text = widget.note.title;
    }*/

    void deleteNoteAndPop() {
      deleteNote(widget.note.noteid);
      widget.reloadgrid?.call();
      Navigator.pop(context);
      snackbarMsg("Note deleted", 3, context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note.title),
        actions: [
          IconButton(
            onPressed: () {
              //return and reload future in main
              deleteNote(widget.note.noteid); //API to delete note off server DB
              //widget.reloadgrid!.call(); //you need to invoke the fucking funciton with .call() or ?.call()
              GlobalDart.reloadgrid = true;
              Navigator.pop(context);

              //reloadgrid

              snackbarMsg("Note deleted", 3, context);
            },
            icon: Icon(Icons.delete),
            tooltip: "Delete note",
          )
        ],
      ),
      body: Card(
        shadowColor: Colors.transparent,
        margin: const EdgeInsets.all(8.0),
        child: SizedBox.expand(
            child: Padding(
          padding: EdgeInsets.all(8),
          child: /*Text(
            widget.note.title,
            style: theme.textTheme.bodyLarge,
          ),*/

              TextField(
            controller: noteTextController,
            style: theme.textTheme.bodyLarge,
            maxLines: null,
            decoration: InputDecoration(
              hintText: 'Type away...',
              border: InputBorder.none,
            ),
          ),
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //savenote() --TODO API + FLuTTER

          snackbarMsg("Note saved", 3, context);
        },
        tooltip: 'New note',
        child: const Icon(Icons.save),
      ),
    );
  }
}

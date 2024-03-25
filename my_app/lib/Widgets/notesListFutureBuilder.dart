import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/Api.dart';
import 'package:my_app/Classes/Note.dart';

import 'package:my_app/Pages/EditNotePage.dart';

//unused

class notesListFutureBuilder extends StatefulWidget {
  notesListFutureBuilder({super.key, required this.futureNotesList});

  late Future<List<Note>> futureNotesList;

  @override
  _notesListFutureBuilderState createState() => _notesListFutureBuilderState();
}

class _notesListFutureBuilderState extends State<notesListFutureBuilder> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Note>>(
      future: widget.futureNotesList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Note> albums = snapshot.data!;
          return Scaffold(
            body: GridView(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              children: [
                for (Note album in albums)
                  Card(
                    child: ListTile(
                      title: Padding(
                        padding: EdgeInsetsDirectional.only(bottom: 10),
                        child: Text(
                          '${album.title}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      subtitle: Text('${album.text}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditNote(
                                    note: Note(
                                        noteid: album.noteid,
                                        userid: album.userid,
                                        title: album.title,
                                        text: album.text),
                                    reloadgrid: () {},
                                  )),
                        );
                      },
                    ),
                  ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              tooltip: 'New note',
              child: const Icon(Icons.add),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}

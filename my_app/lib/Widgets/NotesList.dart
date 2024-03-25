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
import 'package:my_app/Pages/EditNotePage.dart';

Widget NotesList(List<Note> albums, BuildContext context) {
//func that returns builder
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
                  ' ${album.title}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              //subtitle: Text('User ID: ${album.userId}, ID: ${album.id}'),
              subtitle: Text('${album.text}'),
              //leading: Icon(Icons.notifications_sharp),
              //tileColor: Colors.green,//make an if to check whether read or not
              /*tileColor: album.completed
                  ? Colors.green
                  : Colors.white, // Change color based on the completed status
*/

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

                /*ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Marked ${album.title} as read'),
                  duration: Duration(seconds: 8),
                ),
              );*/
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
}

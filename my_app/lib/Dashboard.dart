import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/Api.dart';
import 'package:my_app/Classes/Note.dart';
import 'package:my_app/Classes/todos.dart';
import 'package:my_app/GlobalDart.dart';
import 'package:my_app/Pages/EditNotePage.dart';
import 'package:my_app/Widgets/NotesList.dart';
import 'package:my_app/Widgets/SnackBarMsg.dart';
import 'package:my_app/Widgets/notesListFutureBuilder.dart';
import 'Widgets/showInfoAlert.dart';

import 'dart:typed_data';
import 'dart:convert';

class Dashboard extends StatefulWidget {
  Dashboard({super.key, required this.userid});

  final int userid;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentPageIndex = 0;
  late Future<List<Note>> futureNotesList;
  late Future<List<todos>> futureAlbum;
  late Future<Map<String, dynamic>> futureProfile;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchTodo();
    futureNotesList = fetchUserNotes(widget.userid);
    futureProfile = userProfile(widget.userid);
  }

  //reload from api
  reloadgrid() {
    setState(() {
      futureNotesList = fetchUserNotes(widget.userid);
    });
  }

//through API works fine, for some reason flutter isn't reloading the grid properly
  needToReloadGrid() {
    if (GlobalDart.reloadgrid == true) {
      print("reloading grid");
      reloadgrid();
      GlobalDart.reloadgrid = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.red,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.dashboard),
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.book),
            icon: Icon(Icons.book_outlined),
            label: 'Notes',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.notifications_sharp),
            icon: Badge(child: Icon(Icons.notifications_active_outlined)),
            label: 'Notifications',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('2'),
              child: Icon(Icons.messenger_sharp),
            ),
            label: 'Messages',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person_2),
            icon: Icon(Icons.person_2_outlined),
            label: 'Profile',
          ),
        ],
      ),
      body: <Widget>[
        /// Home page
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(
              child: Text(
                'Dashboard',
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
        ),

        //Notes page
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
              //change to noteslistfuturebuilder
              child: //notesListFutureBuilder(futureNotesList: futureNotesList),
                  FutureBuilder<List<Note>>(
            future: futureNotesList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Note> albums = snapshot.data!;
                return Scaffold(
                  body: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
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
                                          //reloadgrid: reloadgrid,
                                          /* // TODO -- fix the fuckoing grid for some reason
                                           it doesn't delete the note when clicking on delete once, 
                                          you have to go into it again and delete it for some reaons*/
                                        )),
                              ).then((value) => needToReloadGrid());
                            },
                          ),
                        ),
                    ],
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      //createnote() TODO API + FLuTTER
                    },
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
          )),
        ),

        /// Notifications page
        Padding(
          padding: EdgeInsets.all(8.0),
          child: FutureBuilder<List<todos>>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<todos> albums = snapshot.data!;
                return ListView(
                  children: [
                    for (todos album in albums)
                      Card(
                        child: ListTile(
                          title: Text('Title: ${album.title}'),
                          subtitle:
                              Text('User ID: ${album.userId}, ID: ${album.id}'),
                          leading: Icon(Icons.notifications_sharp),
                          //tileColor: Colors.green,//make an if to check whether read or not
                          tileColor: album.completed
                              ? Colors.green
                              : Colors
                                  .white, // Change color based on the completed status
                          onTap: () {
                            snackbarMsg(
                                "Marked ${album.title} as read", 8, context);
                          },
                        ),
                      ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),

        ///

        /*Padding(
          padding: EdgeInsets.all(8.0),
          child:ListView(
            children: [
              //https://jsonplaceholder.typicode.com/todos
              Card(
                child: ListTile(
                  onTap: (){

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('This is a SnackBar'),
                        duration: Duration(seconds: 8),
                      ),
                    );
                  },
                  leading: Icon(Icons.notifications_sharp),
                  title: Text('Notification 1'),
                  subtitle: Text('This is a notification'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_sharp),
                  title: Text('Notification 2'),
                  subtitle: Text('This is a notification'),
                ),
              ),

            ],
          ),
        ),*/

        /// Messages page
        ListView.builder(
          reverse: true,
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'Hello',
                    style: theme.textTheme.bodyLarge!
                        .copyWith(color: theme.colorScheme.onPrimary),
                  ),
                ),
              );
            }
            return Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'Hi!',
                  style: theme.textTheme.bodyLarge!
                      .copyWith(color: theme.colorScheme.onPrimary),
                ),
              ),
            );
          },
        ),

        /// Profile page
        /*Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage("https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"),//sample photo
            ),
            SizedBox(height: 16),
            Text(
              "userid:"+widget.userid.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Username: Username",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Location: location',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Bio: bio',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
          ),
        ),*/

        FutureBuilder<Map<String, dynamic>>(
          future: futureProfile,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> profileData = snapshot.data!;
              return Card(
                shadowColor: Colors.transparent,
                margin: const EdgeInsets.all(8.0),
                child: SizedBox.expand(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () async {
                              //send stuff to new page*/
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfileScreen(
                                        profileData: profileData,
                                        userid: widget.userid)),
                              );
                            },
                            child: const Text('Edit profile'),
                          ),
                        ],
                      ),
                      CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              //loadpic
                              profileData["pfp"] == null ||
                                      (profileData["pfp"]["data"] == null ||
                                          ((profileData["pfp"]["data"] as List)
                                              .isEmpty))
                                  ? AssetImage("assets/default.webp")
                                  : MemoryImage(Uint8List.fromList(
                                      profileData["pfp"]["data"]
                                          .cast<int>())) as ImageProvider),
                      SizedBox(height: 16),
                      Text(
                        "displayname:" + profileData["displayname"],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Username:" + profileData["username"],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Location: ' + profileData["location"],
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Bio: ' + profileData["bio"],
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ][currentPageIndex],
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> profileData;

  const EditProfileScreen(
      {Key? key, required this.profileData, required this.userid})
      : super(key: key);
  final int userid;
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    // Pre-fill the text controllers with existing profile data
    displayNameController.text = widget.profileData['displayname'];
    bioController.text = widget.profileData['bio'];
    locationController.text = widget.profileData['location'];
  }

  void pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    setState(() {
      _imageFile = pickedFile;
    });
  }

  ImageProvider loadpic() {
    ImageProvider pic;
    //if the image picker (selected image from gallery/camera) is empty,
    //load the pic
    if ((widget.profileData["pfp"] != null) &&
        (widget.profileData["pfp"]["data"] != null && _imageFile == null)) {
      pic = MemoryImage(
              Uint8List.fromList(widget.profileData["pfp"]["data"].cast<int>()))
          as ImageProvider;
    } else {
      pic = FileImage(File(_imageFile!.path)) as ImageProvider;
    }

    return pic;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                      radius: 60,
                      backgroundImage: _imageFile == null &&
                              (widget.profileData["pfp"] == null ||
                                  (widget.profileData["pfp"]["data"] == null ||
                                      (widget.profileData["pfp"]["data"]
                                              as List)
                                          .isEmpty))
                          ? AssetImage("assets/default.webp")
                          : loadpic(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext bc) {
                                    return SafeArea(
                                      child: Container(
                                        child: Wrap(
                                          children: <Widget>[
                                            ListTile(
                                              leading:
                                                  Icon(Icons.photo_library),
                                              title: Text('Gallery'),
                                              onTap: () {
                                                //_getImage(ImageSource.gallery);
                                                pickImage(ImageSource.gallery);
                                                Navigator.of(context).pop();
                                                //set pfp to preview
                                              },
                                            ),
                                            ListTile(
                                              leading: Icon(Icons.photo_camera),
                                              title: Text('Camera'),
                                              onTap: () {
                                                //_getImage(ImageSource.camera);
                                                pickImage(ImageSource.camera);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: Icon(Icons.camera_alt),
                          ),
                        ],
                      )),
                  SizedBox(height: 16),
                  Text(
                    'Display Name',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: displayNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your display name',
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Bio',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: bioController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Tell us about yourself',
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Location',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: locationController,
                    decoration: InputDecoration(
                      hintText: 'Enter your location',
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Implement logic to save changes
                      saveChanges(widget.userid);
                    },
                    child: Text('Save Changes'),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  void saveChanges(int userid) async {
    // Update the user's information with the values in the text controllers
    String newDisplayName = displayNameController.text;
    String newBio = bioController.text;
    String newLocation = locationController.text;

    try {
      print("before object");
      File? pfp = _imageFile != null ? File(_imageFile!.path) : null;

      print("before object");
      //update in api
      Map<dynamic, dynamic> responseBody = await updateUserProfile(
          userid.toString(), newDisplayName, pfp, newBio, newLocation);

      if (responseBody["status"] == true) {
        // Display a success message or navigate back to the profile page
        snackbarMsg("Profile updated successfully", 3, context);

        // Optionally, you can navigate back to the profile page
        //Navigator.pop(context);//show info dialog instead and when click ok pops back

        //not the best method but it's either this or sending back all the info in a map and loading it
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Dashboard(userid: userid)),
        );

        //refresh
      } else {
        showInfoAlert(context,
            "Profile updated unsuccessful: ${responseBody['message']}");
      }
    } catch (error) {
      showInfoAlert(context, "Error during profile update: $error");
    }
  }
}



//unused
/*
class ImagePickerMenu extends StatefulWidget {
  @override
  _ImagePickerMenuState createState() => _ImagePickerMenuState();
}

class _ImagePickerMenuState extends State<ImagePickerMenu> {
  File? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageFile == null
                ? Text('No image selected.')
                : Image.file(_imageFile!),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _pickImage(ImageSource.gallery);
              },
              child: Text('Pick from Gallery'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _pickImage(ImageSource.camera);
              },
              child: Text('Pick from Camera'),
            ),
          ],
        ),
      ),
    );
  }
}*/

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'package:http_parser/http_parser.dart';
import 'package:my_app/Classes/Album.dart';
import 'package:my_app/Classes/Note.dart';
import 'package:my_app/Classes/todos.dart';

Future<List<todos>> fetchTodo() async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    //print("-DEBUG-\napi response: "+response.body);

    List<dynamic> list = jsonDecode(response.body);
    List<todos> todoslist = list.map((data) => todos.fromJson(data)).toList();

    return todoslist;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load todos - API class');
  }
}

Future<List<Album>> fetchAlbum() async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    //print("-DEBUG-\napi response: "+response.body);

    List<dynamic> list = jsonDecode(response.body);
    List<Album> albumList = list.map((data) => Album.fromJson(data)).toList();

    //print("----DEBUG----\n"+list.toString());
    //return List<Album>.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    return albumList;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

/*Future userLogin1(String username, String password) async {
  var request = http.MultipartRequest('POST', Uri.parse('http://localhost:30000/api/login'));  
  request.fields.addAll({
    'username': username,
    'password': password
  });

  http.StreamedResponse response = await request.send();
  print("aftre streamedresponse");
  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
    print("-=-login ok-=-");
    //List<dynamic> list = jsonDecode(response.body);
    //List<Album> albumList = list.map((data) => Album.fromJson(data)).toList();

    //print("----DEBUG----\n"+list.toString());
    //return List<Album>.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    //return albumList;
  }
  else {
    print(response.reasonPhrase);
    throw Exception('Failed to login');
  }

}*/
String localhost = "localhost";
String android = "10.0.2.2";

String api = "http://" + localhost + ":30000";

Future<Map<String, dynamic>> userLogin(String username, String password) async {
  final response = await http.post(
    Uri.parse(api + "/api/login"), //10.0.2.2 for android emulator
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': username, //change later back to vars
      'password': password
    }),
  );

  if (response.statusCode == 200) {
    // then parse the JSON.

    //print(jsonDecode(response.body).toString() as Map<String, dynamic>);
    //print("debug->");
    //print(response.body.toString());

    // Parse the JSON response.
    final Map<String, dynamic> responseBody = jsonDecode(response.body);

    //debug
    //print(responseBody["message"]);

    //return jsonDecode(response.body) as Map<String, dynamic>;
    //or
    return responseBody;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    //print(response.body.toString());//debug
    throw Exception('Login query error');
  }
}

Future<Map<String, dynamic>> userRegister(
    String username, String password, String display_name, String email) async {
  final response = await http.post(
    Uri.parse(api + "/api/register"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'password': password,
      'display_name': display_name,
      'email': email
    }),
  );

  if (response.statusCode == 200) {
    print("debug->");
    print(response.body.toString());

    // Parse the JSON response.
    final Map<String, dynamic> responseBody = jsonDecode(response.body);

    //debug
    //print(responseBody["message"]);

    //return jsonDecode(response.body) as Map<String, dynamic>;
    //or
    return responseBody;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    //print(response.body.toString());//debug
    throw Exception('Register query error');
  }
}

Future<Map<String, dynamic>> userProfile(int userid) async {
  final response = await http.post(
    Uri.parse(api + "/api/getprofile"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'userid': userid,
    }),
  );

  if (response.statusCode == 200) {
    //print("debug->");
    //print(response.body.toString());

    // Parse the JSON response.
    final Map<String, dynamic> responseBody = jsonDecode(response.body);

    //debug
    //print(responseBody["message"]);

    //return jsonDecode(response.body) as Map<String, dynamic>;
    //or
    return responseBody;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    //print(response.body.toString());//debug
    throw Exception('Register query error');
  }
}

Future<Map<String, dynamic>> updateUserProfile_json(
    //original first test
    String userid,
    String display_name,
    File pfp,
    String bio,
    String location) async {
  final response = await http.post(
    Uri.parse(api + "/api/updateProfile"),
    headers: <String, String>{
      'Content-Type': 'multipart/form-data;',
    },
    body: jsonEncode(<String, dynamic>{
      'userid': userid,
      'display_name': display_name,
      'pfp':
          " ", //http.MultipartFile.fromBytes('picture', File(pfp!.path).readAsBytesSync(),filename: pfp.path),
      'bio': bio,
      'location': location
    }),
  );

  if (response.statusCode == 200) {
    print("debug->");
    print(response.body.toString());

    // Parse the JSON response.
    final Map<String, dynamic> responseBody = jsonDecode(response.body);

    print(responseBody["message"]);

    //return jsonDecode(response.body) as Map<String, dynamic>;
    //or
    return responseBody;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    print(response.body.toString()); //debug
    throw Exception('Profile update query error');
  }
}

Future<Map<String, dynamic>> updateUserProfile(
  //pfp in file format
  String userid,
  String display_name,
  File? pfp,
  String bio,
  String location,
) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse(api + '/api/updateProfile'),
  );

  request.headers['Content-Type'] = 'multipart/form-data';

  request.fields['userid'] = userid;
  request.fields['display_name'] = display_name;
  request.fields['bio'] = bio;
  request.fields['location'] = location;

  //check files in api

  if (pfp != null) {
    var bytes = await pfp.readAsBytes();

    // Attach the image file to the request
    request.files.add(
      http.MultipartFile.fromBytes(
        'pfp',
        bytes,
        filename: 'profile_image',
        //contentType: MediaType('image', 'png'),//not really needed, but supports gifs apparently ?? lmaooo
      ),
    );
  }

  /*request.files.add(
    http.MultipartFile.fromBytes(
      'pfp', 
      await File(pfp!.path).readAsBytes(),
      contentType:
      MediaType(
        'image', 
        'png'
      )
    )
  );*/

  //request.fields['pfp'] = " ";
  /*if (pfp != null) {
    List<int> bytes = await pfp.readAsBytes();

    
  request.files.add(
    http.MultipartFile.fromBytes(    
        'pfp',    
        bytes,
        filename: 'profile_image.png',
        
      ),
      
    );

  
    
  }*/

  try {
    var response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      print('debug->');
      print(response.body.toString());

      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      print(responseBody['message']);

      return responseBody;
    } else {
      print(response.body.toString());
      throw Exception('Profile update query error');
    }
  } catch (error) {
    print(error.toString());
    throw Exception('Profile update query error');
  }
}

Future<Map<String, dynamic>> updateUserProfile_new(
    //all json format
    String userid,
    String display_name,
    File? pfp,
    String bio,
    String location) async {
  List<int> bytes = await pfp!.readAsBytes(); //if not null read
  http.MultipartFile photo = http.MultipartFile.fromBytes(
    'pfp',
    bytes,
    filename: 'profile_image.png',
  );

  final response = await http.post(
    Uri.parse(api + "/api/updateProfile"),
    headers: <String, String>{
      'Content-Type': 'multipart/form-data;',
    },
    body: jsonEncode(<String, dynamic>{
      'userid': userid,
      'display_name': display_name,
      'pfp': photo,
      'bio': bio,
      'location': location
    }),
  );

  if (response.statusCode == 200) {
    print("debug->");
    print(response.body.toString());

    // Parse the JSON response.
    final Map<String, dynamic> responseBody = jsonDecode(response.body);

    print(responseBody["message"]);

    //return jsonDecode(response.body) as Map<String, dynamic>;
    //or
    return responseBody;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    print(response.body.toString());
    throw Exception('Profile update query error');
  }
}

Future<Map<String, dynamic>> updateUserProfile_test(String userid,
    String display_name, File pfp, String bio, String location) async {
  final response = await http.post(
    Uri.parse(api + "/api/updateProfile"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'userid': userid,
      'display_name': display_name,
      'pfp': await pfp
          .readAsBytes(), //http.MultipartFile.fromBytes('picture', File(pfp!.path).readAsBytesSync(),filename: pfp.path),
      'bio': bio,
      'location': location
    }),
  );

  if (response.statusCode == 200) {
    print("debug->");
    print(response.body.toString());

    // Parse the JSON response.
    final Map<String, dynamic> responseBody = jsonDecode(response.body);

    print(responseBody["message"]);

    //return jsonDecode(response.body) as Map<String, dynamic>;
    //or
    return responseBody;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    print(response.body.toString()); //debug
    throw Exception('Profile update query error');
  }
}

/*
Future<List<todos>> fetchTodos() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.



    /*print("-DEBUG-\napi response: "+response.body);
    return todos.fromJson(jsonDecode(response.body) as Map<String, dynamic>);*/

    final List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((data) => todos.fromJson(data)).toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load todos - API class');
  }
}

*/

//create getusernotes

Future<List<todos>> fetchNotes() async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    //print("-DEBUG-\napi response: "+response.body);

    List<dynamic> list = jsonDecode(response.body);
    List<todos> todoslist = list.map((data) => todos.fromJson(data)).toList();

    return todoslist;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load todos - API class');
  }
}

Future<List<Note>> fetchUserNotes(int userid) async {
  final response = await http.post(
    Uri.parse(api + "/api/getusernotes"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'userid': userid,
    }),
  );

  if (response.statusCode == 200) {
    //print("debug->");
    print(response.body.toString());

    // Parse the JSON response.
    List<dynamic> responseBody = jsonDecode(response.body);
    List<Note> noteslist = responseBody.map((e) => Note.fromJson(e)).toList();

    //debug
    //print(responseBody["message"]);

    //return jsonDecode(response.body) as Map<String, dynamic>;
    //or
    return noteslist;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    //print(response.body.toString());//debug
    throw Exception('Register query error');
  }
}

Future<Map<dynamic, dynamic>> deleteNote(int noteid) async {
  final response = await http.post(
    Uri.parse(api + "/api/deletenote"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'noteid': noteid,
    }),
  );

  if (response.statusCode == 200) {
    //print("debug->");
    print(response.body.toString());

    // Parse the JSON response.
    Map<dynamic, dynamic> responseBody = jsonDecode(response.body);
    // List<Note> noteslist = responseBody.map((e) => Note.fromJson(e)).toList();

    //debug
    //print(responseBody["message"]);

    //return jsonDecode(response.body) as Map<String, dynamic>;
    //or
    return responseBody;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    //print(response.body.toString());//debug
    throw Exception('Register query error');
  }
}

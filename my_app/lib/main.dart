import 'package:flutter/material.dart';
import 'package:my_app/Api.dart';
import 'package:my_app/Widgets/showInfoAlert.dart';
import 'Dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                // Implement login logic here
                String username = _usernameController.text;
                String password = _passwordController.text;
                print(
                    'form fields - ' + 'Login: $username, Password: $password');

                //postTest(username, password);//debug
                /*MaterialPageRoute(
                  builder: (context) => Dashboard(username: "Logged in as "+_usernameController.text),
                );*/
                try {
                  Map<String, dynamic> responseBody =
                      await userLogin(username, password);

                  if (responseBody["status"] == true) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Dashboard(userid: responseBody["userid"])),
                    );
                  } else {
                    showInfoAlert(context,
                        "Login unsuccessful: ${responseBody['message']}");
                  }
                } catch (error) {
                  showInfoAlert(context, "Error during login: $error");
                }
              },
              child: const Text('Login'),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                // Implement registration logic here
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationPage()),
                );
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _displaynameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _displaynameController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'display name',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'email',
              ),
            ),
            SizedBox(height: 24.0),
            //button + logic
            ElevatedButton(
              onPressed: () async {
                // Implement registration logic here
                print('Registration button pressed');

                try {
                  Map<String, dynamic> responseBody = await userRegister(
                      _usernameController.text,
                      _passwordController.text,
                      _displaynameController.text,
                      _emailController.text);

                  if (responseBody["status"] == true) {
                    //login ok and clear fields and popup to go back and login
                    showInfoAlert(context,
                        "Registration Successful, go back and login: ${responseBody['message']}");
                  } else {
                    showInfoAlert(context,
                        "Registration unsuccessful: ${responseBody['message']}");
                  }
                } catch (error) {
                  showInfoAlert(context, "Error during registration: $error");
                }
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

/*
// sample default pages
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  TextEditingController _textFieldController = TextEditingController();

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Padding(
          padding: EdgeInsets.only(left: 15, right: 15),          
        child: Column(          
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,                    
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextField(
              controller: _textFieldController,
              decoration: InputDecoration(
              hintText: "Username",
            )),
            SizedBox(height: 15),//spacing
            ElevatedButton(
              onPressed:(){
                Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Dashboard(/*username: "Logged in as "+_textFieldController.text*/),
              ),
            );
              },
              
              child: Text("Login"),
              ),
            
          ],
        ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    _textFieldController.dispose();
    super.dispose();
  }
  
}*/

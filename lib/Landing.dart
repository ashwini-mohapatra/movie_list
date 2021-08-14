import 'package:awesome_loader/awesome_loader.dart';
import 'package:dialog_context/dialog_context.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_list/screens/Home.dart';
import 'package:movie_list/screens/Login.dart';

class Landing extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Landing();
  }
}

class _Landing extends State<Landing>{

  bool _initialized = false;
  bool _error = false;
  late var ab;
  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if(_error) {
      DialogContext().showDialog(builder: (context)=>AlertDialog(
          title: new Text("Initialization Error"),
          content: new Text("Error while Initializing Firebase. Try again later")
      ));
    }

    // return new MaterialApp(
    //   home: Scaffold(
    //     body: Center(
    //       child: AwesomeLoader(
    //       ),
    //     ),
    //   ),
    // );
    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return AwesomeLoader();
    }

    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        ab=Login();
      } else {
        ab=Home();
      }
    });
    return ab;
  }
}
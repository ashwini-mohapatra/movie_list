import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_list/screens/Home.dart';
import 'package:movie_list/screens/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late var uid;

  void storeUID(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', id);
  }

  getUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id=prefs.getString('uid');
    return id;
  }

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
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Initializaion Error"),
            content: Text("Error While Initializing Firebase. Please Try Again Later"),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
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
      return CircularProgressIndicator();
    }
    var f=0;
    uid=getUID();
    if(uid==""){
      FirebaseAuth.instance
          .authStateChanges()
          .listen((User? user) {
        if (user == null) {
          f=0;
          Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> Login()));
        } else {
          f=1;
          uid=user.uid;
          storeUID(uid);
          Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> Home()));
        }
      });
    }else{
      Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> Home()));
    }
    return (f==0)?Login():Home();
  }
}
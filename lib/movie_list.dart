import 'package:flutter/material.dart';
import 'package:movie_list/Landing.dart';
import 'package:movie_list/screens/Home.dart';
import 'package:movie_list/screens/Login.dart';

class movie_list extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: Landing(),
    );
  }
}
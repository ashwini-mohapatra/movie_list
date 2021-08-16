import 'package:flutter/material.dart';
import 'package:movie_list/Landing.dart';
import 'package:movie_list/screens/Home.dart';
import 'package:movie_list/screens/Login.dart';
import 'package:provider/provider.dart';

class movie_list extends StatelessWidget{


  @override
  Widget build(BuildContext context){
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: Landing(),
    );
  }
}
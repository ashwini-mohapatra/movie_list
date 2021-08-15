import 'package:dialog_context/dialog_context.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movie_list/screens/Home.dart';
import 'package:movie_list/screens/Register.dart';
import 'package:movie_list/services/GoogleSignInProvider.dart';
import 'package:provider/provider.dart';

import '../Landing.dart';

class Login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Login();
  }

}
class _Login extends State<Login>{

  late var name,password;
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController t1=TextEditingController();
  TextEditingController t2=TextEditingController();



  signin(name,pass) async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: name,
          password: pass
      );
      if(userCredential==true){
        Landing().storeUID(userCredential.user.uid);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      }else{
        DialogContext().showSnackBar(
            snackBar: SnackBar(content: Text('SignIn Failed'))
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        DialogContext().showSnackBar(
            snackBar: SnackBar(content: Text('No user found for that email'))
        );
        //print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        DialogContext().showSnackBar(
            snackBar: SnackBar(content: Text('Wrong password provided for that user'))
        );
        //print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: PreferredSize(preferredSize: Size.fromHeight(0), child: Container(color: Colors.indigo)),
      body: Stack(
        children: <Widget>[
          Container(color: Colors.indigo, height: 220),
          Column(
            children: <Widget>[
              Container(height: 40),
              Container(
                child: Image.asset('assets/images/d1.png'),
                width: 80, height: 80,
              ),
              Card(
                  shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(6)),
                  margin: EdgeInsets.all(25),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child :  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(height: 25),
                        Text("SIGN IN"),
                        TextField(
                          controller: t1,
                          keyboardType: TextInputType.text,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(labelText: "Email",
                            labelStyle: TextStyle(color: Colors.blueGrey[400]),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueGrey, width: 1),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueGrey, width: 2),
                            ),
                          ),
                        ),
                        Container(height: 25),
                        TextField(
                          controller: t2,
                          keyboardType: TextInputType.text,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(labelText: "Password",
                            labelStyle: TextStyle(color: Colors.blueGrey[400]),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueGrey, width: 1),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueGrey, width: 2),
                            ),
                          ),
                        ),
                        Container(height: 25),
                        Container(
                          width: double.infinity,
                          height: 40,
                          child: FlatButton(
                            child: Text("SUBMIT",
                              style: TextStyle(color: Colors.white),),
                            color: Colors.indigo,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20)
                            ),
                            onPressed: () {
                              setState(() {
                                name=t1.text;
                                password=t2.text;
                              });
                              signin(name, password);
                            },
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: FlatButton(
                            child: Text("New user? Sign Up",
                              style: TextStyle(color: Colors.indigoAccent),),
                            color: Colors.transparent,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Register()),
                              );
                            },
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.indigoAccent,
                              onPrimary: Colors.black,
                              minimumSize: Size(double.infinity,50),
                            ),
                            icon: FaIcon(FontAwesomeIcons.google),
                            onPressed: () {
                              var provider=Provider.of<GoogleSignInProvider>(context,listen: false);
                              provider.signInWithGoogle();
                            },
                            label: Text('Signin with Google'),
                          ),
                        ),
                      ],
                    ),
                  )
              )
            ],
          )
        ],
      ),

    );
  }

}
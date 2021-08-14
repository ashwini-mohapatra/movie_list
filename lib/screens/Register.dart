import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_list/screens/Login.dart';

class Register extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Register();
  }
}
class _Register extends State<Register>{

  TextEditingController t1=TextEditingController();
  TextEditingController t2=TextEditingController();
  late var name,password;

  register(name,pass) async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: name,
          password: pass
      );
      if(userCredential==true){
        Home();
      }else{

      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
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
                        Text("SIGN UP"),
                        TextField(
                          controller: t1,
                          keyboardType: TextInputType.text,
                          style: TextStyle(color: Colors.white),
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
                          style: TextStyle(color: Colors.white),
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
                              register(name,password);
                            },
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: FlatButton(
                            child: Text("Old user? Sign In",
                              style: TextStyle(color: Colors.indigoAccent),),
                            color: Colors.transparent,
                            onPressed: () {
                              Login();
                            },
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
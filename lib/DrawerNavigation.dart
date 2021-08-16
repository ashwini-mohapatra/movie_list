import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_list/screens/Home.dart';
import 'package:movie_list/screens/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerNavigation extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DrawerNavigation();
  }
  
}

class _DrawerNavigation extends State<DrawerNavigation>{

  late var uid;

  getUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id=prefs.getString('uid');
    return (uid=='')?"":uid;
  }
  void storeUID(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('uid', id);
  }
  void _logout(){
    storeUID("");
    Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> Login()));
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    uid=getUID();
    return Container(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(""),
              accountEmail: Text(""),
              currentAccountPicture: GestureDetector(
                child: CircleAvatar(
                  child: Image.asset('assets/images/d1.png'),
                  // child: Icon(Icons.person,color: Colors.white,size: 50.0,),
                  // backgroundColor: Colors.purple.shade700,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.indigo,
              ),

            ),
            ListTile(
              title: Text("Home"),
              leading: Icon(Icons.home),
              onTap: (){
                Navigator.of(context).pop();
                //Home();
                Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> Home()));
              },
            ),
            ListTile(
              title: Text("Logout"),
              leading: Icon(Icons.login),
              onTap: (){
                Navigator.of(context).pop();
                //Login();
                _logout();
                },
            ),
          ],
        ),
      ),
    );
  }

}
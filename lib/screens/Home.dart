import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_list/DrawerNavigation.dart';
import 'package:movie_list/models/Movie.dart';
import 'package:movie_list/movie_list.dart';
import 'package:movie_list/services/Uploadservice.dart';
import 'package:movie_list/services/Utility.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Home();
  }
}
class _Home extends State<Home>{

  Uploadservice uploadservice=Uploadservice();
  TextEditingController t1=TextEditingController();
  TextEditingController t2=TextEditingController();
  late List<Widget> _movies;
  late var uid;
  late var img;
  final ImagePicker _picker = ImagePicker();
  Utility u=Utility();
  List<XFile>? _imageFileList;

  @override
  void initState(){
    super.initState();
    getMovies();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(Home oldWidget) {
    super.didUpdateWidget(oldWidget);
  }


  @override
  void dispose() {
    super.dispose();
  }

  getUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id=prefs.getString('uid');
    return (uid=='')?"":uid;
  }

  imageconv(_imageFileLists) async{
    final file = _imageFileLists; // File
    final bytes = await file.readAsBytes(); // Uint8List
    final byteData = bytes.buffer.asByteData(); // ByteData
    return byteData;
  }

  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
    var bcd=imageconv(_imageFileList);
    img="";
    img=u.base64String(bcd);
  }

  void getuid(){
    uid=0;
  }

  getMovies() async{
    //late Movie movies;
    Movie movies=new Movie();
    _movies=<Widget>[];
    var ab=await uploadservice.getMovies();
    setState(() {
    ab.forEach((even){
    if(even['uid']==uid){
    print(even['mid']);
    movies.mid=even['mid'];
    print(even['name']);
    movies.name=even['name'];
    print(even['director']);
    movies.director=even['director'];
    print(even['image']);
    movies.image=even['image'];
    _movies.add(Padding(
    padding: EdgeInsets.only(top:8.0, left: 8.0, right: 8.0),
    child: FlatButton(
    child: Card(
    elevation: 8,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(0)),
    child: ListTile(
    title: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      u.imageFromBase64String(movies.image),
      Text(movies.name)
    ],
    ),
    subtitle: Text(movies.director),
    //  trailing: Text(event.date ?? 'No Date'),
    )),
    onPressed: (){
    _decisiondialog(context, movies.mid);
    },
    ),
    )
    );
    }
    });
    });
  }

  _uploadimg() async{
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    //final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile=image;
    });
  }

  showMovie(BuildContext context,id ) async{
    var ab= await uploadservice.getMovieById(id);
    setState(() {
      t1.text=ab[0]['name'] ?? "Movie Name";
      t2.text=ab[0]['director'] ?? "Movie Director";
      img=ab[0]['image'] ?? "iVBORw0KGgoAAAANSUhEUgAAAOEAAADhCAMAAAAJbSJIAAAAdVBMVEX///9AxP8BV5sDqfQISZQ2wv/Y8v9Qyf/N3eotwP971P8AVZrB6v+86P9s0P9Cxf8ApvQAT5eswtn4/f+m4v8NRI8HTJWU1fnz+/9KuvYXjdKcsc86dKtizf8AO45CeK205f+L2v/J7f9WuewAOY5Fo9yju9WMNapMAAACtElEQVR4nO3b627aQBCGYQebtqQHSp20KU3Sc+//EpuEJGDsXc9OhXZm+r5/LaHvkcUKIbtpiIiIiIiIiIj+pf6FstrDxd2sdH2rPVzazfJM0/Jt7eHSAAI0HkCAxgMI0HgAAdquBwjQdgABGi8+8B1AgKYDCNB4AAEaDyBA4wEEaDyAAI0HEKDxAAI0HkCAxgP4vwJXAI0EEKDx1MA3tZcLAwjQeAABGg8gQOMBBGg8gACNBxCg8QACNB5AgMYD6B6ofPsMoJVOArxYv9S0/u4GuNJ95jlAgOMAAgRYFRj/kDlXjnEDVN7DUwCXpwE2qu+hL6CC6A1YTPQHLCR6BBYdNy6BJUSnQDnRLVBKdAyUEV0DJcTsE7/2gfP/l7oHzhEDAPPEEMAcMftqz6f3Z2sfwDRxBti2CmIVYIo4C1QQKwGniQJgMbEacIooAhYSKwLHRCGwiFgVeEwUAwuIlYFDYgFQTKwOPCQWAYVEA8A9sRAoIpoAPhGLgQKiEeCOqADOEs0A74nZH9sp4AzRELBprn5kLqaBWaIpYLYcMEOMAkwS4wATxEjASWIs4AQxGnBEjAc8IkYEDogxgQfEqMBnYlzgIzEy8IEYG9i2y7Ub4IUK2LY/aw8Xd/VZRdzefqm9XJyKuL3sfoUm3gG70MQHYGTiIzAu8RkYlXgA7LqIJ+oAGJF4BIxHHAGjESeAsYiTwEjEBDAOMQmMQkwDP25ebz7UXi4uSUwB73iLxSIAcRq44y0iEKeAe14A4hg45LknHgPHPOfEIXCa55p4CEzzHBP3wDzPLfEJOM/zRux3xB1QxnNJvAfKeQ6J28synjvi766U5474daMQQrQVRIgughiCeA0RooMgQnQRRIguggjRRRCTQbRUf51+ZCHX7Z/ay8X1r5TVHk5EREREREREVfoLyPeNFl4v5J4AAAAASUVORK5CYII=";
    });
    _showdialog(context);
  }
  editMovie(BuildContext context,id ) async{
    var ab= await uploadservice.getMovieById(id);
    setState(() {
      t1.text=ab[0]['name'] ?? "Movie Name";
      t2.text=ab[0]['director'] ?? "Movie Director";
      img=ab[0]['image'] ?? "iVBORw0KGgoAAAANSUhEUgAAAOEAAADhCAMAAAAJbSJIAAAAdVBMVEX///9AxP8BV5sDqfQISZQ2wv/Y8v9Qyf/N3eotwP971P8AVZrB6v+86P9s0P9Cxf8ApvQAT5eswtn4/f+m4v8NRI8HTJWU1fnz+/9KuvYXjdKcsc86dKtizf8AO45CeK205f+L2v/J7f9WuewAOY5Fo9yju9WMNapMAAACtElEQVR4nO3b627aQBCGYQebtqQHSp20KU3Sc+//EpuEJGDsXc9OhXZm+r5/LaHvkcUKIbtpiIiIiIiIiIj+pf6FstrDxd2sdH2rPVzazfJM0/Jt7eHSAAI0HkCAxgMI0HgAAdquBwjQdgABGi8+8B1AgKYDCNB4AAEaDyBA4wEEaDyAAI0HEKDxAAI0HkCAxgP4vwJXAI0EEKDx1MA3tZcLAwjQeAABGg8gQOMBBGg8gACNBxCg8QACNB5AgMYD6B6ofPsMoJVOArxYv9S0/u4GuNJ95jlAgOMAAgRYFRj/kDlXjnEDVN7DUwCXpwE2qu+hL6CC6A1YTPQHLCR6BBYdNy6BJUSnQDnRLVBKdAyUEV0DJcTsE7/2gfP/l7oHzhEDAPPEEMAcMftqz6f3Z2sfwDRxBti2CmIVYIo4C1QQKwGniQJgMbEacIooAhYSKwLHRCGwiFgVeEwUAwuIlYFDYgFQTKwOPCQWAYVEA8A9sRAoIpoAPhGLgQKiEeCOqADOEs0A74nZH9sp4AzRELBprn5kLqaBWaIpYLYcMEOMAkwS4wATxEjASWIs4AQxGnBEjAc8IkYEDogxgQfEqMBnYlzgIzEy8IEYG9i2y7Ub4IUK2LY/aw8Xd/VZRdzefqm9XJyKuL3sfoUm3gG70MQHYGTiIzAu8RkYlXgA7LqIJ+oAGJF4BIxHHAGjESeAsYiTwEjEBDAOMQmMQkwDP25ebz7UXi4uSUwB73iLxSIAcRq44y0iEKeAe14A4hg45LknHgPHPOfEIXCa55p4CEzzHBP3wDzPLfEJOM/zRux3xB1QxnNJvAfKeQ6J28synjvi766U5474daMQQrQVRIgughiCeA0RooMgQnQRRIguggjRRRCTQbRUf51+ZCHX7Z/ay8X1r5TVHk5EREREREREVfoLyPeNFl4v5J4AAAAASUVORK5CYII=";
    });
    _updatedialog(context,id);
  }

  deleteMovie(BuildContext context,id ) async{
    var ab= await uploadservice.getMovieById(id);
    setState(() {
      t1.text=ab[0]['name'] ?? "Movie Name";
      t2.text=ab[0]['director'] ?? "Movie Director";
      img=ab[0]['image'] ?? "iVBORw0KGgoAAAANSUhEUgAAAOEAAADhCAMAAAAJbSJIAAAAdVBMVEX///9AxP8BV5sDqfQISZQ2wv/Y8v9Qyf/N3eotwP971P8AVZrB6v+86P9s0P9Cxf8ApvQAT5eswtn4/f+m4v8NRI8HTJWU1fnz+/9KuvYXjdKcsc86dKtizf8AO45CeK205f+L2v/J7f9WuewAOY5Fo9yju9WMNapMAAACtElEQVR4nO3b627aQBCGYQebtqQHSp20KU3Sc+//EpuEJGDsXc9OhXZm+r5/LaHvkcUKIbtpiIiIiIiIiIj+pf6FstrDxd2sdH2rPVzazfJM0/Jt7eHSAAI0HkCAxgMI0HgAAdquBwjQdgABGi8+8B1AgKYDCNB4AAEaDyBA4wEEaDyAAI0HEKDxAAI0HkCAxgP4vwJXAI0EEKDx1MA3tZcLAwjQeAABGg8gQOMBBGg8gACNBxCg8QACNB5AgMYD6B6ofPsMoJVOArxYv9S0/u4GuNJ95jlAgOMAAgRYFRj/kDlXjnEDVN7DUwCXpwE2qu+hL6CC6A1YTPQHLCR6BBYdNy6BJUSnQDnRLVBKdAyUEV0DJcTsE7/2gfP/l7oHzhEDAPPEEMAcMftqz6f3Z2sfwDRxBti2CmIVYIo4C1QQKwGniQJgMbEacIooAhYSKwLHRCGwiFgVeEwUAwuIlYFDYgFQTKwOPCQWAYVEA8A9sRAoIpoAPhGLgQKiEeCOqADOEs0A74nZH9sp4AzRELBprn5kLqaBWaIpYLYcMEOMAkwS4wATxEjASWIs4AQxGnBEjAc8IkYEDogxgQfEqMBnYlzgIzEy8IEYG9i2y7Ub4IUK2LY/aw8Xd/VZRdzefqm9XJyKuL3sfoUm3gG70MQHYGTiIzAu8RkYlXgA7LqIJ+oAGJF4BIxHHAGjESeAsYiTwEjEBDAOMQmMQkwDP25ebz7UXi4uSUwB73iLxSIAcRq44y0iEKeAe14A4hg45LknHgPHPOfEIXCa55p4CEzzHBP3wDzPLfEJOM/zRux3xB1QxnNJvAfKeQ6J28synjvi766U5474daMQQrQVRIgughiCeA0RooMgQnQRRIguggjRRRCTQbRUf51+ZCHX7Z/ay8X1r5TVHk5EREREREREVfoLyPeNFl4v5J4AAAAASUVORK5CYII=";
    });
    _deletedialog(context,id);
  }

  _insertdialog(BuildContext context){
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Add New Movie'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: t1,
                  decoration: InputDecoration(
                    labelText: "Movie Name",
                    hintText: "Movie Name",
                  ),
                ),
                TextField(
                  controller: t2,
                  decoration: InputDecoration(
                    labelText: "Movie Director",
                    hintText: "Movie Director",
                  ),
                ),
                FlatButton(
                  child: Text("Image Upload"),
                  onPressed: () {
                    _uploadimg();
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Save'),
              onPressed: () async{
                late Movie movies;
                setState((){
                  movies=new Movie();
                  movies.name=t1.text;
                  movies.director=t2.text;
                  movies.image=img;
                  t1.clear();
                  t2.clear();
                });
                var result=await uploadservice.saveMovie(movies);
                print(result);
                t1.clear();
                t2.clear();
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                getMovies();
                if(result>0){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Success"),
                        content: Text("Successful"),
                        actions: [
                          TextButton(
                            child: Text("OK"),
                            onPressed: () {

                            },
                          ),
                        ],
                      );
                    },
                  );
                }else{
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Failure"),
                        content: Text("Failed"),
                        actions: [
                          TextButton(
                            child: Text("OK"),
                            onPressed: () {

                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  _showdialog(BuildContext context){
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Movie Details'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text("Movie Name",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,height: 3),textAlign: TextAlign.start,),
                Text(t1.text),
                Text("Movie Director",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,height: 3),textAlign: TextAlign.start,),
                Text(t2.text),
                Text("Movie Image",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,height: 3),textAlign: TextAlign.start,),
                u.imageFromBase64String(img),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  _deletedialog(BuildContext context,int id){
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Movie Details'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text("Movie Name",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,height: 3),textAlign: TextAlign.start,),
                Text(t1.text),
                Text("Movie Director",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,height: 3),textAlign: TextAlign.start,),
                Text(t2.text),
                Text("Movie Image",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,height: 3),textAlign: TextAlign.start,),
                u.imageFromBase64String(img),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Delete'),
              onPressed: () async{

                var result=await uploadservice.deleteMovie(id);
                print(result);
                Navigator.of(dialogContext).pop();
                getMovies();
                if(result>0){
                  getMovies();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Success"),
                        content: Text("Successful"),
                        actions: [
                          TextButton(
                            child: Text("OK"),
                            onPressed: () {

                            },
                          ),
                        ],
                      );
                    },
                  );
                }else{
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Failure"),
                        content: Text("Failed"),
                        actions: [
                          TextButton(
                            child: Text("OK"),
                            onPressed: () {

                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }
  _updatedialog(BuildContext context,int id){
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Update Movie'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: t1,
                  decoration: InputDecoration(
                    labelText: "Movie Name",
                    hintText: "Movie Name",
                  ),
                ),
                TextField(
                  controller: t2,
                  decoration: InputDecoration(
                    labelText: "Movie Director",
                    hintText: "Movie Director",
                  ),
                ),
                u.imageFromBase64String(img),
                FlatButton(
                  child:Text("Upload Image"),
                  onPressed:(){
                    _uploadimg();
                },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Update'),
              onPressed: () async{
                late Movie movies;
                setState((){
                  movies=new Movie();
                  movies.name=t1.text;
                  movies.director=t2.text;
                  movies.image=img;
                  t1.clear();
                  t2.clear();
                });
                var result=await uploadservice.updateMovie(movies);
                print(result);
                t1.clear();
                t2.clear();
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                getMovies();
                if(result>0){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Success"),
                        content: Text("Successful"),
                        actions: [
                          TextButton(
                            child: Text("OK"),
                            onPressed: () {

                            },
                          ),
                        ],
                      );
                    },
                  );
                }else{
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Failure"),
                        content: Text("Failed"),
                        actions: [
                          TextButton(
                            child: Text("OK"),
                            onPressed: () {

                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  _decisiondialog(BuildContext context,id){
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Decide Operation'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text("Which of the following operation do you wish to perform?"),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Show'),
              onPressed: (){
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                showMovie(context, id);
              },
            ),
            FlatButton(
              child: Text('Update'),
              onPressed: (){
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                editMovie(context, id);
              },
            ),
            FlatButton(
              child: Text('Delete'),
              onPressed: (){
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                deleteMovie(context, id);
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }
  Future<Null> refreshMovies()async{
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      getMovies();
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Movie List'),
        ),
        drawer: DrawerNavigation(),
        body: RefreshIndicator(
          child: Stack(
            children: <Widget>[ListView(),Column(
              children: _movies,
              ),
              ],
            ),
          onRefresh: refreshMovies,
          ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _insertdialog(context);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
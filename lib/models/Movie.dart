class Movie{

  late int mid;
  late String uid;
  late String name;
  late String director;
  late String image;

  movieMap(){
    var map=Map<String,dynamic>();
    map['mid']=mid;
    map['uid']=uid;
    map['name']=name;
    map['director']=director;
    map['image']=image;
    return map;
  }
}
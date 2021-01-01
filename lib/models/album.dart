import 'package:flutter_todo/models/photo.dart';

class  Album{
  int id;
  String title;
  String directory;
  List<Photo> photos;


  Album({this.id,this.title,this.directory,this.photos});

  factory Album.fromJson(Map<String, dynamic> json) {

    final photo= json['photos'];
    List dataList= photo.map<Photo>((data)=>Photo.fromJson(data)).toList();
    //print(dataList[0].);

    return Album(
      id: json['id'] as int,
      title: json['title'] as String,
      directory: json['directory'] as String,
      photos: dataList
    );
  }


}
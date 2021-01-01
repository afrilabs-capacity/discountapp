class  Photo{
  int id;
  int albumId;
  String title;


  Photo({this.id,this.title,this.albumId});

  factory Photo.fromJson(Map<String, dynamic> json) {

    return Photo(
      id: json['id'] as int,
      albumId: json['album_id'] as int,
      title: json['title'] as String,
    );
  }


}
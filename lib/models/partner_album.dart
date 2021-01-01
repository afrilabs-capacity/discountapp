class  PartnerAlbum{
  int id;
  String title;
  int spotId;
  int userId;
  String directory;



  PartnerAlbum({this.id,this.title,this.spotId,this.userId,this.directory});

  factory PartnerAlbum.fromJson(Map<String, dynamic> json) {

    return PartnerAlbum(
        id: json['id'] as int,
        title: json['title'] as dynamic,
        spotId:json['spot_id'] as int,
        userId:json['user_id'] as int,
        directory:json['directory']

    );
  }


}
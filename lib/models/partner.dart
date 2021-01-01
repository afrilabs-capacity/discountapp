import 'package:flutter_todo/models/partner_album.dart';

class  Partner{
  int id;
  int discount;
  Map state;
  Map category;
  String email;
  String phone;
  String primaryContactPerson;
  String nameOfBusiness;
  String positionHeld;
  String businessLocation;
  String website;
  String categoryImage;
  List <PartnerAlbum> photos;


  Partner({this.id,this.state, this.category,this.email, this.primaryContactPerson, this.nameOfBusiness, this.positionHeld, this. businessLocation, this.website, this.phone, this.categoryImage,this.discount,this.photos});


  factory Partner.fromJson(Map<String, dynamic> json) {
    final photo=json['photo_collection'];
    List<PartnerAlbum> dataList= photo.map<PartnerAlbum>((data)=>PartnerAlbum.fromJson(data)).toList();
    return Partner(
      id: json['id'] as int,
      discount: json['discount'] as int,
      phone: json['phone'] as String,
      email: json['email'] as String,
      primaryContactPerson: json['primary_contact_person'] as String,
      nameOfBusiness: json['name_of_business'] as String,
      positionHeld: json['position_held_in_company'] as String,
      businessLocation: json['location_of_business'] as String,
      website: json['website'] ,
        categoryImage: json['category_image'] as String,
      state:{'id':json['state']['id'],'name':json['state']['name']},
      category:{'id':json['category']['id'],'name':json['category']['name']},
      photos:dataList
    );
  }


}
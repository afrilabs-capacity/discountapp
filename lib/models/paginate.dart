
import 'package:flutter_todo/models/partner.dart';
import 'package:flutter_todo/models/student.dart';
import 'package:flutter_todo/models/message.dart';
import 'package:flutter_todo/models/album.dart';

class  Paginate{
  int currentPage;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  String nextPageUrl;
  String path;
  int perPage;
  String previousPageUrl;
  int to;
  int total;
  List<dynamic> data;


  Paginate({this.currentPage,this.firstPageUrl,this.from,this.lastPage,this.lastPageUrl,this.nextPageUrl,this.path,this.perPage,this.previousPageUrl,this.to,this.total,this.data});



  factory Paginate.fromJson(Map<String, dynamic> json, [String model]) {
    List <dynamic> dataList;

    final data= json['data'];
    if(model=='partner')
      dataList= data.map<Partner>((data)=>Partner.fromJson(data)).toList();
    else if(model=='student')
     dataList= data.map<Student>((data)=>Student.fromJson(data)).toList();

    else if (model=='message')
      dataList= data.map<Message>((data)=>Message.fromJson(data)).toList();

    else if (model=='album')
      dataList= data.map<Album>((data)=>Album.fromJson(data)).toList();

    return Paginate(
        currentPage: json['current_page'],
        firstPageUrl: json['first_page_url'],
        from: json['from'],
        lastPage: json['last_page'],
        lastPageUrl: json['last_page_url'],
        nextPageUrl: json['next_page_url'],
        path: json['path'],
        perPage: json['per_page'],
        previousPageUrl:json['prev_page_url'] ,
        to:json['to'],
        total: json['total'],
        data: dataList
    );
  }


}
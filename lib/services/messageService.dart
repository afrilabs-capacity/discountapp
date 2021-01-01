import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:flutter_todo/models/message.dart';
import 'package:flutter_todo/models/paginate.dart';
import 'package:flutter_todo/providers/auth.dart';

class MessageService{

  AuthProvider authProvider;
  String token;

  // The AuthProvider is passed in when this class instantiated.
  // This provides access to the user token required for API calls.
  // It also allows us to log out a user when their token expires.
  MessageService(AuthProvider authProvider) {
    this.authProvider = authProvider;
    this.token = authProvider.token;
  }

  final api='http://192.168.43.122:8080/laravel/site43/public/api/v1/message';

    Future<Map> sendMessage(Map body) async {
      String url= "$api/save";
      Map<String, dynamic> result = {
      "success": false,
      "message": '',
      "data": null
    };

    var headers = {
    "Accept": "application/json"
    };
    //Map result={};
    //print(body);

    try{
    final response = await http.post( url, headers: headers , body:body);
    print(response.statusCode);
    print(response.body);
    Map apiResponse = json.decode(response.body);

    if(response.statusCode==401){
      //this.authProvider.logOut();
      result['data']=response.body;
      result['success']=false;
      result['code']=response.statusCode;
    }


    if(response.statusCode==200){
      result['code']=response.statusCode;
      result['data']=null;
      //result['paginate']=parseMessagePaginate(response.body);
      result['success']=true;
      //print(parsePartners(response.body));
    }

    if(response.statusCode==422){
      result['code']=response.statusCode;
      result['data']=apiResponse;
      //result['paginate']=parseMessagePaginate(response.body);
      result['success']=false;
      //print(parsePartners(response.body));
    }

    //print(result);
    return result;

    }
    catch(e){
    //result['message']='We\'re experiencing technical difficulties, please try again later';
    result['message']=e.toString();
    result['success']=false;
    print(e.toString());
    return result;
    }


  }


  /*
  * Calls the API, sends a base64 string containing image
  * A 401 indicates that the token has expired.
  * A 200 or 201 indicates the API call was successful.
  */
  Future fetchMessages({int page}) async {
//    Map<String, String> body = {
//      '': "",
//    };

    Map<String, dynamic> result = {
      "success": false,
      "message": '',
      "data":null
    };

    try {
      final response = await http.get(
        '$api/all',
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          "Accept": "application/json"
        },
        //body: body
      );
      print(response.statusCode);
      //print(response.body);
      if(response.statusCode==401){
        //this.authProvider.logOut();
        result['data']=response.body;
        result['success']=false;
        result['code']=response.statusCode;
      }


      if(response.statusCode==200){
        result['code']=response.statusCode;
        result['data']=parseMessages(response.body);
        result['paginate']=parseMessagesPaginate(response.body);
        result['success']=true;
        //print(parsePartners(response.body));
      }

      return result;

    }catch(e){
      print(e.toString());
      result['success']=false;
      result['message']='Api Error';
      return result;
    }


  }


  Future fetchMessagesPaginate(String nextPage) async {
    Map<String, dynamic> result = {
      "success": false,
      "message": '',
      "data": null
    };


    try {
      final response = await http.get(
        nextPage,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          "Accept": "application/json"
        },
        //body: body
      );
      print(response.statusCode);
      print(nextPage);
      if (response.statusCode == 401) {
        //this.authProvider.logOut();
        result['data'] = response.body;
        result['success'] = false;
        result['code'] = response.statusCode;
      }
      if (response.statusCode == 200) {
        result['code'] = response.statusCode;
        result['data'] = parseMessages(response.body);
        result['paginate']=parseMessagesPaginate(response.body);
        result['success'] = true;
        //print(parsePartners(response.body));
      }
      return result;
    } catch (e) {
      print(e.toString());
      result['success'] = false;
      result['message'] = 'Api Error';
      return result;

    }
  }


  Future searchMessages(Map searchPayload ) async {
    Map<String, dynamic> result = {
      "success": false,
      "message": '',
      "data": null
    };


    try {

      var uri = Uri.http(
          '192.168.43.122:8080', '/laravel/site43/public/api/v1/message/search', searchPayload);

      final response = await http.get(
        uri ,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          "Accept": "application/json"
        },
        //body: searchPayload
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 401) {
        //this.authProvider.logOut();
        result['data'] = response.body;
        result['success'] = false;
        result['code'] = response.statusCode;
      }
      if (response.statusCode == 200) {
        result['code'] = response.statusCode;
        result['data'] = parseMessages(response.body);
        result['paginate']=parseMessagesPaginate(response.body);
        result['success'] = true;
        //print(parsePartners(response.body));
      }
      return result;
    } catch (e) {
      print(e.toString());
      result['success'] = false;
      result['message'] = 'Api Error';
      return result;

    }
  }


  List<Message> parseMessages(String responseBody) {
    final original = json.decode(responseBody).cast<String, dynamic>();
    final parsed =json.decode(jsonEncode(original['messages']['data']));
    return parsed.map<Message>((json) => Message.fromJson(json)).toList();
  }

  Paginate parseMessagesPaginate(String responseBody) {
    final response= json.decode(responseBody);
    //print(Paginate.fromJson(response['messages'],'message'));
    return Paginate.fromJson(response['messages'],'message');
  }


}
import 'package:flutter_todo/models/paginate.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:flutter_todo/models/partner.dart';
import 'package:flutter_todo/models/paginate.dart';
import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/utils/exceptions.dart';
import 'package:flutter_todo/services/registrationService.dart';

class PartnerService{

  AuthProvider authProvider;
  String token;

  RegistrationService registrationService= RegistrationService();

  // The AuthProvider is passed in when this class instantiated.
  // This provides access to the user token required for API calls.
  // It also allows us to log out a user when their token expires.
 PartnerService(AuthProvider authProvider) {
    this.authProvider = authProvider;
    this.token = authProvider.token;
  }

  final String api = 'http://192.168.43.122:8080/laravel/site43/public/api/v1/partners';

  /*
  * Calls the API, sends a base64 string containing image
  * A 401 indicates that the token has expired.
  * A 200 or 201 indicates the API call was successful.
  */
  Future fetchPartners({int page}) async {
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
          api,
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
        result['data']=parsePartners(response.body);
        result['paginate']=parsePartnersPaginate(response.body);
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

  Future fetchPartnersPaginate(String nextPage) async {
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
        result['data'] = parsePartners(response.body);
        result['paginate']=parsePartnersPaginate(response.body);
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

  Future searchPartners(Map searchPayload ) async {
    Map<String, dynamic> result = {
      "success": false,
      "message": '',
      "data": null
    };


    try {

//      Uri outgoingUri = new Uri(scheme: 'http',
//          host: '192.168.43.122',
//          port: 8080,
//          path: 'laravel/site43/public/api/v1/partners/search',
//          queryParameters:searchPayload);

      var uri = Uri.http(
          '192.168.43.122:8080', '/laravel/site43/public/api/v1/partners/search', searchPayload);

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
        result['data'] = parsePartners(response.body);
        result['paginate']=parsePartnersPaginate(response.body);
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

  Future<Map> registerPartner(Map body) async {
    final url = "$api/register";

    var headers = {
      "Accept": "application/json"
    };
    Map result={};

    try {
      final response = await http.post(url, headers: headers, body: body);
      Map apiResponse = json.decode(response.body);
      print(apiResponse);
      result = registrationService.buildPartnerResponse('partner', response);
      return result;
    }catch(e){
      //result['message']='We\'re experiencing technical difficulties, please try again later';
      result['message']=e.toString();
      result['success']=false;
      print(e.toString());
      return result;
    }

  }

  Future fetchPartner(Map searchPayload ) async {
    //print(searchPayload);
    Map<String, dynamic> result = {
      "success": false,
      "message": '',
      "data": null
    };


    try {

      var uri = Uri.http(
          '192.168.43.122:8080', '/laravel/site43/public/api/v1/partner', searchPayload);
      //print(uri);
      final response = await http.get(
        uri ,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          "Accept": "application/json"
        },
        //body: searchPayload
      );
      print(response.statusCode);
      //print(response.body);
      //print(json.decode(response.body)['student']['payments']);
      if (response.statusCode == 401) {
        //this.authProvider.logOut();
        result['data'] = response.body;
        result['success'] = false;
        result['code'] = response.statusCode;
      }
      if (response.statusCode == 200) {
        Map<String,dynamic> decodedPartner=json.decode(response.body);
        result['code'] = response.statusCode;
        result['data'] = Partner.fromJson(decodedPartner['partner']);
        //result['paginate']=parseStudentsPaginate(response.body);
        result['success'] = true;
        // print(decodedStudent['student']['id']);
        //Student.fromJson(json.decode(response.body))
        //print(Student.fromJson(decodedStudent['student']));
      }
      return result;
    } catch (e) {
      print(e.toString());
      result['success'] = false;
      result['message'] = 'Api Error';
      return result;

    }
  }


  Future<Map> uploadPhoto(Map body) async {
    final url = "$api/photo";

    var headers = {
      "Accept": "application/json"
    };
    Map<String, dynamic> result = {
      "success": false,
      "message": '',
      "data": null
    };

    try {
      final response = await http.post(url, headers: headers, body: body);
      //Map apiResponse = json.decode(response.body);
      print(response.body);
      if (response.statusCode == 401) {
        //this.authProvider.logOut();
        result['data'] = response.body;
        result['success'] = false;
        result['code'] = response.statusCode;
      }

      if (response.statusCode == 200) {
        Map<String,dynamic> decodedPartner=json.decode(response.body);
        result['code'] = response.statusCode;
        result['data'] = Partner.fromJson(decodedPartner['partner']);
        //result['paginate']=parseStudentsPaginate(response.body);
        result['success'] = true;
      }
      return result;
    }catch(e){
      //result['message']='We\'re experiencing technical difficulties, please try again later';
      result['message']=e.toString();
      result['success']=false;
      print(e.toString());
      return result;
    }

  }


  Future<Map> deletePhoto(Map<String, String> body) async {
    final url = "$api/photo/remove";

    //print(body);
    //return {};

    var headers = {
      "Accept": "application/json"
    };

    Map<String, dynamic> result = {
      "success": false,
      "message": '',
      "data": null
    };


    try {
      final response = await http.post(url, headers: headers, body: body);
      //Map apiResponse = json.decode(response.body);
      print(response.body);

      if (response.statusCode == 401) {
        //this.authProvider.logOut();
        result['data'] = response.body;
        result['success'] = false;
        result['code'] = response.statusCode;
      }

      if (response.statusCode == 200) {
        Map<String,dynamic> decodedPartner=json.decode(response.body);
        result['code'] = response.statusCode;
        result['data'] = Partner.fromJson(decodedPartner['partner']);
        //result['paginate']=parseStudentsPaginate(response.body);
        result['success'] = true;
      }

      return result;
    }catch(e){
      //result['message']='We\'re experiencing technical difficulties, please try again later';
      result['message']=e.toString();
      result['success']=false;
      print(e.toString());
      return result;
    }

  }

  List<Partner> parsePartners(String responseBody) {
    final original = json.decode(responseBody).cast<String, dynamic>();
    final parsed =json.decode(jsonEncode(original['partners']['data']));
    return parsed.map<Partner>((json) => Partner.fromJson(json)).toList();
  }

 Paginate parsePartnersPaginate(String responseBody) {
    final response= json.decode(responseBody);
    return Paginate.fromJson(response['partners'],'partner');
  }


}
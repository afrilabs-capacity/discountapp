import 'package:flutter_todo/models/paginate.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:flutter_todo/models/student.dart';
import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/utils/constants.dart';

class StudentService{

  AuthProvider authProvider;
  String token;

  // The AuthProvider is passed in when this class instantiated.
  // This provides access to the user token required for API calls.
  // It also allows us to log out a user when their token expires.
  StudentService(AuthProvider authProvider) {
    this.authProvider = authProvider;
    this.token = authProvider.token;
  }

  final String api = '$siteUrlBase/laravel/site43/public/api/v1/students';

  /*
  * Calls the API, sends a base64 string containing image
  * A 401 indicates that the token has expired.
  * A 200 or 201 indicates the API call was successful.
  */
  Future fetchStudents({int page}) async {
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
        result['data']=parseStudents(response.body);
        result['paginate']=parseStudentsPaginate(response.body);
        print('we are calling students');
        result['success']=true;
        //print(parseStudents(response.body));

      }

      return result;

    }catch(e){
      print(e.toString());
      result['success']=false;
      result['message']='Api Error';
      return result;
    }


  }

  Future fetchStudent(Map searchPayload ) async {
    //print(searchPayload);
    Map<String, dynamic> result = {
      "success": false,
      "message": '',
      "data": null
    };


    try {

      var uri = Uri.http(
          '192.168.43.122:8080', '/laravel/site43/public/api/v1/student', searchPayload);
          //print(uri);
      final response = await http.get(
        uri ,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          "Accept": "application/json"
        },
        //body: searchPayload
      );
      //print(response.statusCode);
      //print(json.decode(response.body)['student']['payments']);
      if (response.statusCode == 401) {
        //this.authProvider.logOut();
        result['data'] = response.body;
        result['success'] = false;
        result['code'] = response.statusCode;
      }
      if (response.statusCode == 200) {
        Map<String,dynamic> decodedStudent=json.decode(response.body);
        print(decodedStudent);
        result['code'] = response.statusCode;
        result['data'] = Student.fromJson(decodedStudent['student']);
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



  Future activateStudent(Map searchPayload ) async {
    //print(searchPayload);
    Map<String, dynamic> result = {
      "success": false,
      "message": '',
      "data": null
    };


    try {

      var uri = Uri.http(
          '192.168.43.122:8080', '/laravel/site43/public/api/v1/student/activate', searchPayload);
      //print(uri);
      final response = await http.get(
        uri ,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          "Accept": "application/json"
        },
        //body: searchPayload
      );
      //print(response.statusCode);
      print(response.body);
      if (response.statusCode == 401) {
        //this.authProvider.logOut();
        result['data'] = response.body;
        result['success'] = false;
        result['code'] = response.statusCode;
      }
      if (response.statusCode == 200) {
        Map<String,dynamic> decodedStudent=json.decode(response.body);
        result['code'] = response.statusCode;
        //result['data'] = Student.fromJson(decodedStudent['student']);
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


  Future fetchStudentsPaginate(String nextPage) async {
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
        result['data'] = parseStudents(response.body);
        result['paginate']=parseStudentsPaginate(response.body);
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

  Future searchStudents(Map searchPayload ) async {
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
          '192.168.43.122:8080', '/laravel/site43/public/api/v1/students/search', searchPayload);

      print(uri);

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
      if (response.statusCode == 401) {
        //this.authProvider.logOut();
        result['data'] = response.body;
        result['success'] = false;
        result['code'] = response.statusCode;
      }
      if (response.statusCode == 200) {
        result['code'] = response.statusCode;
        result['data'] = parseStudents(response.body);
        result['paginate']=parseStudentsPaginate(response.body);
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

  List<Student> parseStudents(String responseBody) {
    final original = json.decode(responseBody).cast<String, dynamic>();
    final parsed =json.decode(jsonEncode(original['students']['data']));
   // print(parsed);
    //final student = parsed.map<Student>((json) => Student.fromJson(json)).toList();
    return parsed.map<Student>((json) => Student.fromJson(json)).toList();
  }

//  List<Student> parseStudent(String responseBody) {
//    final original = json.decode(responseBody).cast<String, dynamic>();
//    final parsed =json.decode(jsonEncode(original['student']));
//    return parsed.map<Student>((json) => Student.fromJson(json)).toList();
//  }

  Paginate parseStudentsPaginate(String responseBody) {
    final response= json.decode(responseBody);
    //print(response['students']);
    return Paginate.fromJson(response['students'],'student');
  }


}
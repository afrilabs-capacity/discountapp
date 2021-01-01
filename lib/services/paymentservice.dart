import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/utils/exceptions.dart';
import 'package:flutter_todo/views/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/models/student.dart';



class PaymentsService{

  AuthProvider authProvider;
  String token;

  // The AuthProvider is passed in when this class instantiated.
  // This provides access to the user token required for API calls.
  // It also allows us to log out a user when their token expires.
  PaymentsService(AuthProvider authProvider){
    this.authProvider = authProvider;
    //this.authProvider.initAuthProvider();
    this.token = authProvider.token;
    //print(this.token);
    //return;
  }



  final String api = 'http://192.168.43.122:8080/laravel/site43/public/api/v1';


  /*
  * Validates the response code from an API call.
  * A 401 indicates that the token has expired.
  * A 200 or 201 indicates the API call was successful.
  */
  void validateResponseStatus(int status, int validStatus) {
    if (status == 401) {
      throw new AuthException( "401", "Unauthorized" );
    }

    if (status != validStatus) {
      throw new ApiException( status.toString(), "API Error" );
    }
  }
  /*
  * Calls the API to verify transaction based on reference returned from Paystack
  * A 401 indicates that the token has expired.
  * A 200 or 201 indicates the API call was successful.
  */
  Future generateTransRef(String type,{int amount, String delivery} ) async {

    Map<String, dynamic> result = {
      "success": false,
      "message": '',
      "data":null,
      "code":null
    };

//    print(this.authProvider.token);
//    this.authProvider.logOut();
//    return result;
    Map<String, dynamic> body={};
    if(type=='card'){
      body['type']=type;
    }else{
      body['type']=type;
      body['amount']=amount.toString();
      body['delivery']=delivery!=null? delivery:null;
    }


    try {
      final response = await http.post(
          '$api/generate_trans_ref',
          headers: {
            HttpHeaders.authorizationHeader:'Bearer $token',
            "Accept": "application/json"
          },
        body:body

      );

      //print(response.body);
      //print(response.statusCode);
      //print(token);

      if(response.statusCode==401){
        this.authProvider.logOut();
        result['data']=response.body;
        result['success']=false;
        result['code']=response.statusCode;
      }


      if(response.statusCode==200){
        result['code']=response.statusCode;
        result['data']=response.body;
        result['success']=true;
      }


      return result;
    }catch(e){
      print( e.toString());
      result['success']=false;
      result['message']=e.toString();
      print(   e.toString()  );
      return result;



    }


  }



  /*
  * Calls the API and returns a new reference for transaction
  * A 401 indicates that the token has expired.
  * A 200 or 201 indicates the API call was successful.
  */
  Future verifyTransaction(String type,String reference, String delivery) async {

    Map<String, dynamic> result = {
      "success": false,
      "message": '',
      "data":null,
      "code":null
    };

    Map<String, String> body = {
      'type': type,
      'reference':reference,
      'delivery':delivery
    };

    try {
      final response = await http.post(
          '$api/verify_transaction',
          headers: {
            HttpHeaders.authorizationHeader:'Bearer $token',
            "Accept": "application/json"
          },
          body:body

      );

      print(response.body);
      //print(response.statusCode);

      if(response.statusCode==401)
        this.authProvider.logOut();

      if(response.statusCode==200){
        Map<String,dynamic> decodedStudent=json.decode(response.body);
        //print(decodedStudent['student']);
        result['data']=Student.fromJson(decodedStudent['student']);
        result['success']=true;
      }


      return result;
    }catch(e){
      print( e.toString());
      result['success']=false;
      result['message']=e.toString();
      return result;
      //print(   e.toString()  );

    }


  }





}
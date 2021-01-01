import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/utils/exceptions.dart';

class UploadService{

  AuthProvider authProvider;
  String token;

  // The AuthProvider is passed in when this class instantiated.
  // This provides access to the user token required for API calls.
  // It also allows us to log out a user when their token expires.
  UploadService(AuthProvider authProvider) {
    this.authProvider = authProvider;
    this.token = authProvider.token;
  }

  final String api = 'http://192.168.43.122:8080/laravel/site43/public/api/v1/upload_passport';

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
  * Calls the API, sends a base64 string containing image
  * A 401 indicates that the token has expired.
  * A 200 or 201 indicates the API call was successful.
  */
 Future uploadPassport(String text) async {
    Map<String, String> body = {
      'image': text,
    };

    Map<String, dynamic> result = {
      "success": false,
      "message": '',
      "data":null
    };




    try {
      final response = await http.post(
          api,
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            "Accept": "application/json"
          },
          body: body
      );
      //print(response.statusCode);
      //print(response.body);
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

       //print(response.body);
         return result;

       //print(response);
       //validateResponseStatus(response.statusCode, 201);
      // Returns the id of the newly created item.
      //Map<String, dynamic> apiResponse = json.decode(response.body);

    }catch(e){

      print(   e.toString()  );
      result['success']=false;
      result['message']='Api Error';
      return result;

       //print(   e.toString()  );

    }


  }


}
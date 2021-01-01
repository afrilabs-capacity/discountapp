import 'dart:convert';
import 'package:flutter_todo/models/partner.dart';

class RegistrationService{


  buildStudentResponse(String regType, dynamic response ){
    Map<String, dynamic> result = {
      "success": false,
      "message": 'Unknown error.',
      "errors":null,
      "code":null
    };
    Map apiResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      result['message']="Registration successful";
      result['success'] = true;
      return result;
    }

    if (response.statusCode == 422) {
      result['success']=false;
      result['errors']=apiResponse['errors'];

      return result;
    }

    return result;

  }

  buildPartnerResponse(String regType, dynamic response){
    Map<String, dynamic> result = {
      "success": false,
      "message": 'Unknown error.',
      "errors":null,
      "code":null
    };

    Map<String, dynamic> apiResponse = json.decode(response.body);
    //print(Partner.fromJson(apiResponse['partner']));
    //print(apiResponse);
    if (response.statusCode == 200) {
      result['data'] = Partner.fromJson(apiResponse['partner']);
      result['raw'] = apiResponse;
      result['message']="Registration successful";
      result['success'] = true;
      return result;
    }

    if (response.statusCode == 422) {
      result['success']=false;
      result['errors']=apiResponse['errors'];
      return result;
    }

    return result;

  }



}
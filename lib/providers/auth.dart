import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:flutter_todo/widgets/notification_text.dart';
import 'package:flutter_todo/services/registrationService.dart';
import 'package:flutter_todo/models/providers/user_provider_model.dart';
import 'package:flutter_todo/providers/user.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthProvider with ChangeNotifier {

  UserProvider userProvider;
  AuthProvider({this.userProvider});

  UserProviderModel userProviderModel;

  Status _status = Status.Uninitialized;
  String _token;
  NotificationText _notification;

  Status get status => _status;
  String get token => _token;
  NotificationText get notification => _notification;

  RegistrationService registrationService= RegistrationService();


  final String api = 'http://192.168.43.122:8080/laravel/site43/public/api/v1/auth';


  initAuthProvider() async {
    String token = await getToken();
    if (token != null) {
      _token = token;
      _status = Status.Authenticated;
      return true;
    } else {
      _status = Status.Unauthenticated;
      return false;
    }

  }

  Future<bool> login(String email, String password) async {
    _status = Status.Authenticating;
    _notification = null;
    notifyListeners();

    //await Future.delayed(const Duration(milliseconds: 5000), () {});

    final url = "$api/login";

    Map<String, String> body = {
      'email': email,
      'password': password,
    };

    try {
      final response = await http.post(url, body: body,);
      print(response.body);
      //return false;

      if (response.statusCode == 200) {
        print('authenticated in login providr');
        Map<String, dynamic> apiResponse = json.decode(response.body);
        _status = Status.Authenticated;
        _token = apiResponse['access_token'];
        await storeUserData(apiResponse);
        await userProvider.userData();
        notifyListeners();
        return true;
      }

      if (response.statusCode == 401) {
        print('unauthenticated in login providr');
        _status = Status.Unauthenticated;
        _notification = NotificationText('Invalid email or password.');
        notifyListeners();
        return false;
      }

      _status = Status.Unauthenticated;
      //print('unauthenticated in login providr below 401');
      _notification = NotificationText('Server error.');
      notifyListeners();
      return false;
    }catch(e){
      //print(e.toString());
      return false;
    }
  }

  Future<Map> register(
  {String titleController, String firstNameController, String middleNameController, String lastNameController, String addressController, String sexController, String cityController, String stateController, String dobController, String idTypeController, String idNumberController, String emailController, String phoneController, String regTypeController, String instituteSchoolController, String matriculationExamNumberController, String levelExpectedGraduationYearController, String passwordController, String passwordConfirmController, String categoryController,String contactPersonController,String businessNameController, String positionHeldController, String businessLocationController, String websiteController, String discountController,String cardHolderController, String nyscCallupController, String ppaController, String actionController, String partnerIdController}
  ) async {
    final url = "$api/register";
    Map<String, String> body = {};
    if (cardHolderController == 'student') {
      body = {
        'title': titleController,
        'first_name': firstNameController,
        'middle_name': middleNameController,
        'last_name': lastNameController,
        'address': addressController,
        'sex': sexController,
        'city': cityController,
        'state': stateController,
        'dob': dobController,
        'id_type': idTypeController,
        'id_number': idNumberController,
        'email': emailController,
        'phone': phoneController,
        'reg_type': regTypeController,
        'institute_school': instituteSchoolController,
        'mat_exam_num': matriculationExamNumberController,
        'level_expected_grauation_year': levelExpectedGraduationYearController,
        'password': passwordController,
        'password_confirmation': passwordConfirmController,
        'card_holder_type': cardHolderController,
//      'nysc_call_up_number':nyscCallupController,
//      'place_of_primary':ppaController

      };
    }

    if (cardHolderController == 'corper') {
      body = {
        'title': titleController,
        'first_name': firstNameController,
        'middle_name': middleNameController,
        'last_name': lastNameController,
        'address': addressController,
        'sex': sexController,
        'city': cityController,
        'state': stateController,
        'dob': dobController,
        'id_type': idTypeController,
        'id_number': idNumberController,
        'email': emailController,
        'phone': phoneController,
        'reg_type': regTypeController,
        'institute_school': instituteSchoolController,
        'password': passwordController,
        'password_confirmation': passwordConfirmController,
        'card_holder_type': cardHolderController,
        'nysc_call_up_number': nyscCallupController,
        'place_of_primary': ppaController
      };
    }

    if (cardHolderController == 'others') {
      body = {
        'title': titleController,
        'first_name': firstNameController,
        'middle_name': middleNameController,
        'last_name': lastNameController,
        'address': addressController,
        'sex': sexController,
        'city': cityController,
        'state': stateController,
        'dob': dobController,
        'id_type': idTypeController,
        'id_number': idNumberController,
        'email': emailController,
        'phone': phoneController,
        'reg_type': regTypeController,
        'password': passwordController,
        'password_confirmation': passwordConfirmController,
        'card_holder_type': cardHolderController,

      };
    }

    var headers = {
      "Accept": "application/json"
    };
    Map result = {};

      try{

        final response = await http.post( url, headers: headers , body:body);
//      print('Hi there register');
        Map apiResponse = json.decode(response.body);
        print(apiResponse);
        if(regTypeController=='student'){
          result= registrationService.buildStudentResponse('student', response );
          if(result['success']){
            await storeUserData(apiResponse);
            _status = Status.Authenticated;
            _token = apiResponse['access_token'];
            notifyListeners();
          }
          return result;
        }else{
          result= registrationService.buildPartnerResponse('partner',response);
          //print(result);
          //result['id']=apiResponse['id'];
          return result;
        }


      }
      catch(e){
        //result['message']='We\'re experiencing technical difficulties, please try again later';
        result['message']=e.toString();
        result['success']=false;
        print(e.toString());
        return result;
      }
    }




  Future<bool> passwordReset(String email) async {
    final url = "$api/forgot-password";
    Map<String, String> body = {
      'email': email,
    };

    final response = await http.post( url, body: body, );

    if (response.statusCode == 200) {
      _notification = NotificationText('Reset sent. Please check your inbox.', type: 'info');
      notifyListeners();
      return true;
    }

    return false;
  }

  storeUserData(apiResponse) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setInt('id', apiResponse['user']['id']);
    await storage.setString('token', apiResponse['access_token']);
    await storage.setString('name', apiResponse['user']['name']);
    await storage.setString('email', apiResponse['user']['email']);
    await storage.setString('account_type', apiResponse['user']['account_type']);
    if(apiResponse['user']['image']!=null)
    await storage.setString('image', apiResponse['user']['image']);
    if(apiResponse['user']['payment']!=null)
      await storage.setString('payment', apiResponse['user']['payment']);
//    if(apiResponse['user']['account_type']=='student')
//      await storage.setString('payment', apiResponse['user']['payment']);

  }

  Future<String> getToken() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token');
    return token;
  }

  logOut([bool tokenExpired = false]) async {
    userProvider.clearUserData();
    userProvider.userAuthenticated={};
    _status = Status.Unauthenticated;
    if (tokenExpired == true) {
      _notification = NotificationText('Session expired. Please log in again.', type: 'info');
    }
    //userProviderModel=null;
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.clear();
    notifyListeners();
    //print(_token);
  }




}
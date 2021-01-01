import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_todo/models/user.dart';
import 'package:flutter_todo/services/studentService.dart';
import 'package:flutter_todo/models/providers/user_provider_model.dart';


class UserProvider with ChangeNotifier{
  int _id;
  String  _name;
  String  _email;
  String  _accountType;
  String  _avatar;
  Map userAuthenticated={};


  get id=> _id;

  get name=> _name;

  get email=> _email;

  get accountType=> _accountType;

  get avatar => _avatar;

  String test ="hey";

bool authenticated=false;

String  payment;

UserProviderModel user;


  clearUserData(){
    _id=null;
    _name=null;
    _email=null;
    _accountType=null;
    _avatar=null;
  }

Future<void> saveUserAvatar(String image) async{
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString('image', image);
    //notifyListeners();
  }

Future<void> savePayment() async{
  SharedPreferences storage = await SharedPreferences.getInstance();
  await storage.setString('payment', 'true');
  //notifyListeners();
}

  Future<String> getUserAvatar() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String image = storage.getString('image');
    return image;
  }

Future<String> getUserName() async {
  SharedPreferences storage = await SharedPreferences.getInstance();
  String name= storage.getString('name');
  //notifyListeners();
  return name;
}

  Future<int> getUserId() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    int name= storage.getInt('id');
    //notifyListeners();
    return name;
  }

Future<String> getUserEmail() async {
  SharedPreferences storage = await SharedPreferences.getInstance();
  String email= storage.getString('email');
  //notifyListeners();
  return email;
}

Future<String> getUserPayment() async {
  SharedPreferences storage = await SharedPreferences.getInstance();
  String payment= storage.getString('payment');
  //notifyListeners();
  return payment;
}

Future<String> getUserAccountType() async {
  SharedPreferences storage = await SharedPreferences.getInstance();
  String accountType= storage.getString('account_type');
  //notifyListeners();
  return accountType;
}

  changeString(String string){
    test=string;
   //notifyListeners();
    //return _test;
}



 userData() async{
   int  id=  await getUserId();
   _id=id;
  String  name= await getUserName();
   _name=name;
  String  email= await getUserEmail();
  _email=email;
  String  accountType= await getUserAccountType();
   _accountType=accountType;
  String  avatar= await getUserAvatar();
   _avatar =avatar;
  String  payment= await getUserPayment();

  Map <String, dynamic> userData= {
    'name': name,
    'email': email,
    'account_type':accountType,
    'avatar':avatar,
    'payment':payment,
  };
    userAuthenticated= userData;
    //notifyListeners();
}




}



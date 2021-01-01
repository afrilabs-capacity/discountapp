import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/services/partnerService.dart';
import 'dart:convert';
import 'package:flutter_todo/views/login.dart';
import 'package:flutter_todo/models/partner.dart';
import 'package:flutter_todo/models/paginate.dart';
import 'package:flutter_todo/models/state.dart';
import 'package:flutter_todo/models/discount.dart';
import 'package:flutter_todo/models/category.dart';
import 'package:flutter_todo/views/admin/admin_single_partner.dart';
import 'package:flutter_todo/models/discount.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PartnerProvider with ChangeNotifier  {


  /* Instance of PartnerService*/
  PartnerService partnerService;

  /* Empty list of partners*/
  List<Partner> partners = [];

  /* Empty pagination data*/
  Paginate  paginate;

  /*loading indicator*/
  bool loadMore=false;

  /*do we have initial data*/
  bool loaded=false;

  /*selected state*/
  String selectedState;

  /*selected discount*/
  String selectedDiscount;

  /*selected category*/
  String selectedCategory;

  /*validator color*/
  Color dropDownValidation_1= Colors.grey;

  /*show filter or not*/
  bool showFilter=false;

  /*show list or images not*/
  bool imageView=true;

  Partner partner;


  partnerSearch(AuthProvider _provider,String businessName)async{
    loaded=false;
    notifyListeners();
    Map<String,String> searchPayload= {};
    searchPayload['state']=selectedState!=null ? selectedState : '';
    searchPayload['category']=selectedCategory!=null ? selectedCategory : '';
    searchPayload['discount']=selectedDiscount != null ? selectedDiscount : '';
    searchPayload['name_of_business']=businessName!='' ? businessName : '';
    //print(searchPayload);
    PartnerService partnerService =PartnerService(_provider);
    var response =await partnerService.searchPartners(searchPayload);
    if(response['code']==401){
      print('token expired');
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
    }

    if(response['success']){
      partners=response['data'];
      paginate=response['paginate'];
      //print(response['data']);
      print(paginate.nextPageUrl);
      loadMore=false;
      showFilter=false;
      loaded=true;
      notifyListeners();
    }

    Future.delayed(Duration(milliseconds: 4000),(){
      loaded=true;
    });

  }

  loadMoreData(_provider)async{
    print(paginate);
    if(paginate.nextPageUrl==null)
      return;
    loadMore=true;
    print('loading more');
    //notifyListeners();
   PartnerService partnerService =PartnerService(_provider);
   var response =await partnerService.fetchPartnersPaginate(paginate.nextPageUrl);

    if(response['code']==401){
      print('token expired');
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
    }

    if(response['success']){
      partners=partners+response['data'];
      paginate=response['paginate'];
      //print(response['paginate']);
      //print(paginate.nextPageUrl);
      loadMore=false;
      notifyListeners();
    }
    loadMore=false;
    notifyListeners();
  }


  initPartners(_provider)async{
    //_provider =  Provider.of<AuthProvider>(context);
    PartnerService partnerService =PartnerService(_provider);
    var response =await partnerService.fetchPartners();
    //Map apiResponse=jsonDecode( response['success']);
    if(response['code']==401){
      print('token expired');
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
    }

    if(response['success']){
      partners=response['data'];
      paginate=response['paginate'];
      loaded=true;
      //print(paginate.nextPageUrl);
      notifyListeners();
    }


  }


  Future<Map> registerPartner(_provider,{String titleController, String cityController, String stateController, String emailController, String phoneController, String regTypeController, String passwordController, String passwordConfirmController, String categoryController,String contactPersonController,String businessNameController, String positionHeldController, String businessLocationController,String websiteController, String discountController, String actionController, String partnerIdController}
      ) async {
    Map<String, String> body={};

    body = {
      'state':stateController,
      'category':categoryController,
      'discount':discountController,
      'primary_contact_person':contactPersonController,
      'phone':phoneController,
      'name_of_business':businessNameController,
      'position_held_in_company':positionHeldController,
      'location_of_business':businessLocationController,
      'email':emailController,
      'website':websiteController,
      'reg_type':regTypeController,
      'action':actionController
    };

    if(regTypeController=='partner' && actionController=='update')
      body['id']=partnerIdController;
    PartnerService partnerService =PartnerService(_provider);
    var result =await partnerService.registerPartner(body);

        if(result['success']){
          notifyListeners();
        }
        return result;

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
  }

  fetchUserById(AuthProvider _provider,int id)async{
    //print( 'id is $id' );
    PartnerService studentService = PartnerService(_provider);
    Map<String,String> searchPayload={};
    searchPayload['id']=id.toString();

    var response =await studentService.fetchPartner(searchPayload);
    //Map apiResponse=jsonDecode( response['success']);
    if(response['code']==401){
      print('token expired');
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
    }

    if(response['success']){
      partner=null;
      partner=response['data'];
      //print(student.payments);
      print('we are about to rebuild');
      notifyListeners();
    }

  }

  flipDealsView(){
    imageView=!imageView;
    notifyListeners();
  }


  uploadPhoto(AuthProvider _provider,Map<String,String> searchPayload)async{
    //print( 'id is $id' );
    PartnerService partnerService = PartnerService(_provider);
    //Map<String,String> searchPayload={};
    //searchPayload=data;
    //print(searchPayload);


    var response =await partnerService.uploadPhoto(searchPayload);
    //Map apiResponse=jsonDecode( response['success']);
    if(response['code']==401){
      print('token expired');
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
    }

    if(response['success']){
      partner=null;
      partner=response['data'];
      //print(student.payments);
      print('we are about to rebuild');
      notifyListeners();
    }

  }


  deletePhoto(AuthProvider _provider,Map<String,String> searchPayload)async{
    //print( 'id is $id' );
    PartnerService partnerService = PartnerService(_provider);
    //Map<String,String> searchPayload={};
    //searchPayload=data;
    //print(searchPayload);


    var response =await partnerService.deletePhoto(searchPayload);
    //Map apiResponse=jsonDecode( response['success']);
    if(response['code']==401){
      print('token expired');
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
    }

    if(response['success']){
      partner=null;
      partner=response['data'];
      //print(student.payments);
      print('we are about to rebuild');
      notifyListeners();
    }

  }




}
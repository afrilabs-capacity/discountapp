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


class DealProvider with ChangeNotifier  {


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
    partners=[];
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

//    Future.delayed(Duration(milliseconds: 3000),(){
//      showFilter=false;
//      notifyListeners();
//    });


  }

  flipDealsView(){
    imageView=!imageView;
    notifyListeners();
  }


}
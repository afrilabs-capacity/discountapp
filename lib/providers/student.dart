import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/services/partnerService.dart';
import 'dart:convert';
import 'package:flutter_todo/views/login.dart';
import 'package:flutter_todo/models/paginate.dart';
import 'package:flutter_todo/models/student.dart';
import 'package:flutter_todo/services/studentService.dart';


class StudentProvider with ChangeNotifier  {


  /* Instance of PartnerService*/
  StudentService studentService;

  /* Empty list of partners*/
  List<Student> students = [];

  /* Empty pagination data*/
  Paginate  paginate;

  /*loading indicator*/
  bool loadMore=false;

  /*do we have initial data*/
  bool loaded=false;

  /*selected state*/
  String selectedState;

  /*student instance*/
  Student student;


  /*validator color*/
  Color dropDownValidation_1= Colors.grey;

  /*show filter or not*/
  bool showFilter=false;


  studentSearch(AuthProvider _provider, {String reference, String name} )async{
    loaded=false;
    notifyListeners();
    Map<String,String> searchPayload= {};
    searchPayload['state']=selectedState!=null ? selectedState : '';
    searchPayload['reference']=reference!=null ? reference : '';
    searchPayload['name']=name!=null ? name : '';
    //searchPayload['reg_type']=regType!=null ? regType : '';
    //print(searchPayload);
    StudentService partnerService =StudentService(_provider);
    var response =await partnerService.searchStudents(searchPayload);
    if(response['code']==401){
      print('token expired');
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
    }

    if(response['success']){
      students=response['data'];
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
    //print(paginate);
    if(paginate.nextPageUrl==null)
      return;
    loadMore=true;
    print('loading more');
    //notifyListeners();
    StudentService studentService =StudentService(_provider);
    var response =await studentService.fetchStudentsPaginate(paginate.nextPageUrl);

    if(response['code']==401){
      print('token expired');
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
    }

    if(response['success']){
      students=students+response['data'];
      paginate=response['paginate'];
      //print(response['paginate']);
      //print(paginate.nextPageUrl);
      loadMore=false;
      notifyListeners();
    }
    loadMore=false;
    notifyListeners();
  }


  initStudents(_provider)async{
    //_provider =  Provider.of<AuthProvider>(context);
    StudentService studentService =StudentService(_provider);
    var response =await studentService.fetchStudents();
    //Map apiResponse=jsonDecode( response['success']);
    if(response['code']==401){
      print('token expired');
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
    }

    if(response['success']){
      students=response['data'];
      paginate=response['paginate'];
      loaded=true;
      //print(paginate.nextPageUrl);
      notifyListeners();
    }



  }


  fetchUserById(AuthProvider _provider,int id)async{
    //print( 'id is $id' );
    StudentService studentService = StudentService(_provider);
    Map<String,String> searchPayload={};
    searchPayload['id']=id.toString();

    var response =await studentService.fetchStudent(searchPayload);
    //Map apiResponse=jsonDecode( response['success']);
    if(response['code']==401){
      print('token expired');
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
    }

    if(response['success']){
      student=null;
      student=response['data'];
      //print(student.payments);
      print('we are about to rebuild');
      notifyListeners();
    }

  }


  activateUserById(AuthProvider _provider,int id,String reference)async{

    //print( 'id is $id' );
    StudentService studentService = StudentService(_provider);
    Map<String,String> searchPayload={};
    searchPayload['id']=id.toString();
    searchPayload['reference']=reference;

    var response =await studentService.activateStudent(searchPayload);
    print(response);
    //Map apiResponse=jsonDecode( response['success']);
    if(response['code']==401){
      print('token expired');
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
    }

    if(response['success']){
      //student=null;
      //student=response['data'];
      //print(student.payments);
      notifyListeners();
    }

    return response;

  }



}
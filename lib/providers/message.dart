import 'package:flutter/material.dart';
import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/models/paginate.dart';
import 'package:flutter_todo/models/message.dart';
import 'package:flutter_todo/services/messageService.dart';


class MessageProvider with ChangeNotifier{

  /* Empty list of partners*/
  List<Message> messages = [];

  /* Empty pagination data*/
  Paginate  paginate;

  /*loading indicator*/
  bool loadMore=false;

  /*do we have initial data*/
  bool loaded=false;

  bool showFilter=false;


  submitAuthForm(AuthProvider provider, {String name, String email, String message,String id})async{
    Map<String,dynamic> payload={};
    payload['user_id']=id.toString();
    payload['name']=name;
    payload['email']=email;
    payload['message']=message;
    MessageService supportService =MessageService(provider);
    final response = await supportService.sendMessage(payload);
    return response;


  }

  submitGuestForm(AuthProvider provider,{String name, String email, String message})async{
    Map<String,dynamic> payload={};
    payload['name']=name;
    payload['email']=email;
    payload['message']=message;
    MessageService supportService =MessageService(provider);
    final response = await supportService.sendMessage(payload);
    return response;
  }


  initMessages(_provider)async{
    //_provider =  Provider.of<AuthProvider>(context);
    messages=[];
    MessageService messageService =MessageService(_provider);
    var response =await messageService.fetchMessages();
    //Map apiResponse=jsonDecode( response['success']);
    if(response['code']==401){
      print('token expired');
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
    }

    if(response['success']){
      messages=response['data'];
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


  messageSearch(AuthProvider _provider,String email)async{
    loaded=false;
    notifyListeners();
    Map<String,String> searchPayload= {};
    searchPayload['email']=email!='' ? email : '';
    //print(searchPayload);
    MessageService messageService =MessageService(_provider);
    var response =await messageService.searchMessages(searchPayload);
    if(response['code']==401){
      print('token expired');
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
    }

    if(response['success']){
      messages=response['data'];
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
    print(paginate.nextPageUrl);
    if(paginate.nextPageUrl==null)
      return;
    loadMore=true;
    print('loading more');
    //notifyListeners();
    MessageService messageService =MessageService(_provider);
    var response =await messageService.fetchMessagesPaginate(paginate.nextPageUrl);

    if(response['code']==401){
      print('token expired');
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
    }

    if(response['success']){
      messages=messages+response['data'];
      paginate=response['paginate'];
      //print(response);
      //print(paginate.nextPageUrl);
      loadMore=false;
      notifyListeners();
    }
    loadMore=false;
    notifyListeners();
  }


}
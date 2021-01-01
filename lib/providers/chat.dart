import 'package:flutter/material.dart';



class ChatProvider with ChangeNotifier{


  String _quotedText;
  String _sender;

  void setQuote(String quote,String sender){
    _quotedText=quote;
    _sender=sender;
    notifyListeners();

  }

  void clearQuote(){
    _quotedText=null;
    _sender=null;
    //notifyListeners();

  }

   get quote=>_quotedText;
  get sender=>_sender;


}
import 'package:flutter/material.dart';


class PaymentModalProvider with ChangeNotifier{

  bool generatedToken=false;

  String _ref;

  String get reference{
    print(_ref);
    return _ref;
  }

  set reference(dynamic reference){
    _ref=reference;
    notifyListeners();
  }


}
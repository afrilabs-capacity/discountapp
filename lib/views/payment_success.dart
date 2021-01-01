import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_todo/components/curved_page_template.dart';
import 'package:flutter_todo/models/user.dart';
import 'package:flutter_todo/views/deals_page.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/providers/user.dart';
import 'package:flutter_todo/providers/paymentmodal.dart';
import 'package:flutter_todo/utils/constants.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:flutter_todo/services/paymentservice.dart';
import 'package:flutter_todo/utils/validate.dart';
import 'package:flutter_todo/styles/styles.dart';


class PaymentSuccess extends StatefulWidget {
  static final id = 'payment_success';



  @override
  _PaymentSuccessState createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {

  UserProvider _userProvider;
  String  _userName;
  String _userAvatar;

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  @override
  void didChangeDependencies() {
    init(context);
    super.didChangeDependencies();

  }



  Future<void>init(context)  async{
//    _provider =  Provider.of<AuthProvider>(context);
    _userProvider =  Provider.of<UserProvider>(context);
    _userName= await _userProvider.getUserName();
    _userAvatar= await _userProvider.getUserAvatar();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    print('rebuilding');
    final userAvatarWidget =
    Center(
        child: CircleAvatar(
          backgroundColor: Colors.green,
          backgroundImage:  NetworkImage("$siteUrl/uploads/card_holders/card_holders$_userAvatar"),
          radius: MediaQuery.of(context).size.width/12,
        ));

    return  WillPopScope(
      onWillPop: () async =>false,
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          //backgroundColor: Color(0xFF21BFBD),
          //backgroundColor: Colors.green,
          //backgroundColor: Color(0xEEE),
//      appBar: AppBar(
//        title: const Text('Go Back',style: TextStyle(color: Colors.green),),
//        iconTheme: IconThemeData(color: Colors.green),
//        backgroundColor: Colors.white,
//
//      ),
          body: SingleChildScrollView(
            child: Container(
              //color: Colors.white,
              child: CurvedPageTemplate( titleBold: 'Payment', titleLight: 'Success',  curvedChild:
              Column(

                //mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 30.0,),
                  _userName!=null? Center(child: Text( 'Hi, $_userName',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0),)) : Text(''),
                  SizedBox(height: 25.0,),
                  Text('Payment Successful!!',style: TextStyle(color:Colors.green,fontSize: 30.0),),
                  SizedBox(height: 5.0,),

                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.all(Radius.circular(25.0))
                    ),

                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.all(15.0),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        _userAvatar!=null ? userAvatarWidget : Text(''),
                        SizedBox(height: 10.0,),

                    Text("Your card is on the way, typically our  discount cards get delivered to Card Holders within 3-5 business days, if you don't get your card by then please leave us a message.",textAlign: TextAlign.justify,style: TextStyle(  fontWeight: FontWeight.w400,color: Colors.black,),),





                      ],),),

                  SizedBox(height: 20.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.all(Radius.circular(25.0))
                                ),
                                padding: EdgeInsets.all(20.0),

                                child: Center(child: GestureDetector(
                                  onTap: (){
                                    Navigator.pushReplacement(context, MaterialPageRoute(
                                      builder: (context)=>DealsPage()
                                    ));
                                  },
                                    child: Text('Browse Deals',style: TextStyle(color: Colors.white),))),
                              ),
                            ),
                          ),
                        ),
                      ],


                    ),
                        SizedBox(width: 10.0,),





                ],
              )

              )
              ,
            ),
          ),
        ),
    );

  }

  @override
  void dispose() {
    super.dispose();
  }



}


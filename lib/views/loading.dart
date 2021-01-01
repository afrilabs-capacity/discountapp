import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/views/deals_page.dart';
import 'package:flutter_todo/views/landing_page.dart';
import 'package:flutter_todo/views/login.dart';
import 'package:flutter_todo/views/card_payment.dart';
import 'package:flutter_todo/views/payment_checkpoint.dart';
import 'package:flutter_todo/views/registration_type.dart';

import 'package:provider/provider.dart';
import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/providers/user.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:flutter_todo/views/upload.dart';
//import 'package:flutter_todo/views/payment.dart';
//import 'package:flutter_todo/views/payment_success.dart';
//import 'package:flutter_todo/views/login.dart';
//import 'package:flutter_todo/views/upload.dart';
import 'package:flutter_todo/views/student_registration.dart';

class Loading extends StatelessWidget {
  final String routeAction;

  Loading({this.routeAction});

  initAuthProvider(context) async {
    //routeAction!=null ? print(routeAction) : print("normal routing");
    //Provider.of<AuthProvider>(context).logOut();
    final authProvider = Provider.of<AuthProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    bool token =await authProvider.initAuthProvider();
    //print(token);
    if(token){
      //print(await userProvider.userData());
      //routeAction!=null ? print(routeAction) : print("normal routing");
       String accountType=await userProvider.getUserAccountType();
       //user is a student / corp member
       if(accountType=='student'){
      String userAvatar=await userProvider.getUserAvatar();
      if(userAvatar==null){
        Navigator.pushReplacement(context, PageRouteBuilder(
          transitionDuration: Duration(seconds: 0),
          pageBuilder: (context, animation1, animation2) => UploadPassport(),
        ));
      }else{
        String paymentStatus=await userProvider.getUserPayment();
        if(paymentStatus==null){
          /*this should redirect to an unobtrusive reminder page where users can decide to pay or keep browsing deals*/
          Navigator.pushReplacement(context, PageRouteBuilder(
            transitionDuration: Duration(seconds: 0),
            pageBuilder: (context, animation1, animation2) => PaymentCheckpoint(),
          ));
        }else{
          Navigator.pushReplacement(context, PageRouteBuilder(
            transitionDuration: Duration(seconds: 0),
            pageBuilder: (context, animation1, animation2) => LandingPage(),
          ));
        }
      }

      }

       //user is a partner
       if(accountType=='partner'){
         Navigator.pushReplacement(context, PageRouteBuilder(
           transitionDuration: Duration(seconds: 0),
           pageBuilder: (context, animation1, animation2) => LandingPage(),
         ));
       }

       //user is an admin
       if(accountType=='admin'){
         Navigator.pushReplacement(context, PageRouteBuilder(
           transitionDuration: Duration(seconds: 0),
           pageBuilder: (context, animation1, animation2) => LandingPage(),
         ));
       }

       //print('undetermined user');

    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LandingPage()));
    }
    //Provider.of<AuthProvider>(context).logOut();
    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DealsPage()));
    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>UploadPassport()));
    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> StudentRegistration()));
    //print('loading screen');
  }


//  switch (authProvider.status) {
//  case Status.Uninitialized:
//  return Loading();
//  case Status.Unauthenticated:
//  return Login ();
//  //return Payment();
//  case Status.Authenticated:
//  return UploadPassport();
//  //return PaymentSuccess();
//  default:
//  return Login ();
//  }

  @override
  Widget build(BuildContext context) {

//  Future.delayed(Duration(milliseconds: 3000),(){
//
//  });
  initAuthProvider(context);
    return SafeArea(
      child: Scaffold(
//      appBar: AppBar(
//        title: Text('To Do App'),
      backgroundColor: Colors.green,
//      ),
        body: Center(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
              child:
              //new CircularProgressIndicator(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                Image.asset('assets/images/logo.png',scale: 3.0,),
                 SizedBox(height: 25,),
                 JumpingText('Loading...',style: TextStyle(fontSize: 30.0,color: Colors.white),)
              ],),
            ),
          ),
        ),
      ),
    );
  }
}
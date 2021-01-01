import 'package:flutter/material.dart';
import 'package:flutter_todo/components/green_round_button.dart';
import 'package:flutter_todo/components/curved_page_template.dart';
import 'package:flutter_todo/views/student_registration.dart';
import 'package:flutter_todo/views/corper_registration.dart';
import 'package:flutter_todo/views/others_registration.dart';

class RegistrationType extends StatefulWidget {
  static final id = 'registration_type';
  @override
  _RegistrationTypeState createState() => _RegistrationTypeState();
}

class _RegistrationTypeState extends State<RegistrationType> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xFF21BFBD),
      backgroundColor: Colors.green,
      //backgroundColor: Color(0xEEE),
//      appBar: AppBar(
//        title: const Text('Go Back',style: TextStyle(color: Colors.green),),
//        iconTheme: IconThemeData(color: Colors.green),
//        backgroundColor: Colors.white,
//
//      ),
      body: SafeArea(
        child: Container(
          child: Column(  
            mainAxisAlignment: MainAxisAlignment.end,
     children: <Widget>[

           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Row(
               children: <Widget>[
                 IconButton(
                   icon: GestureDetector(  onTap: (){
                     Navigator.pop(context);
                   },child: Icon(Icons.arrow_back_ios)),
                   color: Colors.white,
                   onPressed: () {},
                 ),
                 Text('Registration Type!!',style: TextStyle(color:Colors.white,fontSize: 30.0),),
               ],
             ),
           ),

         Expanded(
           flex: 7,
           child: Container(
             height: MediaQuery.of(context).size.height-100,
             decoration: BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)/*,topRight: Radius.circular(75.0)*/),
             ),
             child: Column(
               children: <Widget>[
                 SizedBox(height: 80.0,),
                 Center(
                   child:Container(
                       child: Text('Please select your registration type to continue')
                   ),
                 ),
                 SizedBox(height: 45.0,),

                 SizedBox(height: 20.0,),
                 GreenButton(buttonTitle: 'Students', onTap: (){
                   //Navigator.pushNamed(context, StudentRegistration.id);
                   Navigator.push(context,
                       PageRouteBuilder(
                           transitionDuration: Duration(seconds: 0),
                           pageBuilder: (context, animation1, animation2)=>StudentRegistration()
                   ));
                   //print('students clicked');
                 }),
                 SizedBox(height: 20.0,),
                 GreenButton(buttonTitle: 'Youth Corp Members', onTap: (){
                   //Navigator.pushNamed(context, routeName);
                   Navigator.push(context,
                       PageRouteBuilder(
                           transitionDuration: Duration(seconds: 0),
                           pageBuilder: (context, animation1, animation2)=>CorperRegistration()
                       ));
                   print('Youth Core Members clicked');
                 }),
                 GreenButton(buttonTitle: 'Others', onTap: (){
                   //Navigator.pushNamed(context, StudentRegistration.id);
                   Navigator.push(context,
                       PageRouteBuilder(
                           transitionDuration: Duration(seconds: 0),
                           pageBuilder: (context, animation1, animation2)=>OthersRegistration()
                       ));
                   //print('students clicked');
                 }),
                 SizedBox(height: 20.0,),
               ],
             ),
           ),
         ),
     ],

          ),
        ),
      ),);
  }


}


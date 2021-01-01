import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/providers/user.dart';
import 'package:flutter_todo/utils/constants.dart';
import 'package:flutter_todo/views/card_payment.dart';
import 'package:flutter_todo/views/loading.dart';
import 'package:flutter_todo/views/bank_payment.dart';
import 'package:flutter_todo/views/landing_page.dart';
import 'package:flutter_todo/views/auth_views/profile.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter_todo/services/studentService.dart';
import 'dart:async';
import 'package:flutter_todo/models/student.dart';
import 'package:flutter_todo/styles/styles.dart';

class Verification extends StatefulWidget {


  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {


  String barcode="";

  Student student = Student();

  bool loaded=false;


   fetchStudent(studentId)async{
     StudentService studentService = StudentService(Provider.of<AuthProvider>(context));
     Map<String,String> searchPayload={};
     searchPayload['id']=studentId.toString();
     final response= await studentService.fetchStudent(searchPayload);
     if(response['success']){
       student=response['data'];

       if(student!=null)
       loaded=true;
     }
     setState(() {
     barcode='Invalid QR Code';
     });
   }

  isNumeric(string) => num.tryParse(string) != null;

  Future scan()async{

    try{
      String barcode=await BarcodeScanner.scan();
      setState(() {
        this.barcode=barcode;
        isNumeric(barcode) ?
        fetchStudent(barcode) :
        barcode='Invalid barcode image' ;
      });
    }on PlatformException catch(e){
if(e.code==BarcodeScanner.CameraAccessDenied){
  setState(() {
    this.barcode='Camera permission not granted';
  });
}else{
  setState(() {
    this.barcode='Unknown error:$e';
  });
}
    }catch(e){
      setState(() {
        this.barcode='Unknown error: $e';
      });

    }
    }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  String _scanBarcode = 'Unknown';

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
  //  final userAvatarWidget =
//    Center(
//        child: CircleAvatar(
//          backgroundColor: Colors.green,
//          backgroundImage:  NetworkImage("$siteUrl/uploads/card_holders/card_holders$_userAvatar"),
//          radius: MediaQuery.of(context).size.width/12,
//        ));

    return  SafeArea(
      child: Scaffold(

        resizeToAvoidBottomInset: true,
        //backgroundColor: Color(0xFF21BFBD),
        //backgroundColor: Colors.green,
        //backgroundColor: Color(0xEEE),
        appBar: AppBar(
            automaticallyImplyLeading: true,
            title: const Text('Verification',style: TextStyle(color: Colors.green),),
            iconTheme: IconThemeData(color: Colors.green),
            backgroundColor: Colors.white,
            leading: IconButton(icon:Icon(Icons.arrow_back),
                onPressed:(){ Navigator.pop(context, false);

                }
            ),actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.home,
              color: Colors.green,
            ),
            onPressed: () {
              Navigator.pushReplacement(context, PageRouteBuilder(
                transitionDuration: Duration(seconds: 0),
                pageBuilder: (context, animation1, animation2) => LandingPage(),
              ));

            },
          )
        ]


        ),
        body: Container(
          //color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

//                      _userName!=null? Center(child: Text( 'Hi, $_userName',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0),)) : Text(''),
//                      SizedBox(height: 5.0,),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.all(Radius.circular(25.0))
                        ),

                        padding: EdgeInsets.all(10.0),
                        //margin: EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[

//                            _userAvatar!=null ? userAvatarWidget : Text(''),
//                            SizedBox(height: 10.0,),

                          ],),),
                      !loaded ?
                      Icon(Icons.scanner,color: Colors.green[100],size: 140,):
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 1.0, // soften the shadow
                                        spreadRadius: 1.0, //extend the shadow
                                        offset: Offset(
                                          0.0, // Move to right 10  horizontally
                                          2.0, // Move to bottom 5 Vertically
                                        ),
                                      )
                                    ]
                                ),
                                child:

                                Column(
                                  children: <Widget>[
                                    ClipOval(
                                      child: Material(
                                        color: Colors.grey[100], // button color
                                        child: InkWell(
                                          splashColor: Colors.white, // inkwell color
                                          child:  SizedBox(width: 35, height: 35, child:
                                          Icon(Icons.close,size: 20,color: Colors.red,) ),
                                          onTap: (){
                                            setState(() {
                                            loaded=!loaded;
                                          });

                                          },
                                        ),
                                      ),
                                    ),
Divider(),
//
                                   SizedBox(height: 13,),
                                   CircleAvatar(
                                     backgroundColor: Colors.green,
                                     backgroundImage:  NetworkImage("$siteUrl/uploads/card_holders/card_holders${student.passport}"),
                                     radius: 50,
                                   ),
                                    Expanded(
                                      child: ListView(children: <Widget>[
                                        StudentCard(header: 'First Name',body: student.firstName,),
                                        Divider(),
                                        StudentCard(header: 'Last Name',body: student.firstName,),
                                        Divider(),
                                        StudentCard(header: 'City',body: student.city,),
                                        Divider(),
                                        StudentCard(header: 'State',body: student.state['name'],),
                                        Divider(),
                                        student.payments.last.status=='paid'?
                                        StudentCard(header: 'Membership',body: '${student.payments.last.registered } to ${student.payments.last.expiry} ' ,): StudentCard(header: 'Membership',body: student.state['Unregistered'],),


                                      ],),
                                    )

                                ],
                                ),
                              ),
                            ),
                          ),

                      if(!loaded)
                      SizedBox(height: 15.0,),
                      if(!loaded)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          if(!loaded)
                          Text('Scan result : $barcode',
                              style: TextStyle(fontSize: 20)),
                          SizedBox(height: 10.0,),
                          if(!loaded)
                          Text('Click "Start Scanning" to begin verification'),
                      Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: ButtonTheme(
                              minWidth: double.infinity,
                              child: RaisedButton(
                                color: Colors.green,
                                textColor: Colors.white,
                                onPressed: (){
                                  loaded=false;
                                scan();
                                },
                                child:  Text('Start Scanning')  ,
                              ),
                            ),
                      ),
                        ],
                      ),
                      SizedBox(height: 10,),


                    ],
                  ),
                )
              ],
            )


        ),
      ),
    );




    //return  consumer;
  }

  @override
  void dispose() {
    //_deliveryController.dispose();
    super.dispose();
  }



}




class StudentCard extends StatelessWidget {
  final String header;
  final String body;

  StudentCard({this.header,this.body});
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 0),
      child: Container(
        margin: const EdgeInsets.all(1.0),
        width:double.infinity,
        padding: const EdgeInsets.symmetric( horizontal: 25.0,vertical: 12.0),
        decoration: BoxDecoration(
          //color: Colors.grey[200],
          //borderRadius: BorderRadius.only(topLeft: Radius.circular(45.0),bottomRight: Radius.circular(25.0) )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('$header',style: TextStyle(fontSize: 18.0,color: Colors.green),),
            Text('$body',style: Styles.lightText2),
          ],
        ),
      ),
    );
  }
}


class SkeletonPack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Skeleton(width: MediaQuery.of(context).size.width-20,),
        SizedBox(height: 20,),
        Skeleton(width: MediaQuery.of(context).size.width-20,),
        SizedBox(height: 20,),
        Skeleton(width: MediaQuery.of(context).size.width-20,),
        SizedBox(height: 20,),
        Skeleton(width: MediaQuery.of(context).size.width-20,),
        SizedBox(height: 20,),
        Skeleton(width: MediaQuery.of(context).size.width-20,),
        SizedBox(height: 20,),
        Skeleton(width: MediaQuery.of(context).size.width-20,),
        SizedBox(height: 20,),
        Skeleton(width: MediaQuery.of(context).size.width-20,),
        SizedBox(height: 20,),
        Skeleton(width: MediaQuery.of(context).size.width-20,),
        SizedBox(height: 20,),
        Skeleton(width: MediaQuery.of(context).size.width-20,),
        SizedBox(height: 20,),
        Skeleton(width: MediaQuery.of(context).size.width-20,),
        SizedBox(height: 20,),
        Skeleton(width: MediaQuery.of(context).size.width-20,),
        SizedBox(height: 20,),
        Skeleton(width: MediaQuery.of(context).size.width-20,),
        SizedBox(height: 20,),
      ],);
  }
}

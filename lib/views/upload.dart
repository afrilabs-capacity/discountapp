import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter_todo/components/curved_page_template.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/providers/user.dart';
import 'package:flutter_todo/services/uploadService.dart';
import 'package:flutter_todo/views/card_payment.dart';
import 'package:flutter_todo/views/payment_checkpoint.dart';
import 'package:flutter_todo/views/login.dart';


enum UploadStatus {Uploading,BeforeUpload,AfterUpload}

UploadStatus _status =UploadStatus.BeforeUpload;

class UploadPassport extends StatefulWidget {
  static final id = 'image_upload';



  @override
  _UploadPassportState createState() => _UploadPassportState();
}

class _UploadPassportState extends State<UploadPassport> {

  File file;

  AuthProvider authProvider;

  UploadService uploadService;

  AuthProvider _provider;

  UserProvider _userProvider;

  String _userName;

  //apiService = ApiService(authProvider);


  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }


  initAuthProvider(context)  async{
    _provider =  Provider.of<AuthProvider>(context);
    _userProvider =  Provider.of<UserProvider>(context);
    _userName= await _userProvider.getUserName();
    setState(() {});

  }

  void _choose() async {
    //_userProvider.changeString('wahala');
    file = await ImagePicker.pickImage(source: ImageSource.gallery,maxHeight: 300.0,
        maxWidth: 250.0,imageQuality: 100);
    setState(() {});
// file = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<void> _upload()  async{
    if (file == null) return;

    setState(() {
      _status= UploadStatus.Uploading;
    });

    String base64Image = base64Encode(file.readAsBytesSync());
    String fileName = file.path.split("/").last;

    uploadService = UploadService(_provider);

    var  response = await  uploadService.uploadPassport(base64Image);

    if(response['code']==401){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
    }

    if(response['success']){
      Map<String, dynamic> mappedResponse =jsonDecode(response['data']);
      await _userProvider.saveUserAvatar(mappedResponse['data']);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>PaymentCheckpoint()));
      //print("success  ${mappedResponse['data']}");

    }

    setState(() {
      _status= UploadStatus.AfterUpload;
    });

  }

  @override
  void didChangeDependencies() {
    initAuthProvider(context);
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {

    //initAuthProvider(context);

    return WillPopScope(
      onWillPop: () async =>false,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.green,
            body: Column(
             children: <Widget>[
               Expanded(
                 child:  Center(
                   child: Container(
                     color: Colors.green,
                     child: Text('Upload Passport',style: TextStyle(color: Colors.white,fontSize: 20.0),),
                     ),
                 ),
                 ),
              Expanded(
                flex: 7,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)/*,topRight: Radius.circular(75.0)*/),
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 45.0,),
                      _userName!=null? Text( 'Hi, $_userName',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0),) : Text(''),
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

                            Text("You\'re almost done!! Please upload a clear front-facing image of yourself",textAlign: TextAlign.center,style: TextStyle(  fontWeight: FontWeight.w300,color: Colors.black,),),

                          ],),),

                      SizedBox(height: 20.0,),
                      Stack(
                        children: <Widget>[
                          Center(
                            child: file == null
                                ? CircleAvatar( child: Text('PLease select image',style: TextStyle(color: Colors.black),), backgroundColor: Colors.grey[200], radius: MediaQuery.of(context).size.width/3,)
                                : new CircleAvatar(backgroundColor: Colors.green, backgroundImage: new FileImage(file), radius: MediaQuery.of(context).size.width/3,),
                          ),
                          _status!=UploadStatus.Uploading ?  Align(
                            alignment:Alignment(0.5, 1.0),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.green,
                              child: IconButton(
                                icon: Icon(
                                  Icons.add_a_photo,
                                  color: Colors.white,
                                ),
                                onPressed:  _choose,
                              ),
                            ),

                          ) : SizedBox(),

                        ],
                      ),
                      SizedBox(height: 20.0,),
                      RaisedButton(
                        onPressed: _upload,
                        color: Colors.green,
                        child:  _status==UploadStatus.BeforeUpload ?  Text('Upload Image',style: TextStyle(color: Colors.white),) :
                        _status== UploadStatus.Uploading ?  JumpingText('Uploading...',style: TextStyle( color: Colors.white, fontSize: 20.0),) :
                        _status== UploadStatus.AfterUpload ? Text('Upload Image',style: TextStyle(color: Colors.white),) : '',

                      ),
                    ],
                  ),
                ),
              )

             ],

               )

            ),
      ),
        );

    //);
  }
}





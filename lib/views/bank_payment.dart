import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_todo/components/curved_page_template.dart';
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
import 'package:flutter_todo/views/payment_success.dart';
import 'package:flutter_todo/views/login.dart';
import 'package:flutter_todo/views/landing_page.dart';



enum RequestStatus {BeforeRequest,Requesting,AfterRequest}

RequestStatus _status =RequestStatus.BeforeRequest;

class BankPayment extends StatefulWidget {
  static final id = 'payment';



  @override
  _BankPaymentState createState() => _BankPaymentState();
}

class _BankPaymentState extends State<BankPayment> {

  File file;
  AuthProvider _provider;
  UserProvider _userProvider;
  PaymentModalProvider _paymentModalProvider;
  PaymentsService _paymentService;
  String  _userName;
  String _userAvatar;
  String _userEmail;
  int _amount=200000;
  var publicKey = 'pk_test_646a85092c5d4832338d8d2e44b4f9f55d2e7bb8';
  String _reference;
  bool _delivery=false;
  ScrollController _scrollController = new ScrollController();
  ScrollController _scrollControllerSingleView = new ScrollController();
  TextEditingController _deliveryController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


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
    PaystackPlugin.initialize(
        publicKey: publicKey);
  }
/*
*Set request status to RequestStatus.Requesting, this hides modal bank information and displays only a loader
*Initialize our AuthProvider class.
*Initialize PaymentProvider class and call generateTokenProvide(), this sets a bool value in the provider, we use that to rebuild bottomSheetModal content.
*Initialize paymentService and call _paymentService.generateTransRef() to retrieve a new transaction token from server.
*/
 _generateReference() async {
   //Init providers

   var response={};

   if(_delivery && !_formKey.currentState.validate()) {
     _scrollControllerSingleView.jumpTo(_scrollControllerSingleView.position.maxScrollExtent);

     response['success']=false;
     return response;
   }
   _status = RequestStatus.Requesting;
   _provider = Provider.of<AuthProvider>(context);
   _paymentModalProvider = Provider.of<PaymentModalProvider>(context);


//Set reference to null until our API call returns with a reference
   _paymentModalProvider.reference = null;

   //API call returns new transaction reference from server, returns dart Map containing {success,data,message}
   _paymentService = PaymentsService(_provider);
    response = await _paymentService.generateTransRef('bank',amount: _amount,delivery: _deliveryController.text);
   if (response['success']) {
     Map apiResponse = jsonDecode(response['data']);
     //print("${jsonDecode(response['data'])} heyaaa");
     _status = RequestStatus.AfterRequest;
     _paymentModalProvider.reference = apiResponse['data'];
     //_paymentModalProvider.generateTokenProvide();
     print('Authenticated on payment page');
    }else{
      print('Unauthenticated on payment page');

      if(response['code']==401){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
      }
      //handle error here
      //print(response['message']);
    }

   return response;

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
    _userEmail= await _userProvider.getUserEmail();
    //print('paymant page');
    setState(() {});
  }


  bool modalWindowOpen;

  PersistentBottomSheetController bottomSheetController;

  showModalBottom(BuildContext context) async {
    modalWindowOpen=true;
    return Scaffold.of(context).showBottomSheet(
          (BuildContext context){
        return Container(
          color:Colors.transparent,
          child: Container(
            height:MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(45.0),topRight: Radius.circular(25.0),bottomRight: Radius.circular(25.0) )
              ),
              //width: MediaQuery.of(context).size.width-40,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Center(child:

                      ClipOval(
                        child: Material(
                          color: Colors.grey[100], // button color
                          child: InkWell(
                            splashColor: Colors.white, // inkwell color
                            child:  SizedBox(width: 30, height: 30, child:
                            Icon(Icons.close,size: 30,color: Colors.red,) ),
                            onTap: ()=>bottomSheetController.close(),
                          ),
                        ),
                      ),

//
                      ),),
                    Divider(),
                    SizedBox(height: 3,),

                    Expanded(
                      flex: 6,
                      child: Consumer<PaymentModalProvider>(
                        builder:(context,value,child)=> ListView(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 20.0,),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:Center(child: Text('Bank Information',style: TextStyle(color: Colors.white,fontSize: 30.0),))

                            ),
                            SizedBox(height: 12.0,),
                            BankModalCards(title: 'ACCOUNT NAME: ',body:'THE BRIDGE CONCEPT NIG LTD',),
                            SizedBox(height: 15.0,),
                            BankModalCards(title: 'Acct No: ',body:'1020854761',),
                            SizedBox(height: 15.0,),
                            BankModalCards(title: 'Bank: ',body:'UBA',),
                            SizedBox(height: 15.0,),
                            BankModalCards(title: 'Reference: ',body:value.reference!=null? value.reference: '',),
                            SizedBox(height: 5.0,),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Center(
                                child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                       // color: Colors.white,

                                    ),
                                  child: _delivery ?

                                  RichText(
                                      text: TextSpan(
                                        // set the default style for the children TextSpans
                                        //style: Theme.of(context).textTheme.body1.copyWith(fontSize: 30),
                                          children: [

                                            TextSpan(
                                                text: ' Please pay the sum of',
                                                style: TextStyle(
                                                    color: Colors.white
                                                )
                                            ),
                                            TextSpan(
                                                text: ' N2,500',
                                                style: TextStyle(
                                                    color: Colors.red
                                                )
                                            ),
                                            TextSpan(
                                                text: '(#500 for delivery) into the bank account above, after that please contact us with the reference ',
                                                style: TextStyle(
                                                    color: Colors.white
                                                )
                                            ),
                                            TextSpan(
                                                text: '${value.reference!=null? value.reference:''}',
                                                style: TextStyle(
                                                    color: Colors.red
                                                )
                                            ),
                                            TextSpan(
                                                text: ', once we confirm your payment we\'ll activate your membership status. Just so you don\'t loose your reference, We emailed you a copy as well.',
                                                style: TextStyle(
                                                    color: Colors.white
                                                )
                                            ),

                                          ]
                                      )
                                  )

//                                  Text('Please pay the sum of N2,500 (#500 for delivery) into the bank account above, after that please contact us with the reference ${value.reference!=null? value.reference:''}, once we confirm your payment we\'ll activate your membership status. Just so you don\'t loose your reference, We emailed you a copy as well. .',textAlign: TextAlign.justify,style: TextStyle(color: Colors.white),)

                                      :

                                  RichText(
                                      text: TextSpan(
                                        // set the default style for the children TextSpans
                                        //style: Theme.of(context).textTheme.body1.copyWith(fontSize: 30),
                                          children: [

                                            TextSpan(
                                                text: ' Please pay the sum of',
                                                style: TextStyle(
                                                    color: Colors.white
                                                )
                                            ),
                                            TextSpan(
                                                text: ' N2,000',
                                                style: TextStyle(
                                                    color: Colors.red
                                                )
                                            ),
                                            TextSpan(
                                                text: ' into the bank account above, after that please contact us with the reference ',
                                                style: TextStyle(
                                                    color: Colors.white
                                                )
                                            ),
                                            TextSpan(
                                                text: '${value.reference!=null? value.reference:''}',
                                                style: TextStyle(
                                                    color: Colors.red
                                                )
                                            ),
                                            TextSpan(
                                                text: ', once we confirm your payment we\'ll activate your membership status. Just so you don\'t loose your reference, We emailed you a copy as well.',
                                                style: TextStyle(
                                                    color: Colors.white
                                                )
                                            ),

                                          ]
                                      )
                                  )
                                )
                              ),
                            )
                    ]),
                      ),
                    )
                  ],
                ),
              )

          ),
        );

      },
      backgroundColor: Colors.black54,
    );
  }


  @override
  Widget build(BuildContext context) {
    //_provider.logOut();

    //final _provider1=Provider.of<AuthProvider>(context);

    print('rebuilding');
    final userAvatarWidget =
    Center(
        child: CircleAvatar(
          backgroundColor: Colors.green,
          backgroundImage:  NetworkImage("$siteUrl/uploads/card_holders/card_holders$_userAvatar"),
          radius: MediaQuery.of(context).size.width/12,
        ));

    return  SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        //backgroundColor: Color(0xFF21BFBD),
        //backgroundColor: Colors.green,
        //backgroundColor: Color(0xEEE),
        appBar: AppBar(
            automaticallyImplyLeading: true,
            title: const Text('Bank Payment',style: TextStyle(color: Colors.green),),
            iconTheme: IconThemeData(color: Colors.green),
            backgroundColor: Colors.white,
            leading: IconButton(icon:Icon(Icons.arrow_back),
              onPressed:() => Navigator.pop(context, false),
//                Navigator.push(context, PageRouteBuilder(
//                  transitionDuration: Duration(seconds: 0),
//                  pageBuilder: (context, animation1, animation2) => Loading(),
//                ))
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
        ],),

        body: Column(children: <Widget>[
          Expanded(child:  SingleChildScrollView(
            controller: _scrollControllerSingleView,
            child: ListView(
              controller: _scrollController,
              shrinkWrap: true,

              //mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30.0,),
                _userName!=null? Center(child: Text( 'Hi, $_userName',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0),)) : Text(''),
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

                      Container(child: Text("Things are looking great!! To enjoy discounts from all our esteemed partners, you need your very own discount card. At N2000 your discount card is valid for 1 year.",textAlign: TextAlign.justify,style: TextStyle(  fontWeight: FontWeight.w400,color: Colors.black,),)),


                    ],),),

                Center(
                  child: Text('Pay',style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0
                  )),
                ),
                Center(
                  child: RichText(
                      text: TextSpan(
                        // set the default style for the children TextSpans
                        //style: Theme.of(context).textTheme.body1.copyWith(fontSize: 30),
                          children: [

                            TextSpan(
                                text: ' '
                            ),
                            TextSpan(
                                text: ' '
                            ),
                            TextSpan(
                                text: 'N',
                                style: TextStyle(
                                    color: Colors.green
                                )
                            ),
                            TextSpan(
                                text: _delivery ?  '2,500' : '2,000',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 50.0
                                )
                            ),

                          ]
                      )
                  ),
                ),
                Center(
                  child: Text('via',style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0
                  )),
                ),

                SizedBox(height: 20.0,),
                Builder(builder: (context)=> Container(
                    padding: EdgeInsets.symmetric(vertical: 4,horizontal: 15),
                    child: Center(
                      child:  ButtonTheme(
                        minWidth:double.infinity,
                        child:  FlatButton(
                          color: Colors.green,
                          textColor: Colors.white,
                          onPressed: ()async {
                            final genRef = await _generateReference();
                            if (genRef['success'])
                              bottomSheetController = await showModalBottom(context);
                            //showModalBottomSheet( context: context,builder:(context)=> BankInfoModal(delivery: _delivery,));},
                          },
                          child:  Text('Generate Payment Reference')  ,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 15.0,),
                Padding(
                  padding: const EdgeInsets.symmetric( horizontal: 30.0),
                  child: Row(
                      children: <Widget>[
                        Expanded(

                            child: Divider()
                        ),

                        Text("Delivery"),

                        Expanded(
                            child: Divider()
                        ),
                      ]
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: 200,
                    child: CheckboxListTile(
                      activeColor: Colors.green,
                      title: const Text('Delivery'),
                      value: _delivery,
                      onChanged: (bool value) {
                        setState(() {
                          _delivery=!_delivery;
                          _delivery ? _scrollControllerSingleView.jumpTo(_scrollControllerSingleView.position.maxScrollExtent) : _scrollControllerSingleView.jumpTo(_scrollControllerSingleView.position.minScrollExtent);   });
                        _delivery ? _amount=250000 : _amount=200000;

                      },
                      //secondary: const Icon(Icons.hourglass_empty),
                    ),
                  ),
                ),

                _delivery ?
                Center(
                  child: SizedBox(
                    width: 300,
                    child: Form(
                      autovalidate:false,
                      key: _formKey,
                      child: TextFormField(
                        controller: _deliveryController,
                        decoration: Styles.flatFormFields.copyWith( filled: true,fillColor: Colors.grey[200], labelText: 'Where do you want your card delivered?',focusColor: Colors.pink,),
                        validator: (value) {
                          //email = value.trim();
                          return Validate.requiredField(value,'Delivery location required');
                        },
                      ),
                    ),
                  ),
                ) : Text(''),
                SizedBox(height: 50.0,)
              ],
            ),
          ),)
        ],),
      ),
    );
    //,);
    //);


    //return  consumer;
  }

  @override
  void dispose() {
    _deliveryController.dispose();
    super.dispose();
  }



}



//class BankInfoModal extends StatefulWidget {
//  BankInfoModal(this._reference);
//  final _reference;
//  @override
//  _BankInfoModalState createState() => _BankInfoModalState();
//}

//class BankInfoModal extends StatelessWidget {
//
//  final bool delivery;
//  BankInfoModal({this.delivery});
//
//  @override
//  Widget build(BuildContext context) {
//
//    //print('inside modal');
//
//  }
//}

class BankModalCards extends StatelessWidget {
  const BankModalCards({this.title,this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
          borderRadius: BorderRadius.only(topLeft: Radius.circular(45.0),bottomRight: Radius.circular(35.0) )

      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8.0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 30.0,),
            Text(title,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green),),
            Text(body,style: TextStyle(color: Colors.black))

          ],

        ),
      ),
    );
  }
}




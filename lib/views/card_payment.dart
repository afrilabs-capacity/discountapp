import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_todo/components/curved_page_template.dart';
import 'package:flutter_todo/views/admin/admin_membership.dart';
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

class CardPayment extends StatefulWidget {
  static final id = 'payment';



  @override
  _CardPaymentState createState() => _CardPaymentState();
}

class _CardPaymentState extends State<CardPayment> {

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
  void _generateReference() async {

    //Init providers
      _status =RequestStatus.Requesting;
    _provider=Provider.of<AuthProvider>(context);
      _paymentModalProvider=Provider.of< PaymentModalProvider>(context);


//Set reference to null until our API call returns with a reference
      _paymentModalProvider.reference=null;

   //API call returns new transaction reference from server, returns dart Map containing {success,data,message}
    _paymentService=PaymentsService(_provider);
    var response = await _paymentService.generateTransRef('bank');
     if(response['success']){
       Map apiResponse=jsonDecode(response['data']);
       //print("${jsonDecode(response['data'])} heyaaa");
       _status =RequestStatus.AfterRequest;
       _paymentModalProvider.reference=apiResponse['data'];
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

  }


  void ChargeCard()async {
    _provider=Provider.of<AuthProvider>(context);
    _paymentService=PaymentsService(_provider);
    //_provider.logOut();
    if(_delivery && !_formKey.currentState.validate()) {
      _scrollControllerSingleView.jumpTo(_scrollControllerSingleView.position.maxScrollExtent);

      return;
    }


    var apiResponse = await _paymentService.generateTransRef('card');
    if(apiResponse['success']) {
      Map mappedResponse=jsonDecode(apiResponse['data']);
      Charge charge = Charge()
        ..amount = _amount
        ..reference = mappedResponse['data']
      // or ..accessCode = _getAccessCodeFrmInitialization()
        ..email = _userEmail;
      CheckoutResponse response = await PaystackPlugin.checkout(
        context,
        method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
        charge: charge,
      );

      var apiResponseCardVerify = await _paymentService.verifyTransaction('card',response.reference,_deliveryController.text );
      if(apiResponseCardVerify['success']){
        print(apiResponseCardVerify['data']);
        await _userProvider.savePayment();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
            AdminMembership(student:apiResponseCardVerify['data'] ,routeIntent: 'profile',)));

      }

      //print(apiResponseCardVerify['data']);

    }else{
      if(apiResponse['code']==401){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
      }
      //handle error
    }
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
            title: const Text('Card Payment',style: TextStyle(color: Colors.green),),
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
        ]),

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
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4,horizontal: 15),
                    child: Center(
                      child:  ButtonTheme(
                        minWidth:double.infinity,
                        child:  FlatButton(
                          color: Colors.green,
                          textColor: Colors.white,
                          onPressed: (){ChargeCard();},
                          child:  Text('Pay Now')  ,
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

class BankInfoModal extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    print('inside modal');
    return Consumer<PaymentModalProvider>(
      builder:(context, value, child)=> Container(
          color: Color(0xff757575),
      child: _status==RequestStatus.Requesting ?
      Container( decoration:BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(topRight:Radius.circular(20.0),topLeft:Radius.circular(20.0))
      ),child: Center(child: Column( crossAxisAlignment: CrossAxisAlignment.center,  children: <Widget>[

      Center(child: JumpingText('Generating payment reference...',style: TextStyle(fontSize: 20.0),)) ] )) )
          :
      SizedBox(
        height: MediaQuery.of(context).size.height-30,
        child: Container(
        decoration:BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topRight:Radius.circular(20.0),topLeft:Radius.circular(20.0))
        ),
        height: MediaQuery.of(context).size.height/2,
        child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(

        children: <Widget>[
        SizedBox(height: 20.0,),
        Padding(
        padding: const EdgeInsets.all(8.0),

        child:Text('Bank Information',style: TextStyle(color: Colors.black,fontSize: 30.0),)

        ),
        SizedBox(height: 12.0,),
          BankModalCards(title: 'ACCOUNT NAME: ',body:'BRIDGE CONCEPT NIG LTD',),
          SizedBox(height: 15.0,),
          BankModalCards(title: 'Acct No: ',body:'1020854761',),
          SizedBox(height: 15.0,),
          BankModalCards(title: 'Bank: ',body:'UBA',),
          SizedBox(height: 15.0,),
          BankModalCards(title: 'Reference: ',body:value.reference!=null? value.reference: '',),
          SizedBox(height: 5.0,),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center( child: Text('We also emailed you a copy of your transaction reference.',textAlign: TextAlign.justify,)),
          )

        ],
        ),
        ),
        ),
      ), ),
    );
  }
}

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
    borderRadius: BorderRadius.circular(20.0),

    ),
    child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
    SizedBox(width: 30.0,),Text(title,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green),), Flexible(child: Text(body,style: TextStyle(color: Colors.black)))

    ],

    ),
    ),
    );
  }
}




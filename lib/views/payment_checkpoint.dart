import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/providers/user.dart';
import 'package:flutter_todo/utils/constants.dart';
import 'package:flutter_todo/views/card_payment.dart';
import 'package:flutter_todo/views/loading.dart';
import 'package:flutter_todo/views/bank_payment.dart';
import 'package:flutter_todo/views/landing_page.dart';
import 'package:flutter_todo/views/auth_views/profile.dart';

class PaymentCheckpoint extends StatefulWidget {

  String routeIntent;

  PaymentCheckpoint({this.routeIntent});
  @override
  _PaymentCheckpointState createState() => _PaymentCheckpointState();
}

class _PaymentCheckpointState extends State<PaymentCheckpoint> {

  UserProvider _userProvider;
  String  _userName;
  String _userAvatar;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    init(context);
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
        title: const Text('Payment Options',style: TextStyle(color: Colors.green),),
        iconTheme: IconThemeData(color: Colors.green),
        backgroundColor: Colors.white,
          leading: IconButton(icon:Icon(Icons.arrow_back),
            onPressed:(){ //Navigator.pop(context, false),


              if(widget.routeIntent==null)
          Navigator.pushReplacement(context, PageRouteBuilder(
        transitionDuration: Duration(seconds: 0),
        pageBuilder: (context, animation1, animation2) => Loading(),
      ));

            if(widget.routeIntent=='profile')
    Navigator.pushReplacement(context, PageRouteBuilder(
  transitionDuration: Duration(seconds: 0),
  pageBuilder: (context, animation1, animation2) => Profile(),
));
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
                                      text: '2,000',
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
                      SizedBox(height: 15.0,),

                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                              color: Colors.green,
                              textColor: Colors.white,
                              onPressed: (){

                                Navigator.push(context, PageRouteBuilder(
                                  transitionDuration: Duration(seconds: 0),
                                  pageBuilder: (context, animation1, animation2) => CardPayment(),
                                ));
                              },
                              child:  Text('Card')  ,
                            ),
                            SizedBox(width: 10.0,),
                            FlatButton(
                              color: Colors.green,
                              textColor: Colors.white,
                              onPressed: (){
                              Navigator.push(context, PageRouteBuilder(
                                transitionDuration: Duration(seconds: 0),
                                pageBuilder: (context, animation1, animation2) => BankPayment(),
                              ));


                              },
                              child:  Text('Bank')  ,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Center(child: Text('You have no active subscription',style: TextStyle(color: Colors.red),),),

                      SizedBox(height: 50.0,)
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



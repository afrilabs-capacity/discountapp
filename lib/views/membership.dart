import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/models/user.dart';
import 'package:flutter_todo/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/providers/user.dart';
import 'package:flutter_todo/providers/student.dart';
import 'package:flutter_todo/models/payment.dart';
import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/views/landing_page.dart';
import 'package:flutter_todo/styles/styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_todo/views/payment_checkpoint.dart';
import 'package:flutter_todo/models/payment.dart';
import 'package:intl/intl.dart';

class Membership extends StatelessWidget {

  StudentProvider studentProvider;
  AuthProvider _provider;
  UserProvider userProvider;

  final Payment payment;

  Membership({this.payment});

  @override
  Widget build(BuildContext context) {
    //print('rebuilding');
    _provider =  Provider.of<AuthProvider>(context,listen: false);
    studentProvider =  Provider.of<StudentProvider>(context,listen: false);
    userProvider =  Provider.of<UserProvider>(context,listen: false);
    //studentProvider.fetchUserById(_provider, userProvider.id);

    return  Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            MyNavigation(),
            MyAvatar(),
            Expanded(
              flex: 6,
              child:Consumer<UserProvider>(
                builder:(context,data,child)=> Column(children: <Widget>[
                  data.userAuthenticated.isNotEmpty ?
                  //data.userAuthenticated['account_type']==null ? UnauthenticatedUsersMenu():
                  //data.userAuthenticated.length > 0 :
                  data.userAuthenticated['account_type']=='student' ? StudentMembershipView(payment: payment,) : SizedBox():SizedBox(),

                ],),
              ),
            ),



          ],
        ),
      ),
    );




  }





}





class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Skeleton(width: MediaQuery.of(context).size.width-20,),
        SizedBox(height: 30,),
        Skeleton(width: MediaQuery.of(context).size.width-30,),
        SizedBox(height: 30,),
        Skeleton(width: MediaQuery.of(context).size.width-40,),
        SizedBox(height: 30,),
        Skeleton(width: MediaQuery.of(context).size.width-50,),
        SizedBox(height: 30,),
        Skeleton(width: MediaQuery.of(context).size.width-50,),
        SizedBox(height: 30,)





      ],
    );
  }
}


class Skeleton extends StatefulWidget {
  final double height;
  final double width;

  Skeleton({Key key, this.height = 20, this.width = 200 }) : super(key: key);

  createState() => SkeletonState();
}

class SkeletonState extends State<Skeleton> with TickerProviderStateMixin {
  AnimationController _controller;

  Animation gradientPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 1500), vsync: this);

    gradientPosition = Tween<double>(
      begin: -3,
      end: 10,
    ).animate(
      CurvedAnimation(
          parent: _controller,
          curve: Curves.linear
      ),
    )..addListener(() {
      setState(() {});

    });


  }

  @override
  void dispose() {

    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.repeat();
    return AnimatedSize(
      curve: Curves.fastOutSlowIn,
      child: Container(
        width:  widget.width,
        height: widget.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment(gradientPosition.value, 0),
                end: Alignment(-1, 0),
                colors: [Colors.white, Colors.grey[300], Colors.white]
            )
        ),
      ),vsync: this, duration: new Duration(seconds: 2),
    );
  }
}


class MyNavigation extends StatefulWidget {
  @override
  _MyNavigationState createState() => _MyNavigationState();
}

class _MyNavigationState extends State<MyNavigation> {



  @override
  Widget build(BuildContext context) {
    return  Expanded(
      flex: 1,
      child:  Container(
        color: Colors.green,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: GestureDetector(  onTap: (){
                    Navigator.pop(context);
                  },child: Icon(Icons.arrow_back_ios)),
                  color: Colors.white,
                  onPressed: () {},
                ),

                Text('Membership',style: TextStyle(color:Colors.white,fontSize: 25.0),),
                Text('',style: TextStyle(color:Colors.white,fontSize: 30.0),),
                Text('',style: TextStyle(color:Colors.white,fontSize: 30.0),),

              ],
            )
        ),
      ),
    );
  }
}



class MyAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Expanded(
      flex: 2,
      child: Consumer<UserProvider>(
        builder:(context,data,child)=>
            Container(
              width: double.infinity,
              color: Colors.green,
              child: Stack(
                children: <Widget>[
                  Column(children: <Widget>[
                    Expanded(child: Container(color: Colors.green,),),
                    Expanded(child: Container( color: Colors.grey[200],),),
                    //Text('$siteUrl/uploads/card_holders/card_holders${data.avatar}')
                  ],),

                  Align(
                      alignment:Alignment(0.0, 0.5),
                      child: Column(children: <Widget>[
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.green,
                          backgroundImage: data.avatar!=null ?  NetworkImage("$siteUrl/uploads/card_holders/card_holders${data.avatar}") : NetworkImage("$siteUrl/images/avatar.png") ,
                          //radius: MediaQuery.of(context).size.width/12,
                        ),
                        SizedBox(height: 10,),
                        data.name!=null ? Flexible(child: Text('Hi, ${data.name} ',style: TextStyle(fontSize: 18,color: Colors.green),)) : Text(''),
                      ],)

                  ),
                ],
              ),),
      ),
    );
  }
}


class StudentMembershipView extends StatelessWidget {

  final Payment payment;

  final formatCurrency = new NumberFormat.currency(symbol: 'N');

  StudentMembershipView({this.payment});

  @override
  Widget build(BuildContext context) {
    return  Expanded(
      flex: 6,
      child: Container(
        width: double.infinity,
        color:Colors.grey[200],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10,),
 Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:  ListView(
                    children: <Widget>[
                      Row(crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              PaymentCard(header:'Membership Status' ,body:'${payment.status}' ,),
                              SizedBox(height: 5,),
                              PaymentCard(header:'Payment Method' ,body:'${payment.type}' ,),
                              SizedBox(height: 5,),
                              PaymentCard(header:'Payment Reference' ,body:'${payment.reference}' ,),
                              SizedBox(height: 5,),
                              PaymentCard(header:'Amount' ,body:'${ formatCurrency.format(payment.amount/100)}' ,),
                              SizedBox(height: 5,),
                              PaymentCard(header:'Valid From' ,body:'${payment.registered } to ${payment.expiry} ' ,)



                            ],
                          ),),


                        ],
                      ),


                    ],
                  ) ,
                ),
              ),


            Consumer<StudentProvider>(
              builder:(context,data,child)=>
              data.student==null ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Skeleton(width: MediaQuery.of(context).size.width-20,),
                  SizedBox(height: 20,),
                  Skeleton(width: MediaQuery.of(context).size.width-30,),
                  SizedBox(height: 20,),
                  Skeleton(width: MediaQuery.of(context).size.width-40,),
                  SizedBox(height: 20,),
                  Skeleton(width: MediaQuery.of(context).size.width-50,),
                  SizedBox(height: 20,),
                  Skeleton(width: MediaQuery.of(context).size.width-60,),
                  SizedBox(height: 20,),
                  Skeleton(width: MediaQuery.of(context).size.width-60,),
                  SizedBox(height: 20,),
                  Skeleton(width: MediaQuery.of(context).size.width-60,),
                  SizedBox(height: 20,),
                  Skeleton(width: MediaQuery.of(context).size.width-60,),
                  SizedBox(height: 20,),
                ],): SizedBox(),
            )


          ],
        ),),
    );
  }
}



class PaymentCard extends StatelessWidget {
  final String header;
  final String body;
  PaymentCard({this.header,this.body});
  @override
  Widget build(BuildContext context) {
    return  Container(
      width:double.infinity,
      padding: const EdgeInsets.symmetric( horizontal: 25.0,vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        //borderRadius: BorderRadius.only(topLeft: Radius.circular(45.0),bottomRight: Radius.circular(25.0) )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('$header',style: TextStyle(fontSize: 18.0,color: Colors.green),),
          Text('$body',style: Styles.lightText2),
        ],
      ),
    );
  }
}
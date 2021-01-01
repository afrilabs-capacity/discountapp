import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/models/user.dart';
import 'package:flutter_todo/utils/constants.dart';
import 'package:flutter_todo/views/auth_views/profile.dart';
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
import 'package:flutter_todo/models/student.dart';
import 'package:intl/intl.dart';


class AdminMembership extends StatefulWidget {

  final String routeIntent;
  final Student student;

  AdminMembership({this.student,this.routeIntent});


  @override
  _AdminMembershipState createState() => _AdminMembershipState();
}

class _AdminMembershipState extends State<AdminMembership> {

  StudentProvider studentProvider;
  AuthProvider _provider;
  UserProvider userProvider;



  @override
  Widget build(BuildContext context) {
    _provider =  Provider.of<AuthProvider>(context,listen: false);
    studentProvider =  Provider.of<StudentProvider>(context,listen: false);
    userProvider =  Provider.of<UserProvider>(context,listen: false);
    studentProvider.fetchUserById(_provider, widget.student.id);

    return  Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Consumer<StudentProvider>(
          builder:(context,dataStudent,child)=> Column(
            mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              MyNavigation(routeIntent: widget.routeIntent,),
              MyAvatar(),
              Expanded(
                flex: 6,
                child:Consumer<UserProvider>(
                  builder:(context,data,child)=> Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //data.userAuthenticated.isNotEmpty ? SizedBox():SizedBox()
                    data.userAuthenticated.isNotEmpty ?
                    dataStudent.student.payments.isNotEmpty?
                    dataStudent.student.payments.last.status=='paid' ?
                    StudentMembershipView():
                    ActivateMembership(authProvider:_provider ):
                    Container(
                      child:Text('No payment record found',style: TextStyle(color: Colors.black54) )):
                    SizedBox()

                  ],),
                ),
              ),



            ],
          ),
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

  final String routeIntent;

  MyNavigation({this.routeIntent});
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
                    if(widget.routeIntent=='profile'){
                      print('route intent is ${widget.routeIntent}');
                      Navigator.pushReplacement(
                          context, PageRouteBuilder(
                        transitionDuration: Duration(seconds: 0),
                        pageBuilder: (context, animation1, animation2) => Profile(),
                      ));

                    }
                    if(widget.routeIntent==null)
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
      child: Consumer<StudentProvider>(
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
                          backgroundImage: data.student!=null ?  data.student.passport!=null ?  NetworkImage("$siteUrl/uploads/card_holders/card_holders${data.student.passport}") : NetworkImage("$siteUrl/images/avatar.png"):NetworkImage("$siteUrl/images/avatar.png") ,
                          //radius: MediaQuery.of(context).size.width/12,
                        ),
                        SizedBox(height: 10,),
                        data.student!=null ? Flexible(child: Text('${data.student.cardHolderType}',style: TextStyle(fontSize: 18,color: Colors.green),)) : Text(''),
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
                        Expanded(child: Consumer<StudentProvider>(
                          builder:(context,data,child)=>  data.student!=null ?
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              PaymentCard(header:'Membership Status' ,body:'${data.student.payments.last.status}' ,),
                              SizedBox(height: 5,),
                              PaymentCard(header:'Payment Method' ,body:'${data.student.payments.last.type}' ,),
                              SizedBox(height: 5,),
                              PaymentCard(header:'Payment Reference' ,body:'${data.student.payments.last.reference}' ,),
                              SizedBox(height: 5,),
                              PaymentCard(header:'Amount' ,body:'${ formatCurrency.format(data.student.payments.last.amount/100)}' ,),
                              SizedBox(height: 5,),
                              PaymentCard(header:'Valid From' ,body:'${data.student.payments.last.registered} to ${data.student.payments.last.expiry} ' ,)


                            ],
                          ):SkeletonPack(),
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


class ActivateMembership extends StatefulWidget {

  final  AuthProvider authProvider;

  ActivateMembership({this.authProvider});
  @override
  _ActivateMembershipState createState() => _ActivateMembershipState();
}

class _ActivateMembershipState extends State<ActivateMembership> {

  final formatCurrency = new NumberFormat.currency(symbol: 'N');

  bool modalWindowOpen=false;
  Duration snackBarDurationOpen= Duration(days: 1);
  Duration snackBarDurationClose= Duration(microseconds: 1);


  showModalBottom(BuildContext context) async {
    modalWindowOpen=true;
    return Scaffold.of(context).showBottomSheet(
          (BuildContext context){
        return Center(
          child: Container(
            color: Colors.black,
            child: Container(
                height: 70,
                color: Colors.white,
                width: MediaQuery.of(context).size.width-40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: 35,),
                    Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green),)),
                    SizedBox(width: 35,),
                    Text('Activating...')
                  ],
                )

            ),
          ),
        );

      },
      backgroundColor: Colors.black54,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child:  ListView(
          children: <Widget>[
            Row(crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: Consumer<StudentProvider>(
                  builder:(context,data,child)=> data.student!=null ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      PaymentCard(header:'Membership Status' ,body:'${data.student.payments.last.status}' ,),
                      SizedBox(height: 5,),
                      PaymentCard(header:'Payment Method' ,body:'${data.student.payments.last.type}' ,),
                      SizedBox(height: 5,),
                      PaymentCard(header:'Payment Reference' ,body:'${data.student.payments.last.reference}' ,),
                      SizedBox(height: 5,),
                      data.student.payments.last.type=='bank' ?
                      PaymentCard(header:'Amount' ,body:'${ formatCurrency.format(data.student.payments.last.amount/100)}' ,):
                      PaymentCard(header:'Amount' ,body:'pending' ,),
                      SizedBox(height: 5,),
                      if(data.student.payments.last.delivery!=null)
                      PaymentCard(header:'Delivery' ,body:'${ data.student.payments.last.delivery}' ,),
                      SizedBox(height: 5,),
                      if(data.student.payments.last.type=='card')
                        PaymentCard(header:'Payment Summary:' ,body:'This is a pending payment, the amount field is pending because the Card Holder has generated a card payment reference but has not completed the transaction.' ,),


                      data.student.payments.last.type=='bank' ?
                      ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width-20,
                        height: 40,
                        buttonColor: Colors.green,
                        child: GestureDetector(
                          onTap:(){},
                          child: RaisedButton(
                            onPressed: () async {
                              PersistentBottomSheetController bottomSheetController;
                              bottomSheetController =await showModalBottom(context);
                             final response= await data.activateUserById(widget.authProvider,data.student.id,data.student.payments.last.reference);

                             if(response['success']){
                               await data.fetchUserById(widget.authProvider,data.student.id);
                               bottomSheetController.close();

                             }else{
                               final snackBar = new SnackBar(
                                   content: new Text('Problem activating Card Holder, please try again later'),
                                   //duration: snackBarDurationOpen,
                                   duration: Duration(milliseconds: 4000),
                                   backgroundColor: Colors.black);


                               Future.delayed(Duration(milliseconds: 5000),(){
                                 bottomSheetController.close();
                                 modalWindowOpen=false;
                                 Scaffold.of(context).showSnackBar(snackBar);
                                 setState(() {
                                 });
                               });
                             }






                            },
                            child: Text("Activate Account",style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ):SizedBox(),

                      if(data.student.payments.last.type=='bank')
                        PaymentCard(header:'Payment Summary:' ,body:'This is a manual transaction, the card holder has chosen bank transfer as their prefered choice. The card colder will contact us with the reference above, use it to track this transaction at any time. I the transfer is confirmed, you can go ahead and tap on the "Activate Account" above to make acrivate the user on the platform.'),
                      //PaymentCard(header:'Valid From' ,body:'${payment.registered } to ${payment.expiry} ' ,)



                    ],
                  ):SkeletonPack(),
                ),),


              ],
            ),


          ],
        ) ,
      ),
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


class SkeletonPack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
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
      ],);
  }
}



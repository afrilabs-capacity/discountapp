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
import 'package:flutter_todo/views/admin/admin_membership.dart';
import 'package:flutter_todo/models/student.dart';

class AdminSingleStudent extends StatelessWidget {


  final Student student;

  AdminSingleStudent({this.student});

  StudentProvider studentProvider;
  AuthProvider _provider;
  UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    //print('rebuilding');
    _provider =  Provider.of<AuthProvider>(context,listen: false);
    studentProvider =  Provider.of<StudentProvider>(context,listen: false);
    studentProvider.student=null;
    userProvider =  Provider.of<UserProvider>(context,listen: false);
    studentProvider.fetchUserById(_provider, student.id);
    //print('user id is ${userProvider.id}');
    //print(userProvider.id);

    return  Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            MyNavigation(student: student,),
            MyAvatar(),
            Expanded(
              flex: 6,
              child:Column(children: <Widget>[
                StudentProfileView()
              ],),
            ),
//            Expanded(
//              flex: 1,
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
////                  GestureDetector(
////                      onTap:(){
////                        Provider.of<AuthProvider>(context).logOut();
////                        Future.delayed(Duration(milliseconds: 3000),(){
////                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LandingPage()));
////                        });
////                      },
////                      //child: Icon(Icons.power_settings_new,color: Colors.red,size: 40.0,)
////                    ),
//                  //Text('Sign out')
//                ],
//              ),
//            )


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

  Student student;

  MyNavigation({this.student});
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
                Text('Profile',style: TextStyle(color:Colors.white,fontSize: 25.0),),

                Consumer<UserProvider>( builder: (context,data,child) =>
                data.userAuthenticated.isNotEmpty ?
                //data.userAuthenticated['account_type']==null ? UnauthenticatedUsersMenu():
                //data.userAuthenticated.length > 0 :

                Consumer<StudentProvider>(builder: (context,data,child)=> ClipOval(
                  child: Material(
                    color: Colors.green[600], // button color
                    child: InkWell(
                      splashColor: Colors.white, // inkwell color
                      child:  SizedBox(width: 56, height: 56, child:
                      Icon(Icons.payment,size: 30,color: Colors.white,) ),
                      onTap: ()async=>
                      Navigator.push(context, PageRouteBuilder(
                        transitionDuration: Duration(seconds: 0),
                        pageBuilder: (context, animation1, animation2) => AdminMembership(student: widget.student,),
                      ))
                      //bottomSheetController = await  showModalBottom(context,data.student.payments)

                    ),
                  ),
                ),
                ):SizedBox(),
                )

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


class StudentProfileView extends StatelessWidget {
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

            Consumer<StudentProvider>(
              builder:(context,data,child)=> Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: data.student!=null ? ListView(
                    children: <Widget>[
                      Row(crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ProfileCard(header: 'Title',body: data.student.title,),
                              SizedBox(height: 7,),
                              ProfileCard(header: 'First Name',body: data.student.firstName,),
                              SizedBox(height: 7,),
                              ProfileCard(header: 'Middle Name',body: data.student.middleName,),
                              SizedBox(height: 7,),
                              ProfileCard(header: 'Last Name',body: data.student.lastName,),
                              SizedBox(height: 7,),
                              ProfileCard(header: 'Address',body: data.student.address,),
                              SizedBox(height: 7,),
                              ProfileCard(header: 'Sex',body: data.student.sex,),
                              SizedBox(height: 7,),
                              ProfileCard(header: 'City',body: data.student.city,),
                              SizedBox(height: 7,),
                              data.student.cardHolderType=='corper' ?
                              ProfileCard(header: 'Call up Number',body: data.student.callNumberNYSC,):SizedBox(),
                              SizedBox(height: 7,),
                              data.student.cardHolderType=='student' ?
                              ProfileCard(header: 'Expected Grad. Year',body: data.student.levelExpectedGraduationYear,):SizedBox(),
                              SizedBox(height: 7,),


                            ],
                          ),),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            //mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              ProfileCard(header: 'State',body: data.student.state['name'],order: 'right',),
                              SizedBox(height: 7,),
                              ProfileCard(header: 'Date of Birth',body: data.student.dateOfBirth,order: 'right'),
                              SizedBox(height: 7,),
                              ProfileCard(header: 'ID Type',body: data.student.idType,order: 'right'),
                              SizedBox(height: 7,),
                              ProfileCard(header: 'ID Number',body: data.student.idNumber,order: 'right'),
                              SizedBox(height: 7,),
                              ProfileCard(header: 'Email',body: data.student.email,order: 'right'),
                              SizedBox(height: 7,),
                              ProfileCard(header: 'Phone',body: data.student.phone,order: 'right'),
                              SizedBox(height: 7,),
                              data.student.cardHolderType=='student' || data.student.cardHolderType=='corper' ?
                              ProfileCard(header: 'Institution / School',body: data.student.instituteSchool,order: 'right'):
                              SizedBox(height: 7,),
                                data.student.cardHolderType=='corper' ?
                                ProfileCard(header: 'PPA',body: data.student.placeOfPrimaryAssignment,order: 'right'):SizedBox(),
                              SizedBox(height: 7,),
                              data.student.cardHolderType=='student' ?
                              ProfileCard(header: 'Mtric. Number',body: data.student.matriculationExamNumber,order: 'right'):SizedBox(),
                              SizedBox(height: 7,),

                            ],
                          ),)

                        ],
                      ),


                    ],
                  ) : SizedBox(),
                ),
              ),
            ),

            Consumer<StudentProvider>(
              builder:(context,data,child)=>
              data.student==null ? Column(
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
          borderRadius: BorderRadius.only(topLeft: Radius.circular(45.0),bottomRight: Radius.circular(25.0) )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('$header',style: TextStyle(fontSize: 18.0),),
          Text('$body',style: Styles.lightText2),
        ],
      ),
    );
  }
}


class ProfileCard extends StatelessWidget {

  final String header;
  final String body;
  final String order;

ProfileCard({this.header,this.body,this.order});

@override
Widget build(BuildContext context) {
  return  Container(
    width:double.infinity,
    padding: const EdgeInsets.symmetric( horizontal: 25.0,vertical: 8.0),
    margin: EdgeInsets.all(3),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: order==null ?  BorderRadius.all(Radius.circular(20)):BorderRadius.all(Radius.circular(20))
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



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/models/user.dart';
import 'package:flutter_todo/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/providers/user.dart';
import 'package:flutter_todo/providers/student.dart';
import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/views/landing_page.dart';
import 'package:flutter_todo/styles/styles.dart';
import 'package:flutter/gestures.dart';

class CardService extends StatelessWidget {

  StudentProvider studentProvider;
  AuthProvider _provider;
  UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    //print('rebuilding');
    _provider =  Provider.of<AuthProvider>(context,listen: false);
    studentProvider =  Provider.of<StudentProvider>(context,listen: false);
    userProvider =  Provider.of<UserProvider>(context,listen: false);

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
                  data.userAuthenticated['account_type']=='student' ? StudentProfileView()  :
                  data.userAuthenticated['account_type']=='partner' ? PartnerProfileView()  :
                  data.userAuthenticated['account_type']=='admin' ? AdminProfileView()  :
                  SizedBox(): SizedBox(),

                ],),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                      onTap:(){
                        Provider.of<AuthProvider>(context).logOut();
                        Future.delayed(Duration(milliseconds: 3000),(){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LandingPage()));
                        });
                      },
                      child: Icon(Icons.power_settings_new,color: Colors.red,size: 40.0,)),
                  Text('Sign out')
                ],
              ),
            )


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


class MyNavigation extends StatelessWidget {
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
                Text('',style: TextStyle(color:Colors.white,fontSize: 30.0),),
                Consumer<UserProvider>( builder: (context,data,child) =>
                data.userAuthenticated.isNotEmpty ?
                //data.userAuthenticated['account_type']==null ? UnauthenticatedUsersMenu():
                //data.userAuthenticated.length > 0 :
                data.userAuthenticated['account_type']=='student' ?
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'My Card',
                      //style: Styles.p.copyWith(color: Colors.green[500]),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => {
                          //Navigator.pushNamed(context, RegistrationType.id),
                          print('card services')
                        },
                    ),
                  ]),
                ):SizedBox():SizedBox(),
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
                              Text('Title',style: TextStyle(fontSize: 18.0),),
                              Text('${data.student.title}',style: Styles.lightText2),
                              SizedBox(height: 7,),
                              Text('First Name',style: TextStyle(fontSize: 18.0),),
                              Text('${data.student.firstName}',style: Styles.lightText2),
                              SizedBox(height: 7,),
                              Text('Middle Name',style: TextStyle(fontSize: 18.0),),
                              Text('${data.student.middleName}',style: Styles.lightText2),
                              SizedBox(height: 7,),
                              Text('Last Name',style: TextStyle(fontSize: 18.0),),
                              Text('${data.student.lastName}',style: Styles.lightText2),
                              SizedBox(height: 7,),
                              Text('Address',style: TextStyle(fontSize: 18.0),),
                              Text('${data.student.address}',style: Styles.lightText2),
                              SizedBox(height: 7,),
                              Text('Sex',style: TextStyle(fontSize: 18.0),),
                              Text('${data.student.sex}',style: Styles.lightText2),
                              SizedBox(height: 7,),
                              Text('City',style: TextStyle(fontSize: 18.0),),
                              Text('${data.student.city}',style: Styles.lightText2),
                              SizedBox(height: 7,),

                            ],
                          ),),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            //mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text('Sate',style: TextStyle(fontSize: 18.0),),
                              Text('${data.student.state['name']}',style: Styles.lightText2),
                              SizedBox(height: 7,),
                              Text('Date of Birth',style: TextStyle(fontSize: 18.0),),
                              Text('${data.student.dateOfBirth}',style: Styles.lightText2),
                              SizedBox(height: 7,),
                              Text('ID Type',style: TextStyle(fontSize: 18.0),),
                              Text('${data.student.idType}',style: Styles.lightText2),
                              SizedBox(height: 7,),
                              Text('ID Number',style: TextStyle(fontSize: 18.0),),
                              Text('${data.student.idNumber}',style: Styles.lightText2),
                              SizedBox(height: 7,),
                              Text('Email',style: TextStyle(fontSize: 18.0),),
                              Text('${data.student.email}',style: Styles.lightText2),
                              SizedBox(height: 7,),
                              Text('Phone',style: TextStyle(fontSize: 18.0),),
                              Text('${data.student.phone}',style: Styles.lightText2),
                              SizedBox(height: 7,),
                              Text('Institution / School',style: TextStyle(fontSize: 18.0),),
                              Text('${data.student.instituteSchool}',style: Styles.lightText2),
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


class AdminProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Expanded(child: Container(color: Colors.grey[200],child:
    Center(
      child: GestureDetector(
          onTap: (){
            Provider.of<AuthProvider>(context).logOut();
            Future.delayed(Duration(milliseconds: 3000),(){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LandingPage()));
            });

          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.settings,color: Colors.grey[300],size: 200,)
            ],
          )
      ),
    )
      ,),);
  }
}

class PartnerProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(),);
  }
}

import 'dart:convert';
import 'dart:math';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_todo/views/admin/admin_student_menu.dart';
import 'package:flutter_todo/views/chat_rooms.dart';
import 'package:flutter_todo/views/deals_page.dart';
import 'package:flutter_todo/views/faq.dart';
import 'package:flutter_todo/views/login.dart';
import 'package:flutter_todo/views/registration_type.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/providers/user.dart';
import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/providers/deal.dart';
import 'package:flutter_todo/utils/constants.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_todo/models/carousel.dart';
import 'package:flutter_todo/views/admin/admin_partner_menu.dart';
import 'package:flutter_todo/views/admin/admin_card_holders.dart';
import 'package:flutter_todo/styles/styles.dart';
import 'package:flutter_todo/views/about.dart';
import 'package:flutter_todo/views/auth_views/profile.dart';
import 'package:flutter_todo/views/message_page.dart';
import 'package:flutter_todo/views/album_page.dart';
import 'package:flutter_todo/views/admin/admin_single_partner.dart';
import 'package:flutter_todo/views/verification.dart';
import 'package:flutter_todo/components/skeleton.dart' as sk;
import 'package:flutter_todo/models/student.dart';

class LandingPage extends StatefulWidget {
  static final id = 'payment_success';


  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  bool captionUp=false;
  String caption;
  UserProvider userProvider;
  AuthProvider provider;
  DealProvider dealProvider;
  Timer timer;
  ScrollController _scrollController = new ScrollController();
  //ActiveMenu activeMenu=ActiveMenu.UnauthenticatedUsersMenu;

  List <Carousel> imageList =[
    Carousel(caption: "National Association of Nigerian Students(NANS) National Executives during the Grand Unveiling of Naija Green Card" ,imageUrl:"$siteUrl/gallery/n3.jpg" ),
    Carousel(caption: "Former Vice President; His Excellency Alhaji Atiku Abubakar, endorses Naija Green Card" ,imageUrl:"$siteUrl/gallery/n5.jpg" ),
    Carousel(caption: "Naija Green Card Initiator (Congressman Bimbo Daramola) Addressing Corps Members during One of his visit to the Nysc Orientations Camp" ,imageUrl:"$siteUrl/gallery/n7.jpg" ),
//    Carousel(caption: "His Imperial majesty Oba   Enitan Adeyeye Ogunwusi Ooni of Ife endorses Naija Green Card" ,imageUrl:"$siteUrl/gallery/n3.jpg" )

  ];



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
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      //_scrollController.animateTo(0.5, duration: Duration(milliseconds: 3000), curve: null);
      //print('scrolling slider');
      if(mounted)
      setState(() {});
    });

  }




  init(context)  async{
    provider =  Provider.of<AuthProvider>(context,listen: false);
    dealProvider =  Provider.of<DealProvider>(context,listen: false);
    userProvider = Provider.of<UserProvider>(context,listen: false);
    dealProvider.initPartners(provider);
    userProvider.userData();
    setState(() {});
    print('in landing init');
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    init(context);
  }



  @override
  Widget build(BuildContext context) {
    //print('rebuilding')
    //print(Provider.of<UserProvider>(context).userAuthenticated);
    return  SafeArea(
      child: Scaffold(
        backgroundColor: Colors.green[600],
        resizeToAvoidBottomInset: false,
          body: Container(
            color: Colors.green[600],
            //decoration: Styles.gradientFill1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: ClipPath(
                    clipper: CurvedBottomClipper(),
                    child: Container(
                      color: Colors.green[600],
                      height: 250.0,
                      child: Stack(
                        children: <Widget>[
                          CarouselSlider(
                            height: 400.0,
                            viewportFraction: 10.0,
                            autoPlay: true,
                            enableInfiniteScroll: true,
                            onPageChanged: (value){
                              setState(() {
                                captionUp=true;
                              });

                              Future.delayed(Duration(milliseconds: 200),(){

                                setState(() {
                                  captionUp=false;
                                });
                              });

                            },
                            //enlargeCenterPage: true,
                            autoPlayInterval: Duration(seconds: 5),
                            autoPlayAnimationDuration: Duration(milliseconds: 300),
                            items: imageList.map((Carousel i) {
                              return Builder(
                                builder: (BuildContext context) {
                                   caption=i.caption;
                                  return Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(i.imageUrl),
                                            fit: BoxFit.cover,
                                          ),
                                        ),)
                                  );

                                },

                              );

                            }).toList(),

                          ),
                          Align(
                            alignment:Alignment(0.0, 1.0),
                            child: AnimatedContainer(
                              padding: EdgeInsets.all(10.0),
                              duration: Duration(milliseconds: 250), // Animation speed
                              transform: Transform.translate(
                                offset: Offset(0, captionUp == true ? 90 : 10), // Change -100 for the y offset
                              ).transform,
                              child: Container(
                                //padding:EdgeInsets.all(6.0),
                                width: 280,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                        colors: [Colors.black45, Colors.black45]),
                                    //color: Colors.green,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight:Radius.circular(10) )
                                ),
                                padding: EdgeInsets.symmetric(vertical: 22.0,horizontal: 15.0),
                                child: Text(caption!=null? caption : '',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 3,),
                Center(child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Divider()
                      ),

                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text("PARTNERS",style: TextStyle(fontSize: 15.0,color: Colors.white),),),
                      Expanded(
                          child: Divider()
                      ),
                    ]
                ),),
                SizedBox(height: 3,),
                Expanded(
                  flex: 3,
child: Padding(
  padding: const EdgeInsets.only(left: 15.0,bottom: 5.0,right: 15.0),
  child:   Column(

    children: <Widget>[
      PartnerList(provider,_scrollController)

    ],

  ),
),
       ),
                SizedBox(height: 3,),
                Center(child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Divider()
                    ),

                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text("MENU",style: TextStyle(fontSize: 15.0,color: Colors.white),),
                    ),
                    Expanded(
                        child: Divider()
                    ),
                  ]
              ),),
                SizedBox(height: 3,),
        Consumer<UserProvider>(
          builder:(context,data,child) => Column(children: <Widget>[

            data.userAuthenticated.isNotEmpty ?
            //data.userAuthenticated['account_type']==null ? UnauthenticatedUsersMenu():
            //data.userAuthenticated.length > 0 :
            data.userAuthenticated['account_type']=='student' ? AuthenticatedStudentMenu()  :
            data.userAuthenticated['account_type']=='partner' ? AuthenticatedPartnerMenu()  :
            data.userAuthenticated['account_type']=='admin' ? AuthenticatedAdminMenu()  :
            UnauthenticatedUsersMenu(): UnauthenticatedUsersMenu(),
          ],),
        )

             //SizedBox(height: 2.0,),
             // UnauthenticatedUsersMenu(),
                // AuthenticatedStudentMenu(),
               // AuthenticatedPartnerMenu()


              ],
            ),
          ),


      ),
    );

  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }



}


class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // I've taken approximate height of curved part of view
    // Change it if you have exact spec for it
    final roundingHeight = size.height * 2 / 10;
    // this is top part of path, rectangle without any rounding
    final filledRectangle = Rect.fromLTRB(0, 0, size.width, size.height - roundingHeight);
    // this is rectangle that will be used to draw arc
    // arc is drawn from center of this rectangle, so it's height has to be twice roundingHeight
    // also I made it to go 5 units out of screen on left and right, so curve will have some incline there
    final roundingRectangle = Rect.fromLTRB(
        -5, size.height - roundingHeight * 2, size.width + 5, size.height);
    final path = Path();
    path.addRect(filledRectangle);
    // so as I wrote before: arc is drawn from center of roundingRectangle
    // 2nd and 3rd arguments are angles from center to arc start and end points
    // 4th argument is set to true to move path to rectangle center, so we don't have to move it manually
    path.arcTo(roundingRectangle, pi, -pi, true);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // returning fixed 'true' value here for simplicity, it's not the part of actual question, please read docs if you want to dig into it
    // basically that means that clipping will be redrawn on any changes
    return true;
  }
}





class UnauthenticatedUsersMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0,bottom: 15.0,right: 15.0),
      child: Container(
        decoration: BoxDecoration(
            //color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            SizedBox(height: 5,),
            SizedBox(
              //width: 250,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(width: 5,),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        //Navigator.push(context,MaterialPageRoute(builder: (context)=>DealsPage()));
                        Navigator.push(context, PageRouteBuilder(
                          transitionDuration: Duration(seconds: 0),
                          pageBuilder: (context, animation1, animation2) => DealsPage(),
                        ));
                      },
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            color: Styles.landingPageBackgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                        ),
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.shop,color:Styles.landingPageMenuIconColor,size: Styles.landingPageIconSize,),
                            Text('Deals',style: Styles.textTheme2.copyWith(color: Styles.landingPageMenuIconColor),)

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          //Navigator.push(context,MaterialPageRoute(builder: (context)=>Login()));
                          Navigator.push(context, PageRouteBuilder(
                            transitionDuration: Duration(seconds: 0),
                            pageBuilder: (context, animation1, animation2) => Login(),
                          ));
                        },
                          child: Container(
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                                color: Styles.landingPageBackgroundColor,
                                borderRadius: BorderRadius.all(Radius.circular(20.0))
                            ),
                            child: Column(
                            children: <Widget>[
                              Icon(Icons.security,color: Styles.landingPageMenuIconColor,size: Styles.landingPageIconSize,),
                              Text('Sign In',style: Styles.textTheme2.copyWith(color: Styles.landingPageMenuIconColor),)

                            ],
                        ),
                          ),
                      ),
                    ),
                  SizedBox(width: 5,),
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          //Navigator.push(context,MaterialPageRoute(builder: (context)=>RegistrationType()));
                          Navigator.push(context, PageRouteBuilder(
                            transitionDuration: Duration(seconds: 0),
                            pageBuilder: (context, animation1, animation2) => RegistrationType(),
                          ));
                        },
                        child: Container(
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                              color: Styles.landingPageBackgroundColor,
                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                          ),
                          child: Column(
                            children: <Widget>[
                              Icon(Icons.person_add,color: Styles.landingPageMenuIconColor,size: Styles.landingPageIconSize,),
                              Text('Sign Up',style: Styles.textTheme2.copyWith(color: Styles.landingPageMenuIconColor),)

                            ],
                          ),
                        ),
                      ),
                    )

                ],
              ),
            ),
            SizedBox(height: 5,),
            //SizedBox(width: 250,height: 30, child: Divider()),
            SizedBox(
              //width: 250,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(width: 5,),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        //Navigator.push(context, MaterialPageRoute( builder:(context)=>About()));
                        Navigator.push(context, PageRouteBuilder(
                          transitionDuration: Duration(seconds: 0),
                          pageBuilder: (context, animation1, animation2) => About(),
                        ));
                      },
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            color: Styles.landingPageBackgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                        ),
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.more,color: Styles.landingPageMenuIconColor,size: Styles.landingPageIconSize,),
                            Text('About',style: Styles.textTheme2.copyWith(color: Styles.landingPageMenuIconColor),)

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            color: Styles.landingPageBackgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                        ),
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.new_releases,color: Styles.landingPageMenuIconColor,size: Styles.landingPageIconSize,),
                            Text('News',style: Styles.textTheme2.copyWith(color: Styles.landingPageMenuIconColor),)

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, PageRouteBuilder(
                          transitionDuration: Duration(seconds: 0),
                          pageBuilder: (context, animation1, animation2) => Album(),
                        ));
                      },
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            color: Styles.landingPageBackgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                        ),
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.camera,color: Styles.landingPageMenuIconColor,size: Styles.landingPageIconSize,),
                            Text('Events',style: Styles.textTheme2.copyWith(color: Styles.landingPageMenuIconColor),)

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                ],
              ),
            ),

            //SizedBox(width: 250,height: 30, child: Divider()),
            SizedBox(height: 5,),
            SizedBox(
              //width: 250,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(width: 5,),
//                     Expanded(
//                      child: GestureDetector(
//                        child: Container(
//                          padding: EdgeInsets.all(12.0),
//                          decoration: BoxDecoration(
//                              color: Styles.landingPageBackgroundColor,
//                              borderRadius: BorderRadius.all(Radius.circular(20.0))
//                          ),
//                          child: Column(
//                            children: <Widget>[
//                              Icon(Icons.account_circle,color: Styles.landingPageMenuIconColor,size: Styles.landingPageIconSize,),
//                              Text('Profile',style: Styles.textTheme2.copyWith(color: Styles.landingPageMenuIconColor),)
//
//                            ],
//                          ),
//                        ),
//                      ),
//                    ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, PageRouteBuilder(
                          transitionDuration: Duration(seconds: 0),
                          pageBuilder: (context, animation1, animation2) => Message(),
                        ));
                      },
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            color: Styles.landingPageBackgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                        ),
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.email,color: Styles.landingPageMenuIconColor,size: Styles.landingPageIconSize,),
                            Text('Support',style: Styles.textTheme2.copyWith(color: Styles.landingPageMenuIconColor),)

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, PageRouteBuilder(
                          transitionDuration: Duration(seconds: 0),
                          pageBuilder: (context, animation1, animation2) => FrequentlyAsked(),
                        ));
                      },
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            color: Styles.landingPageBackgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                        ),
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.chat,color: Styles.landingPageMenuIconColor,size: Styles.landingPageIconSize,),
                            Text('FAQ',style: Styles.textTheme2.copyWith(color: Styles.landingPageMenuIconColor),)

                          ],
                        ),
                      ),
                    ),
                  ),


                ],
              ),
            ),
            SizedBox(height: 5,),
          ],
        ),
      ),
    );
  }
}

class AuthenticatedAdminMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0,bottom: 15.0,right: 15.0),
      child: Container(
        decoration: BoxDecoration(
            //color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 5,),
            SizedBox(
              //width: 250,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(width: 5,),
                    Expanded(
                      child: GestureDetector(
                      onTap: (){
                        //Navigator.push(context,MaterialPageRoute(builder: (context)=>DealsPage()));
                        Navigator.push(context, PageRouteBuilder(
                          transitionDuration: Duration(seconds: 0),
                          pageBuilder: (context, animation1, animation2) => DealsPage(),
                        ));
                      },
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            color: Styles.landingPageBackgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                        ),
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.shop,color: Styles.landingPageMenuIconColor,size: Styles.landingPageIconSize,),
                            Text('Deals',style: Styles.textTheme2.copyWith(color: Styles.landingPageMenuIconColor),)

                          ],
                        ),
                      ),
                  ),
                    ),
                  SizedBox(width: 5,),

                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          //Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminCardHolders()));
                          Navigator.push(context, PageRouteBuilder(
                            transitionDuration: Duration(seconds: 0),
                            pageBuilder: (context, animation1, animation2) => AdminStudentMenu(),
                          ));
                          },
                        child: Container(
                        padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                              color: Styles.landingPageBackgroundColor,
                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                          ),
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.credit_card,color: Styles.landingPageMenuIconColor,size: Styles.landingPageIconSize,),
                            Text('Card Holders',style: Styles.textTheme2.copyWith(fontSize: 13,color: Styles.landingPageMenuIconColor),)

                          ],
                        ),
                  ),
                      ),
                    ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        //Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminPartnerMenu()));
                        Navigator.push(context, PageRouteBuilder(
                          transitionDuration: Duration(seconds: 0),
                          pageBuilder: (context, animation1, animation2) => AdminPartnerMenu(),
                        ));

                        },
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            color: Styles.landingPageBackgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                        ),
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.people,color: Styles.landingPageMenuIconColor,size: Styles.landingPageIconSize,),
                            Text('Partners',style: Styles.textTheme2.copyWith(color: Styles.landingPageMenuIconColor),)
                          ],
                        ),
                      ),
                    ),
                  )



                ],
              ),
            ),
           SizedBox(height: 5,),
            //SizedBox(width: 250,height: 30, child: Divider()),
            SizedBox(
              //width: 250,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(width: 5,),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, PageRouteBuilder(
                          transitionDuration: Duration(seconds: 0),
                          pageBuilder: (context, animation1, animation2) => Album(),
                        ));
                      },
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            color: Styles.landingPageBackgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                        ),
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.camera,color: Styles.landingPageMenuIconColor,size: Styles.landingPageIconSize,),
                            Text('Events',style: Styles.textTheme2.copyWith(color: Styles.landingPageMenuIconColor),)

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: GestureDetector(
                    onTap: (){Navigator.push(context, PageRouteBuilder(
                      transitionDuration: Duration(seconds: 0),
                      pageBuilder: (context, animation1, animation2) => Profile(),
                    ));},
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            color: Styles.landingPageBackgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                        ),
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.account_circle,color: Styles.landingPageMenuIconColor,size: Styles.landingPageIconSize,),
                            Text('Profile',style: Styles.textTheme2.copyWith(color: Styles.landingPageMenuIconColor),)

                          ],
                        ),
                      ),
                    ),
                  ),SizedBox(width: 5,),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, PageRouteBuilder(
                          transitionDuration: Duration(seconds: 0),
                          pageBuilder: (context, animation1, animation2) => Message(),
                        ));
                      },
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            color: Styles.landingPageBackgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                        ),
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.email,color: Styles.landingPageMenuIconColor,size: Styles.landingPageIconSize,),
                            Text('Support',style: Styles.textTheme2.copyWith(color: Styles.landingPageMenuIconColor),)

                          ],
                        ),
                      ),
                    ),
                  ),


                ],
              ),
            ),
            SizedBox(height: 5,),
            //SizedBox(width: 250,height: 30, child: Divider()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(width: 5,),
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                          color: Styles.landingPageBackgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(20.0))
                      ),
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.new_releases,color: Styles.landingPageMenuIconColor,size: Styles.landingPageIconSize,),
                          Text('News',style: Styles.textTheme2.copyWith(color: Styles.landingPageMenuIconColor),)
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, PageRouteBuilder(
                        transitionDuration: Duration(seconds: 0),
                        pageBuilder: (context, animation1, animation2) => ChatRoom(),
                      ));
                    },
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                          color: Styles.landingPageBackgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(20.0))
                      ),
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.chat,color: Styles.landingPageMenuIconColor,size: Styles.landingPageIconSize,),
                          Text('Chat',style: Styles.textTheme2.copyWith(color: Styles.landingPageMenuIconColor),)
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5,)




              ],
            ),
            SizedBox(height: 5,)
          ],
        ),
      ),
    );
  }
}

class AuthenticatedPartnerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0,bottom: 15.0,right: 15.0),
      child: Container(
        decoration: BoxDecoration(
            //color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        child: Column(
          children: <Widget>[
            //SizedBox(width: 250,height: 30, child: Divider()),
            SizedBox(height: 5,),
            SizedBox(
             // width: 250,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
   SizedBox(width: 5,),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                            
                          //Navigator.push(context, MaterialPageRoute( builder:(context)=>About()));
                          Navigator.push(context, PageRouteBuilder(
                            transitionDuration: Duration(seconds: 0),
                            pageBuilder: (context, animation1, animation2) => About(),
                          ));

                      },
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            color: Styles.landingPageBackgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                        ),
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.more,color: Styles.landingPageMenuIconColor,size: Styles.landingPageIconSize,),
                            Text('About',style: Styles.textTheme2.copyWith(color: Styles.landingPageMenuIconColor),)

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, PageRouteBuilder(
                          transitionDuration: Duration(seconds: 0),
                          pageBuilder: (context, animation1, animation2) => DealsPage(),
                        ));
                        //Navigator.push(context,MaterialPageRoute(builder: (context)=>DealsPage()));
                      },
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            color: Styles.landingPageBackgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                        ),
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.shop,color: Styles.landingPageMenuIconColor,size: Styles.landingPageIconSize,),
                            Text('Deals',style:Styles.textTheme2.copyWith(color: Styles.landingPageMenuIconColor),)

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, PageRouteBuilder(
                          transitionDuration: Duration(seconds: 0),
                          pageBuilder: (context, animation1, animation2) => ChatRoom(),
                        ));
                      },
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            color: Styles.landingPageBackgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                        ),
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.chat,color: Styles.landingPageMenuIconColor,size: Styles.landingPageIconSize,),
                            Text('Chat',style: Styles.textTheme2.copyWith(color: Styles.landingPageMenuIconColor),)

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,)


                ],
              ),

            ),
SizedBox(height: 5,),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(width: 5,),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, PageRouteBuilder(
                          transitionDuration: Duration(seconds: 0),
                          pageBuilder: (context, animation1, animation2) => Album(),
                        ));
                      },
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            color: Styles.landingPageBackgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                        ),
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.camera,color: Styles.landingPageMenuIconColor,size: Styles.landingPageIconSize,),
                            Text('Events',style: Styles.textTheme2.copyWith(color: Styles.landingPageMenuIconColor),)

                          ],
                        ),
                      ),
                    ),
                   ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: GestureDetector(
                        onTap: (){Navigator.push(context, PageRouteBuilder(
                          transitionDuration: Duration(seconds: 0),
                          pageBuilder: (context, animation1, animation2) => Profile(),
                        ));},
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            color: Styles.landingPageBackgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                        ),
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.account_circle,color: Styles.landingPageMenuIconColor,size: Styles.landingPageIconSize,),
                            Text('Profile',style: Styles.textTheme2.copyWith(color: Styles.landingPageMenuIconColor),)

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                   Expanded(
                     child: GestureDetector(
                       onTap: (){
                         Navigator.push(context, PageRouteBuilder(
                           transitionDuration: Duration(seconds: 0),
                           pageBuilder: (context, animation1, animation2) => Message(),
                         ));
                       },
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            color: Styles.landingPageBackgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                        ),
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.email,color: Styles.landingPageMenuIconColor,size: Styles.landingPageIconSize,),
                            Text('Support',style: Styles.textTheme2.copyWith(color: Styles.landingPageMenuIconColor),)

                          ],
                        ),
                      ),
                  ),
                   ),


                ],
              ),
            ),
            SizedBox(height: 5,),
            SizedBox(
          
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(width: 5,),
                   Expanded(
                     child: GestureDetector( 
                       child: Container(
                         padding: EdgeInsets.all(12.0),
                         decoration: BoxDecoration(
                             color: Styles.landingPageBackgroundColor,
                             borderRadius: BorderRadius.all(Radius.circular(20.0))
                         ),
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.new_releases,color: Styles.landingPageMenuIconColor,size: Styles.landingPageIconSize,),
                            Text('News',style: Styles.textTheme2.copyWith(color: Styles.landingPageMenuIconColor),)
                          ],
                        ),
                  ),
                     ),
                   ),
                  SizedBox(width: 5,),
                     Expanded(
                       child: GestureDetector(
                         onTap: (){
                           Navigator.push(context, PageRouteBuilder(
                             transitionDuration: Duration(seconds: 0),
                             pageBuilder: (context, animation1, animation2) => Verification(),
                           ));
                         },
                       child: Container(
                         padding: EdgeInsets.all(12.0),
                         decoration: BoxDecoration(
                             color: Styles.landingPageBackgroundColor,
                             borderRadius: BorderRadius.all(Radius.circular(20.0))
                         ),
                        child: Column(
                            children: <Widget>[
                            Icon(Icons.verified_user,color: Styles.landingPageMenuIconColor,size: Styles.landingPageIconSize,),
                            Text('Verification',style: Styles.textTheme2.copyWith(color: Styles.landingPageMenuIconColor),)

                          ],
                        ),
                  ),
                   ),
                     ),
                  SizedBox(width: 5,),
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(context, PageRouteBuilder(
                              transitionDuration: Duration(seconds: 0),
                              pageBuilder: (context, animation1, animation2) => FrequentlyAsked(),
                            ));

                          },
                          child: Container(
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                                color: Styles.landingPageBackgroundColor,
                                borderRadius: BorderRadius.all(Radius.circular(20.0))
                            ),
                          child: Column(
                          children: <Widget>[
                            Icon(Icons.question_answer,color: Styles.landingPageMenuIconColor,size: Styles.landingPageIconSize,),
                            Text('FAQ',style: Styles.textTheme2.copyWith(color: Styles.landingPageMenuIconColor),)
                          ],
                  ),
                    ),
                        ),
                      ),
                  SizedBox(width: 5,),

                ],
              ),

            ),
            SizedBox(height: 5,)
          ],
        ),
      ),
    );
  }
}

class AuthenticatedStudentMenu extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0,bottom: 15.0,right: 15.0),
      child: Container(
        decoration: BoxDecoration(
          //color: Colors.green,
          borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        child: Column(
          children: <Widget>[
            SizedBox(width: 30,height: 5,),
            SizedBox(
              width: 300,
//              child: Row(
//                  children: <Widget>[
//                    Expanded(
//                        child: Divider(color: Colors.white,)
//                    ),
//
//                    Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: Text("MENU",style: TextStyle(color: Colors.white,fontSize: 20.0),),
//                    ),
//
//                    Expanded(
//                        child: Divider(color: Colors.white,)
//                    ),
//                  ]
//              ),
            ),
            //SizedBox(width: 30,height: 20,),
            SizedBox(
             // width: 250,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(width: 5.0,),

                  Expanded(
                    child: GestureDetector(
                      onTap:()=>
                          //Navigator.push(context,MaterialPageRoute(builder: (context)=>About())),
                      Navigator.push(context, PageRouteBuilder(
                        transitionDuration: Duration(seconds: 0),
                        pageBuilder: (context, animation1, animation2) => About(),
                      )),
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        //decoration: Styles.boxDecoration1,
                        decoration: BoxDecoration(
                            color: Styles.landingPageBackgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                        ),
                        child: Column(
                          children: <Widget>[
                            //Icon(Icons.more,color: Styles.myColor7,size: Styles.landingPageIconSize,),
                            //Text('About',style: Styles.textTheme2,)
                            Icon(Icons.more,color: Styles.landingPageMenuIconColor,size: Styles.landingPageIconSize,),
                            Text('About',style: Styles.textTheme2.copyWith(color:Styles.landingPageMenuIconColor ),)

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5.0,),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        //Navigator.push(context,MaterialPageRoute(builder: (context)=>DealsPage()));
                        Navigator.push(context, PageRouteBuilder(
                          transitionDuration: Duration(seconds: 0),
                          pageBuilder: (context, animation1, animation2) => DealsPage(),
                        ));
                      } ,
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            color: Styles.landingPageBackgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                        ),
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.shop,color: Styles.landingPageMenuIconColor,size:Styles.landingPageIconSize,),
                            Text('Deals',style: Styles.textTheme2.copyWith(color: Styles.landingPageMenuIconColor),)

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5.0,),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, PageRouteBuilder(
                          transitionDuration: Duration(seconds: 0),
                          pageBuilder: (context, animation1, animation2) => ChatRoom(),
                        ));
                      },
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            color: Styles.landingPageBackgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                        ),
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.chat,color: Styles.landingPageMenuIconColor,size: Styles.landingPageIconSize,),
                            Text('Chat',style: Styles.textTheme2.copyWith(color: Styles.landingPageMenuIconColor),)
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5.0,),



                ],
              ),
            ),
            SizedBox(height: 5.0,),
            //SizedBox(width: 250,height: 30, child: Divider()),

            SizedBox(
              //width: 250,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, PageRouteBuilder(
                          transitionDuration: Duration(seconds: 0),
                          pageBuilder: (context, animation1, animation2) => Album(),
                        ));
                      },
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            color: Styles.landingPageBackgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                        ),
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.camera,color: Styles.landingPageMenuIconColor,size: Styles.landingPageIconSize,),
                            Text('Events',style: Styles.textTheme2.copyWith(color: Styles.landingPageMenuIconColor),)

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5.0,),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){Navigator.push(context, PageRouteBuilder(
                        transitionDuration: Duration(seconds: 0),
                        pageBuilder: (context, animation1, animation2) => Profile(),
                      ));},
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            color: Styles.landingPageBackgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                        ),
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.account_circle,color: Styles.landingPageMenuIconColor,size: Styles.landingPageIconSize,),
                            Text('Profile',style: Styles.textTheme2.copyWith(color: Styles.landingPageMenuIconColor),)

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5.0,),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, PageRouteBuilder(
                          transitionDuration: Duration(seconds: 0),
                          pageBuilder: (context, animation1, animation2) => Message(),
                        ));
                      },
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            color: Styles.landingPageBackgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                        ),
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.email,color: Styles.landingPageMenuIconColor,size: Styles.landingPageIconSize,),
                            Text('Support',style: Styles.textTheme2.copyWith(color: Styles.landingPageMenuIconColor),)

                          ],
                        ),
                      ),
                    ),
                  ),


                ],
              ),
            ),
            SizedBox(height: 5.0,),
            //SizedBox(width: 250,height: 30, child: Divider()),
            SizedBox(
              //width: 250,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(width: 5.0,),

                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            color: Styles.landingPageBackgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                        ),
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.new_releases,color: Styles.landingPageMenuIconColor,size: Styles.landingPageIconSize,),
                            Text('News',style: Styles.textTheme2.copyWith(color: Styles.landingPageMenuIconColor),)

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5.0,),
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, PageRouteBuilder(
                            transitionDuration: Duration(seconds: 0),
                            pageBuilder: (context, animation1, animation2) => FrequentlyAsked(),
                          ));
                        },
                        child: Container(
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                              color: Styles.landingPageBackgroundColor,
                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                          ),
                          child: Column(
                          children: <Widget>[
                            Icon(Icons.question_answer,color: Styles.landingPageMenuIconColor,size: Styles.landingPageIconSize,),
                            Text('FAQ',style: Styles.textTheme2.copyWith(color: Styles.landingPageMenuIconColor),)

                          ],
                  ),
                        ),
                      ),
                    ),
                  SizedBox(width: 5.0,),
                  //SizedBox(width: 55.0,),


                ],
              ),

            ),
            SizedBox(height: 5.0,),

          ],
        ),
      ),
    );
  }
}




class PartnerList extends StatelessWidget {

  AuthProvider  _provider;
  ScrollController scrollController;

  PartnerList(this._provider,this.scrollController);

  @override
  Widget build(BuildContext context) {
    return Consumer<DealProvider>(
      builder: (context,data,child)=>Expanded(
          flex: 11,
          child: data.loaded ? NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!data.loadMore && scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                // _loadData();
                // start loading data
                data.loadMoreData( _provider);

              }
            },
            child: GridView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: data.partners.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:1),
              itemBuilder: (context, index) {
                return  GestureDetector(
                  onTap: ()=>
                      //Navigator.push(context,MaterialPageRoute(builder: (context) => AdminSinglePartner(partner:data.partners[index],))),
                  Navigator.push(context, PageRouteBuilder(
                    transitionDuration: Duration(seconds: 0),
                    pageBuilder: (context, animation1, animation2) => AdminSinglePartner(partner:data.partners[index],))),
                  child: Container(
                    //padding: EdgeInsets.all(0),
                    margin: EdgeInsets.all(15.0),
                    child: Container(
                      //padding: EdgeInsets.only(bottom: 25.0),
                      //margin: EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.black54,
                                blurRadius: 15.0,
                                offset: Offset(0.0, 0.4)
                            )
                          ],
                          color: Colors.white

                      ),
                      //color:Colors.grey[200],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: Stack(
                              children: <Widget>[

                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomRight:Radius.circular(25) ),
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage('$siteUrl/categories/${data.partners[index].category['id']}/${data.partners[index].categoryImage}'),
                                    ),
                                  ),
                                  child:   Align(
                                    alignment:Alignment(1.1,-1.5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(25),bottomRight:Radius.circular(25) )
                                      ),
                                      padding: EdgeInsets.symmetric(vertical: 12.0,horizontal: 5.0),
                                      child: Text('${data.partners[index].discount}% off',style: TextStyle(color: Colors.white,fontSize: 10),),
                                    ),
                                  ),
                                ),
//                                Image.network(
//                                    '$siteUrl/categories/${data.partners[index].category['id']}/${data.partners[index].categoryImage}'),

                              ],
                            ),
                          ),


                          Flexible(child: Text('${data.partners[index].nameOfBusiness}',overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14.0,color: Colors.green)),),
                          SizedBox(height: 2,),
                          Expanded(child: Center(child: Text('${data.partners[index].category['name']}',style: TextStyle(fontSize: 11.0,color: Colors.red)))),
                          Expanded(child: Text('${data.partners[index].state['name']}',style: TextStyle(fontSize: 13.0,color: Colors.black54))),
                          SizedBox(height: 2,)

                        ],
                      ),
                    ),
                  ),
                );





              },
            ),
          ) : Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('Waiting for partners.........',style: TextStyle(color: Colors.white),),
              sk.Skeleton(width: MediaQuery.of(context).size.width-20,),
              SizedBox(height: 20,),
              sk.Skeleton(width: MediaQuery.of(context).size.width-30,),
              SizedBox(height: 20,),
            ],)
      ),
    );
  }
}








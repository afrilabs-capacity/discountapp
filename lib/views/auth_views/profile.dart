import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/models/user.dart';
import 'package:flutter_todo/models/partner_album.dart';
import 'package:flutter_todo/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/providers/user.dart';
import 'package:flutter_todo/providers/student.dart';
import 'package:flutter_todo/providers/partner.dart';
import 'package:flutter_todo/models/payment.dart';
import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/views/landing_page.dart';
import 'package:flutter_todo/styles/styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_todo/views/payment_checkpoint.dart';
import 'package:flutter_todo/views/membership.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';

class Profile extends StatelessWidget {

  StudentProvider studentProvider;
  AuthProvider _provider;
  UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    //print('rebuilding')
    return  Scaffold(
      backgroundColor: Colors.green[600],
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
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                          onTap:(){
                            Provider.of<AuthProvider>(context).logOut();
                            Future.delayed(Duration(milliseconds: 3000),(){
                              //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LandingPage()));

                              Navigator.push(context,
                                PageRouteBuilder(
                                  transitionDuration: Duration(seconds: 0),
                                  pageBuilder: (context, animation1, animation2) => LandingPage(),
                                )
                                //MaterialPageRoute( builder: (context)=> Loading() )
                                ,);
                            });
              },
                          child: Icon(Icons.power_settings_new,color: Colors.red,size: 40.0,)),
                      Text('Sign out')
                    ],
                  ),
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


class MyNavigation extends StatefulWidget {
  @override
  _MyNavigationState createState() => _MyNavigationState();
}

class _MyNavigationState extends State<MyNavigation> {


  bool modalWindowOpen;

  PersistentBottomSheetController bottomSheetController;

  showModalBottom(BuildContext context,List<Payment> payment,) async {
    modalWindowOpen=true;
    return Scaffold.of(context).showBottomSheet(
          (BuildContext context){
        return Center(
          child: Container(
            color:null,
            child: Container(
              //height: 70,
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
                              child:  SizedBox(width: 56, height: 56, child:
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
                          flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            PaymentCard(header: 'Membership Status',body:payment[0].status),
                            SizedBox(height: 5,),
                            PaymentCard(header: 'Payment Method',body:payment[0].type),
                            SizedBox(height: 5,),
                            PaymentCard(header: 'Payment Method',body:payment[0].type),
                            SizedBox(height: 5,),

                        ],),
                      )
                    ],
                  ),
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
    return  Expanded(
      flex: 1,
      child:  Container(
        color: Colors.green,
        child: Padding(
            padding: const EdgeInsets.all(0.0),
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
                data.userAuthenticated['account_type']=='student' ?
                Consumer<StudentProvider>(builder: (context,data,child)=> ClipOval(
                    child: Material(
                      color: Colors.green[600], // button color
                      child: InkWell(
                        splashColor: Colors.white, // inkwell color
                        child:  SizedBox(width: 56, height: 56, child:
                        Icon(Icons.payment,size: 30,color: Colors.white,) ),
                        onTap: ()async=> data.student.payments.length>0 ?
                        data.student.payments.last.status=='paid' ?
                        Navigator.push(context, PageRouteBuilder(
                          transitionDuration: Duration(seconds: 0),
                          pageBuilder: (context, animation1, animation2) => Membership(payment: data.student.payments.last,),
                        ))
                        //bottomSheetController = await  showModalBottom(context,data.student.payments)
                            : Navigator.push(context, PageRouteBuilder(
                          transitionDuration: Duration(seconds: 0),
                          pageBuilder: (context, animation1, animation2) => PaymentCheckpoint(routeIntent: 'profile',),
                        )) :  Navigator.push(context, PageRouteBuilder(
                          transitionDuration: Duration(seconds: 0),
                          pageBuilder: (context, animation1, animation2) => PaymentCheckpoint(routeIntent: 'profile'),
                        )),
                      ),
                    ),
                  ),
                ):SizedBox(width: 40,):SizedBox(width: 40,),
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
              //color: Colors.green,
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
                          //backgroundColor: Colors.green,
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


class StudentProfileView extends StatefulWidget {
  @override
  _StudentProfileViewState createState() => _StudentProfileViewState();
}

class _StudentProfileViewState extends State<StudentProfileView> {


  init()async{
   final  provider =  Provider.of<AuthProvider>(context,listen: false);
    final studentProvider =  Provider.of<StudentProvider>(context,listen: false);
    final userProvider =  Provider.of<UserProvider>(context,listen: false);
    studentProvider.fetchUserById(provider, userProvider.id);
    print('dependency loaded');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    init();
  }

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

class PartnerProfileView extends StatefulWidget {
  @override
  _PartnerProfileViewState createState() => _PartnerProfileViewState();
}

class _PartnerProfileViewState extends State<PartnerProfileView> {


  bool openPhotos=false;

  bool modalWindowOpen;

  PersistentBottomSheetController bottomSheetController;

  showModalBottom(BuildContext context,String photoUrl, String directory, List<PartnerAlbum> photos ) async {
    modalWindowOpen=true;
    return Scaffold.of(context).showBottomSheet(
          (BuildContext context){
        return Center(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(

                  decoration: BoxDecoration(
                    //borderRadius: BorderRadius.all(Radius.circular(25)),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(photoUrl)
                      )
                  ),
                ),
              ),
              Expanded(
                child: Container(child: Row(
                  children: <Widget>[
                    //photos.

                  ],
                ),),
              )
            ],
          )
        );

      },
      backgroundColor: Colors.black54,
    );
  }

  init()async{
    final  provider =  Provider.of<AuthProvider>(context,listen: false);
    final partnerProvider =  Provider.of<PartnerProvider>(context,listen: false);
    final userProvider =  Provider.of<UserProvider>(context,listen: false);
    partnerProvider.fetchUserById(provider, userProvider.id);
    print('dependency loaded');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    init();
  }

  File file;

  List<int> spotIds=[];



  void chooseImage(int fileNumber) async {
    file = await ImagePicker.pickImage(source: ImageSource.gallery,maxHeight: 300.0,
        maxWidth: 250.0,imageQuality: 100);

    final provider =  Provider.of<AuthProvider>(context,listen: false);
    final userProvider =  Provider.of<UserProvider>(context,listen: false);
    final partnerProvider=Provider.of<PartnerProvider>(context,listen: false);
    Map<String,String> data={};
    data['id']=userProvider.id.toString();
    data['spot_id']=fileNumber.toString();
    data['image']=base64Encode(file.readAsBytesSync());

    if(file!=null){
      await partnerProvider.uploadPhoto(provider, data);
      //String base64Image = base64Encode(file.readAsBytesSync());
      //String fileName = file.path.split("/").last;
    }
    //setState(() {currentPartnerPhotos[fileNumber]=file;});
// file = await ImagePicker.pickImage(source: ImageSource.gallery);
  }


  void deletePhoto(int fileNumber, int rowId) async {
    final provider =  Provider.of<AuthProvider>(context,listen: false);
    final userProvider =  Provider.of<UserProvider>(context,listen: false);
    final partnerProvider=Provider.of<PartnerProvider>(context,listen: false);
    Map<String,String> data={};
    data['id']=userProvider.id.toString();
    data['spot_id']=fileNumber.toString();
    data['row_id']=rowId.toString();
    await partnerProvider.deletePhoto(provider, data);

    //setState(() {currentPartnerPhotos[fileNumber]=file;});
// file = await ImagePicker.pickImage(source: ImageSource.gallery);
  }



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
            Container(
              child: Column(children: <Widget>[
                !openPhotos ? Text("Tap the camera icon to upload an image") : SizedBox(),
//                GestureDetector(
//                    onTap: ()=>setState(() {this.openPhotos=!openPhotos;}),
//                    //child: !openPhotos ? Icon(Icons.add,color: Colors.green[600],) :SizedBox()
//                )
                //Icon(Icons.close,color: Colors.red,)
              ],),
            ),

            SizedBox(height: 10,),
  Consumer<PartnerProvider>(
  builder:(context,data,child)=>   Expanded(
    child: data.partner!=null ? GridView.count(

    // Create a grid with 2 columns. If you change the scrollDirection to

    // horizontal, this produces 2 rows.

    crossAxisCount:4,

    scrollDirection: Axis.vertical,

    // Generate 100 widgets that display their index in the List.

    children: List.generate(8, (index) {
      int indexNumber =index+1;
      String photoUrl="$siteUrl/uploads/${data.partner.photos[index].directory}/partner_photos${data.partner.photos[index].title}";

      return data.partner.photos.isNotEmpty ?
         data.partner.photos[index].title!=null ?

       Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Colors.white,
            child: Column(children: <Widget>[

              Expanded(
                child: Container(
                     height:55,
                    width:130,
                    decoration: BoxDecoration(
                        //borderRadius: BorderRadius.all(Radius.circular(25)),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                        image: NetworkImage(photoUrl)
                      )
                    ),
                ),
              ),
  
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color:Colors.grey[100],
                      child: GestureDetector(
                          onTap:()=> deletePhoto(data.partner.photos[index].spotId,data.partner.photos[index].id),
                          child: Icon(Icons.cancel,color: Colors.red,)),
                    ),
                  ),  
                  Expanded(
                    child: Container(
                      child: GestureDetector(
                          onTap: ()async {
                            bottomSheetController = await  showModalBottom(context,photoUrl,data.partner.photos[index].directory,data.partner.photos);
                           // Provider.of<AlbumProvider>(context).currentImageId=null;
                          },
                          child: Icon(Icons.remove_red_eye,color: Colors.green[600],)),
                    ),
                  ),
                ],
              ),

            ],)

        ),

      ):GestureDetector(onTap: ()=>chooseImage(data.partner.photos[index].spotId), child: PartnerPhotoCardOne(cardNumber: data.partner.photos[index].spotId,)):
       GestureDetector(onTap: ()=>chooseImage(indexNumber), child: PartnerPhotoCardOne(cardNumber: indexNumber,));


    }),

  ):SizedBox(),



    ),
),


            Consumer<PartnerProvider>(
              builder:(context,data,child)=> Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: data.partner!=null && !openPhotos ? ListView(
                    children: <Widget>[
                      Row(crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ProfileCard(header: 'Name of Business',body: data.partner.nameOfBusiness,),
                              SizedBox(height: 7,),
                              ProfileCard(header: 'Primary Contact Person',body: data.partner.primaryContactPerson,),
                              SizedBox(height: 7,),
                              ProfileCard(header: 'Position Held',body: data.partner.positionHeld,),
                              SizedBox(height: 7,),
                              ProfileCard(header: 'Location of Business',body: data.partner.positionHeld,),
                              SizedBox(height: 7,),
                              ProfileCard(header: 'website',body: data.partner.website!=null ?data.partner.website:'NA',),
                              SizedBox(height: 7,),
                              ProfileCard(header: 'Email',body: data.partner.email,),
                              SizedBox(height: 7,),
                              ProfileCard(header: 'Phone',body: data.partner.phone,),
                              SizedBox(height: 7,),
                              ProfileCard(header: 'Category',body: data.partner.category['name'],),
                              SizedBox(height: 7,),
                              ProfileCard(header: 'Discount',body: '${data.partner.discount}%',),
                              SizedBox(height: 7,),
                              ProfileCard(header: 'State',body: '${data.partner.state['name']}',),
                              SizedBox(height: 7,),


                            ],
                          ),),


                        ],
                      ),


                    ],
                  ) : SizedBox(),
                ),
              ),
            ),

            Consumer<PartnerProvider>(
              builder:(context,data,child)=>
              data.partner==null ? Column(
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
//                  Skeleton(width: MediaQuery.of(context).size.width-20,),
//                  SizedBox(height: 20,),
//                  Skeleton(width: MediaQuery.of(context).size.width-20,),
//                  SizedBox(height: 20,),
//                  Skeleton(width: MediaQuery.of(context).size.width-20,),
//                  SizedBox(height: 20,),
//                  Skeleton(width: MediaQuery.of(context).size.width-20,),
//                  SizedBox(height: 20,),
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
          Text('$header',style: TextStyle(fontSize: 18.0,color: Colors.green),),
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


class PartnerPhotoCardOne extends StatefulWidget {

  final int cardNumber;

  PartnerPhotoCardOne({this.cardNumber});

  @override
  _PartnerPhotoCardOneState createState() => _PartnerPhotoCardOneState();
}

class _PartnerPhotoCardOneState extends State<PartnerPhotoCardOne> {




  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: <Widget>[
          Container(
            padding:  EdgeInsets.all(4.0),
            child: Icon(Icons.photo_camera,color: Colors.green[600],size: 70,),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Text("${widget.cardNumber.toString()}",style: TextStyle(color: Colors.red),),
          )
        ],

      ),
    );
  }
}


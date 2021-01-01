import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/providers/user.dart';
import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/providers/message.dart';
import 'package:flutter_todo/styles/styles.dart';
import 'package:flutter_todo/utils/validate.dart';
import 'package:flutter_todo/views/support_thank_you.dart';

class Message extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return  SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.green,
        body: Consumer<UserProvider>(
          builder:(context,data,child) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              MyNavigation(),
              PageLayout(data: Center(
                child:  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      data.userAuthenticated.isNotEmpty ?
                      data.userAuthenticated['account_type']=='admin' ?  MyFilter() :SizedBox() :SizedBox(),
                    data.userAuthenticated.isNotEmpty ?
                    //data.userAuthenticated['account_type']==null ? UnauthenticatedUsersMenu():
                    //data.userAuthenticated.length > 0 :
                    data.userAuthenticated['account_type']=='student' ? Expanded(child: AuthUserSupportView())  :
                    data.userAuthenticated['account_type']=='partner' ? Expanded(child: AuthUserSupportView())  :
                    data.userAuthenticated['account_type']=='admin' ? AdminSupportView()  :
                      Expanded(child: UnauthenticatedUserSupportView()): Expanded(child: UnauthenticatedUserSupportView()),
                  ],),


              ),)

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
                colors: [Colors.green[400], Colors.grey[600], Colors.green[400]]
            )
        ),
      ),vsync: this, duration: new Duration(seconds: 2),
    );
  }
}

class MyNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return   Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            IconButton(
              icon: GestureDetector(  onTap: (){
                Navigator.pop(context);
              },child: Icon(Icons.arrow_back_ios)),
              color: Colors.white,
              onPressed: () {},
            ),
            Text('Support Desk',style: TextStyle(color:Colors.white,fontSize: 30.0),),
          ],
        )
    );
  }
}


class PageLayout extends StatelessWidget {
  
  final Widget data;

 PageLayout({this.data});

  @override
  Widget build(BuildContext context) {
    return  Expanded(
      flex: 1,
      child:  Container(
         height: MediaQuery.of(context).size.height-140,
        decoration: BoxDecoration(
          color: Colors.green[600],
          borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)/*,topRight: Radius.circular(75.0)*/),

        ), child: data, )
    );
  }
}


class AdminSupportView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: MessageList(),);
  }
}

class AuthUserSupportView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: AuthSupportForm());
  }
}

class UnauthenticatedUserSupportView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: SupportForm());
  }
}





class AuthSupportForm extends StatefulWidget {
  @override
  _AuthSupportFormState createState() => _AuthSupportFormState();
}

class _AuthSupportFormState extends State<AuthSupportForm> {


  int id;

  String name;

  String email;

  String message;

  //String message = '';
  bool loading=false;
  bool modalWindowOpen=false;
  Duration snackBarDurationOpen= Duration(days: 1);
  Duration snackBarDurationClose= Duration(microseconds: 1);

  TextEditingController messageController= TextEditingController();
  TextEditingController emailController= TextEditingController();
  TextEditingController nameController= TextEditingController();
  TextEditingController idController= TextEditingController();

  final _formKey = GlobalKey<FormState>();


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
                    Text('Sending...')
                  ],
                )

            ),
          ),
        );

      },
      backgroundColor: Colors.black54,
    );
  }



  showModalBottomDismiss(dynamic errorBag){
    //Map errors=jsonDecode(errorBag);

    List<Widget> apiErrors=[];
    //print(errors['first_name']);
    errorBag.forEach((key,value){
      apiErrors.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Icon(Icons.error_outline,color: Colors.pink,),
              SizedBox(width: 5.0,),
              Flexible(child: Text(errorBag[key][0].toString(),style: TextStyle(color: Colors.pink),)),
            ],
          )
      ));
      //print(value);
    });

    int errorCount=apiErrors.length;

    return showModalBottomSheet(
        context: context,builder: (context){
      return Container(
        color: Colors.black45,
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0),topRight: Radius.circular(25.0))
            ),
            height: double.infinity,
            child: Column(
              children: <Widget>[
                SizedBox(height: 15.0,),
                Text('We found ($errorCount) errors',style: TextStyle(fontSize: 20.0),),
                SizedBox(height: 10.0,),
                Expanded(
                  child: ListView(
                      shrinkWrap: true,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: apiErrors
                  ),
                ),
              ],
            )
        ),
      );
    }

    );

  }


  Future<void>submit(BuildContext context)async{

    //show persistent bottomSheetModal
     PersistentBottomSheetController bottomSheetController;

    final userProvider = Provider.of<UserProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    name=userProvider.name;
    email=userProvider.email;
    message=messageController.text;
    id=userProvider.id;
     final form = _formKey.currentState;


    if(form.validate()){
      bottomSheetController =await showModalBottom(context);
      final sent= await Provider.of<MessageProvider>(context).submitAuthForm(authProvider,id: id.toString(), name: name,email: email, message: message);

      if(sent['success']){
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context)=>SupportThanks()));
        bottomSheetController.close();
        return;
      }else {
        print(sent['code']);
        if ( sent['code']==422){
          print('validation error found');
          Future.delayed(Duration(milliseconds: 6000), () {
            bottomSheetController.close();
            modalWindowOpen = false;
            showModalBottomDismiss(sent['data']['errors']);
            // _showModal();
          });
          return;

        }




      }




  final snackBar = new SnackBar(
      content: new Text('Problem completing request'),
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

  }


  @override
  Widget build(BuildContext context) {
     return  Padding(
       padding: const EdgeInsets.all(14.0),
       child: Form(
         key: _formKey ,
         child: Consumer<UserProvider>(builder:(context,data,child)=> (
            ListView(
             //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      SizedBox(height: 30,),
      Text("Welcome to our Support Desk, What can we do for you today?",style: Styles.textTheme2, ),
      SizedBox(height: 30,),

    Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20.0))
      ),
      child: TextFormField(
          initialValue: data.name!=null ? data.name : '',
          //enabled: data.name!=null? true:false,
           // style: Styles.textTheme2,
            //initialValue: data.name!=null ? data.name: '',
      decoration: Styles.flatFormFieldsNoBorder.copyWith(labelText: 'NAME',focusColor: Colors.pink,labelStyle: TextStyle(color: Colors.black54,)),
          validator: (value) {
            //password = value.trim();
            return Validate.requiredField(value, 'Name is required.');
          }

      ),
    ),
      SizedBox(height: 30,),
    Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20.0))
      ),
      child: TextFormField(
          initialValue: data.email!=null ? data.email : '',
          enabled: false,
            //initialValue: data.email!=null ? data.email: '',
      decoration: Styles.flatFormFieldsNoBorder.copyWith(labelText: 'EMAIL',focusColor: Colors.pink,)

      ),
    ),
      SizedBox(height: 30,),
    Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20.0))
      ),
      child: TextFormField(
                controller: messageController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                maxLines: 4,
                maxLength: 120,
      //initialValue: '',
      decoration: Styles.flatFormFieldsNoBorder.copyWith( labelText: 'MESSAGE',focusColor: Colors.pink,),
          validator: (value) {
          //password = value.trim();
          return Validate.requiredField(value, 'Message body is required.');
    }


      ),
    ),
      SizedBox(height: 20,),
      Builder(
            builder: (context) =>ButtonTheme(
            minWidth: MediaQuery.of(context).size.width-20,
            height: 50,
            buttonColor: Colors.red,
            child: RaisedButton(
              onPressed: (){submit(context);},
              child: Text("Submit",style: TextStyle(color: Colors.white),)
            ),
            ),
      ),
    ],
    )
         ),
         ),
       ));
  }
}



class SupportForm extends StatefulWidget {
  @override
  _SupportFormState createState() => _SupportFormState();
}

class _SupportFormState extends State<SupportForm> {

  int id;

  String name;

  String email;

  String message;

  //String message = '';
  bool loading=false;
  bool modalWindowOpen=false;
  Duration snackBarDurationOpen= Duration(days: 1);
  Duration snackBarDurationClose= Duration(microseconds: 1);

  TextEditingController messageController= TextEditingController();
  TextEditingController emailController= TextEditingController();
  TextEditingController nameController= TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
                    Text('Sending...')
                  ],
                )

            ),
          ),
        );

      },
      backgroundColor: Colors.black54,
    );
  }



  showModalBottomDismiss(dynamic errorBag){
    //Map errors=jsonDecode(errorBag);

    List<Widget> apiErrors=[];
    //print(errors['first_name']);
    errorBag.forEach((key,value){
      apiErrors.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Icon(Icons.error_outline,color: Colors.pink,),
              SizedBox(width: 5.0,),
              Flexible(child: Text(errorBag[key][0].toString(),style: TextStyle(color: Colors.pink),)),
            ],
          )
      ));
      //print(value);
    });

    int errorCount=apiErrors.length;

    return showModalBottomSheet(
        context: context,builder: (context){
      return Container(
        color: Colors.black45,
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0),topRight: Radius.circular(25.0))
            ),
            height: double.infinity,
            child: Column(
              children: <Widget>[
                SizedBox(height: 15.0,),
                Text('We found ($errorCount) errors',style: TextStyle(fontSize: 20.0),),
                SizedBox(height: 10.0,),
                Expanded(
                  child: ListView(
                      shrinkWrap: true,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: apiErrors
                  ),
                ),
              ],
            )
        ),
      );
    }

    );

  }


  Future<void>submit(BuildContext context)async{

    //show persistent bottomSheetModal
    PersistentBottomSheetController bottomSheetController;

    final authProvider = Provider.of<AuthProvider>(context);
    name=nameController.text;
    email=emailController.text;
    message=messageController.text;
    final form = _formKey.currentState;


    if(form.validate()){
      bottomSheetController =await showModalBottom(context);
      final sent= await Provider.of<MessageProvider>(context).submitGuestForm(authProvider , name: name,email: email, message: message);

      if(sent['success']){
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context)=>SupportThanks()));
        bottomSheetController.close();
        return;
      }else {
        print(sent['code']);
        if ( sent['code']==422){
          print('validation error found');
          Future.delayed(Duration(milliseconds: 6000), () {
            bottomSheetController.close();
            modalWindowOpen = false;
            showModalBottomDismiss(sent['data']['errors']);
            // _showModal();
          });
          return;

        }




      }




      final snackBar = new SnackBar(
          content: new Text('Problem completing request'),
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

  }


  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: const EdgeInsets.all(14.0),
        child: Form(
          key: _formKey ,
          child:
              ListView(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 30,),
                  Text("Welcome to Our Support Desk, What can we do for you today?",style: Styles.textTheme2, ),
                  SizedBox(height: 30,),

                  Container(
                    padding: EdgeInsets.all(1.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20.0))
                    ),
                    child: TextFormField(
                        controller: nameController,
                        // style: Styles.textTheme2,
                        //initialValue: data.name!=null ? data.name: '',
                        decoration: Styles.flatFormFieldsNoBorder.copyWith(labelText: 'NAME',focusColor: Colors.pink,labelStyle: TextStyle(color: Colors.black54,)),
                        validator: (value) {
                          //password = value.trim();
                          return Validate.requiredField(value, 'Name is required.');
                        }

                    ),
                  ),
                  SizedBox(height: 30,),
                  Container(
                    padding: EdgeInsets.all(1.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20.0))
                    ),
                    child: TextFormField(
                        controller: emailController,
                        //initialValue: data.email!=null ? data.email: '',
                        decoration: Styles.flatFormFieldsNoBorder.copyWith(labelText: 'EMAIL',focusColor: Colors.pink,),
                        validator: (value) {
                      //email = value.trim();
                      return Validate.validateEmail(value);
        },

                    ),
                  ),
                  SizedBox(height: 30,),
                  Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20.0))
                    ),
                    child: TextFormField(
                        controller: messageController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        maxLines: 5,
                        maxLength: 120,
                        //initialValue: '',
                        decoration: Styles.flatFormFieldsNoBorder.copyWith( labelText: 'MESSAGE',focusColor: Colors.pink,),
                        validator: (value) {
                          //password = value.trim();
                          return Validate.requiredField(value, 'Message body is required.');
                        }


                    ),
                  ),
                  SizedBox(height: 20,),
                  Builder(
                    builder: (context) =>ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width-20,
                      height: 50,
                      buttonColor: Colors.red,
                      child: RaisedButton(
                          onPressed: (){submit(context);},
                          child: Text("Submit",style: TextStyle(color: Colors.white),)
                      ),
                    ),
                  ),
                ],
              )
          ),

        );
  }
}



class MyFilter extends StatefulWidget {


  @override
  _MyFilterState createState() => _MyFilterState();
}

class _MyFilterState extends State<MyFilter> {


  /*business name search*/
  TextEditingController emailController= TextEditingController();


  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);
    //businessNameController.text="Happy Bites";
    //return Container(child:Text('hi there') ,);
    return  Consumer<MessageProvider>(
      builder: (context,data,child)=>Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:  BorderRadius.only(topLeft: Radius.circular(75.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black54,
                      blurRadius: 15.0,
                      offset: Offset(0.0, 0.4)
                  )
                ]
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all( 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Showing",
                              style: Styles.p,
                            ),
                            TextSpan(
                              text: ' (',
                              style: Styles.darkText1,
                            ),
                            TextSpan(
                              text: ' ${data.messages!=null ? data.messages.length : 0 } ',
                              style: Styles.themeColor2,
                            ),
                            TextSpan(
                              text: ') ',
                              style: Styles.darkText1,
                            ),
                            TextSpan(
                              text: 'of',
                              style: Styles.p,
                            ),
                            TextSpan(
                              text: ' (',
                              style: Styles.darkText1,
                            ),
                            TextSpan(
                              text: ' ${data.paginate!=null ? data.paginate.total.toString() : 0 }',
                              style: Styles.themeColor2,
                            ),
                            TextSpan(
                              text: ' )',
                              style: Styles.darkText1,
                            ),
                            TextSpan(
                              text: ' results',
                              style: Styles.p,
                            ),
                          ],
                        ),
                      ),

                      //Text('Showing (${data.partners!=null ? data.partners.length : 0 }) of (${data.paginate!=null ? data.paginate.total.toString() : 0 }) results',style: TextStyle(fontSize: 16.0),),
                      //Text('Deals!!',style: TextStyle(color:Colors.green,fontSize: 30.0),),
                      Row(

                        children: <Widget>[
                          Text('filter',style: TextStyle(color:Colors.black),),
                          GestureDetector(
                              onTap: (){
                                setState(() {
                                  data.showFilter=!data.showFilter;
                                });
                              },
                              child: Icon(Icons.sort,color:Colors.pink,)),

                        ],
                      )
                    ],
                  ),
                ),



                if (data.showFilter)  SizedBox(height: 5.0 )
                else
                  SizedBox(height: 8.0 ),

                if (data.showFilter)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 45,
                      child: TextFormField(
                        controller:  emailController,
                        //controller: _deliveryController,
                        decoration: Styles.flatFormFieldsRounded.copyWith(
                            filled: true,
                            fillColor: Colors.grey[200],
                            labelText: 'Email',
                            labelStyle: TextStyle(
                                color: Colors.black
                            ),
                            focusColor: Colors.pink
                        ),
                      ),
                    ),
                  ),
                if (data.showFilter)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: ButtonTheme(
                            minWidth: MediaQuery.of(context).size.width-20,
                            height: 40,
                            buttonColor: Colors.green,
                            child: GestureDetector(
                              onTap:(){},
                              child: RaisedButton(
                                onPressed: () {
                                  data.messageSearch(authProvider, emailController.text);
                                },
                                child: Text("Search",style: TextStyle(color: Colors.white),),
                              ),
                            ),
                          ),),
                        SizedBox(width: 10.0,),
                        Expanded(
                            child: GestureDetector(
                              onTap:(){
                                if(emailController!=null)
                                  emailController.clear();
                                data.initMessages(authProvider);
                                setState(() {

                                });
                              },
                              child: Row(children: <Widget>[
                                Text('reset'),
                                Icon(Icons.refresh,color: Styles.myColor1,),
                              ],),
                            )
                        ),
                      ],
                    ),
                  )

              ],
            ),
          ),



        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    super.dispose();
  }


}



class MessageList extends StatefulWidget {
  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {

  bool modalWindowOpen;

  Map message;

  PersistentBottomSheetController bottomSheetController;

  showModalBottom(BuildContext context,dynamic message) async {
    modalWindowOpen=true;
    return Scaffold.of(context).showBottomSheet(
          (BuildContext context){
        return Center(
          child: Container(
            color: Colors.black,
            child: Container(
                //height: 70,
                decoration: BoxDecoration(
                    color: Colors.green,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0),topRight: Radius.circular(25.0))
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
                              color: Colors.green[600], // button color
                              child: InkWell(
                                splashColor: Colors.white, // inkwell color
                                child:  SizedBox(width: 56, height: 56, child:
                                Icon(Icons.close,size: 50,color: Colors.red,) ),
                                onTap: ()=>bottomSheetController.close(),
                              ),
                            ),
                          )
//
                          ),),
                      SizedBox(height: 35,),
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: double.infinity,
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                          Text('Sender',style: TextStyle(fontSize: 20),),
                          Text('${message.email}',style: TextStyle(color: Colors.grey[600]),),
                      ],),),
                        ),
                      SizedBox(height: 5,),
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                          Text('Name',style: TextStyle(fontSize: 20),),
                          Text('${message.name}',style: TextStyle(color: Colors.grey[600])),
                        ],),),
                      ),
                      SizedBox(height: 5,),

                        Expanded(
                          flex: 5,
                            child:Container(
                              padding: EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(20.0))
                              ),
                              child: ListView(
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                  Text('Message',style: TextStyle(fontSize: 20),),
                                  Text('${message.message}',style: TextStyle(color: Colors.grey[500]))
                                  ],),

                                ],
                              ),
                            )
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

    final _provider = Provider.of<AuthProvider>(context,listen: false);
    final messageProvider = Provider.of<MessageProvider>(context,listen: false);
     messageProvider.initMessages(_provider);

    return Consumer<MessageProvider>(
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
            child: Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: ListView.builder(
                itemCount: data.messages.length,
                itemBuilder: (context, index) {
                  return  GestureDetector(
                   onTap: ()async{
                     bottomSheetController = await  showModalBottom(context,data.messages[index]);
                     print(data.messages[index]);
                   },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                        ),
                        child: Stack(children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(data.messages[index].name),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 6,
                                      child: Text(data.messages[index].message,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.grey[500]),)),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(25),bottomRight:Radius.circular(25) )
                                      ),
                                      padding: EdgeInsets.symmetric(vertical: 12.0,horizontal: 5.0),
                                      child: data.messages[index].status=='unseen' ?  Text('new',style: TextStyle(color:Colors.white ,fontSize: 10),) : SizedBox(),
                                    ),
                                  )
                                ],
                              ),
                              Row(children: <Widget>[
                                Text('sent ${data.messages[index].createdAt}'),
                                SizedBox(width: 10,),
                                Text('${data.messages[index].accountType}',style: TextStyle(color: Colors.green),)
                              ],)

                            ],),


                        ],),
                      ),
                    ),
                  );





                },
              ),
            ),
          ) : Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('Waiting for messages.........',style: TextStyle(color: Colors.white),),
              Skeleton(width: MediaQuery.of(context).size.width-20,),
              SizedBox(height: 3,),
              Skeleton(width: MediaQuery.of(context).size.width-30,),
              SizedBox(height: 3,),
              Skeleton(width: MediaQuery.of(context).size.width-40,),
              SizedBox(height:3,),
              Skeleton(width: MediaQuery.of(context).size.width-50,),

            ],)
      ),
    );
  }
}



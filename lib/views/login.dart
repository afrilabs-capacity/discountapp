import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_todo/models/message.dart';
import 'package:flutter_todo/views/album_page.dart';
import 'package:flutter_todo/views/landing_page.dart';
import 'package:flutter_todo/views/message_page.dart' as Mp;
import 'package:provider/provider.dart';

import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/utils/validate.dart';
import 'package:flutter_todo/styles/styles.dart';
import 'package:flutter_todo/views/registration_type.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_todo/views/loading.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/providers/user.dart';


// Define a custom Form widget.
class Login extends StatefulWidget {

  static final String id="login";

  GlobalKey loginKey= GlobalKey();


  @override
  LoginState createState() {
    return LoginState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class LoginState extends State<Login> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  String email;
  String password;


  String emailStudent='mydiynuggets360@gmail.com';
  String passwordStudent='123456';

  String emailAdmin='admin@naijagreencard.com';
  String passwordAdmin='jackson6#';

  String emailPartner='danilposh360@gmail.com';
  String passwordPartner='T0mltO08';

  String message = '';
  bool loading=false;
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
                    Text('Authenticating...')
                  ],
                )

            ),
          ),
        );

      },
      backgroundColor: Colors.black54,
    );
  }

  showModalBottomDismiss(BuildContext context){
    showModalBottomSheet(context: context,builder: (context){
      return Center(child: Text('Invalid username or password'));

    });

  }

  Future<void> submit(BuildContext context,String submitType) async {
    //show persistent bottomSheetModal
   PersistentBottomSheetController bottomSheetController;
   final form = _formKey.currentState;
    if (form.validate()) {
      bottomSheetController =await showModalBottom(context);
      var login;
      submitType=='student' ?
      login= await Provider.of<AuthProvider>(context,listen: false).login(emailStudent, passwordStudent) :
      submitType=='partner' ?  login= await Provider.of<AuthProvider>(context,listen: false).login(emailPartner, passwordPartner):
      login= await Provider.of<AuthProvider>(context,listen: false).login(emailAdmin, passwordAdmin);

      if(login){
        Navigator.pushReplacement(context,
            PageRouteBuilder(
              transitionDuration: Duration(seconds: 0),
              pageBuilder: (context, animation1, animation2) => Loading(),
            )
          //MaterialPageRoute( builder: (context)=> Loading() )
    ,);
        bottomSheetController.close();
        return;
      }

    }
     //print('hi there');
   final snackBar = new SnackBar(
        content: new Text('Invalid Username or Password'),
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

  @override
  void initState() {
    // TODO: implement initState
    //testApi();
    super.initState();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }


  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.



    return WillPopScope(
      onWillPop: () async =>  modalWindowOpen ?  false : true,
      child: SafeArea(
        child: Scaffold(
          //key: login,
          body: Container(
            //color: Colors.green,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                  key: _formKey,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Divider(),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                  //color: Colors.white,
//                                  boxShadow: [
//                                    BoxShadow(
//                                      color: Colors.black26,
//                                      blurRadius: 1.0, // soften the shadow
//                                      spreadRadius: 1.0, //extend the shadow
//                                      offset: Offset(
//                                        0.0, // Move to right 10  horizontally
//                                        2.0, // Move to bottom 5 Vertically
//                                      ),
//                                    )
//                                  ]
                              ),
                              //color: Colors.grey[200],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                GestureDetector(
                                    onTap:()=> Navigator.pushReplacement(context, PageRouteBuilder(
                              transitionDuration: Duration(seconds: 0),
                              pageBuilder: (context, animation1, animation2) => LandingPage(),
                            )),
                                    child: Icon(Icons.home,color: Colors.green,size: 35,)),
                                GestureDetector(
                                    onTap:()=> Navigator.pushReplacement(context, PageRouteBuilder(
                                      transitionDuration: Duration(seconds: 0),
                                      pageBuilder: (context, animation1, animation2) => Album(),
                                    )),
                                    child: Icon(Icons.camera,color: Colors.green,size: 35,)),
                                GestureDetector(
                                    onTap:()=> Navigator.pushReplacement(context, PageRouteBuilder(
                                      transitionDuration: Duration(seconds: 0),
                                      pageBuilder: (context, animation1, animation2) => Mp.Message(),
                                    )),
                                    child: Icon(Icons.email,color: Colors.green,size: 35,)),
                              ],),
                            ),
                            Divider(),
                            SizedBox(height: 30,),
                            Center(child:Image.asset('assets/images/logo.png',scale: 3.0,)),
                            SizedBox(height: 25.0,),

//                            Center(
//                                child:Text('Sign in to continue'),
//                            ),

                            TextFormField(
                              initialValue: 'braimahjake@gmail.com',
                        decoration: Styles.flatFormFields.copyWith(labelText: 'EMAIL',focusColor: Colors.pink),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                              email = value.trim();
                              return Validate.validateEmail(value);
                          },
              ),

                            TextFormField(
                              initialValue: 'mmmmmm',
                              obscureText: true,
                              decoration: Styles.flatFormFields.copyWith(labelText: 'PASSWORD',focusColor: Colors.pink),
                            validator: (value) {
                              password = value.trim();
                              return Validate.requiredField(value, 'Password is required.');
                            }

                            ),
                            SizedBox(height: 20.0),

                            Builder(
                              builder: (context) => Consumer<AuthProvider>(
                                builder:(context,child,user)=>
                                    RaisedButton(
                                  color: Colors.green,
                                  disabledColor: Colors.grey,
                                  onPressed: !modalWindowOpen ? ()=>submit(context,'student') : null,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      //color: Colors.green,
                                    ),
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                                    child: Text(
                                      'Sign In Student'
                                      , style: TextStyle(color: Colors.white,),),
                                  ),
                                ),
                              ),
                            ),
                            Builder(
                              builder: (context) => Consumer<AuthProvider>(
                                builder:(context,child,user)=>
                                    RaisedButton(
                                      color: Colors.green,
                                      disabledColor: Colors.grey,
                                      onPressed: !modalWindowOpen ? ()=>submit(context,'admin') : null,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          //color: Colors.green,
                                        ),
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                                        child: Text(
                                          'Sign In Admin'
                                          , style: TextStyle(color: Colors.white,),),
                                      ),
                                    ),
                              ),
                            ),
                                           // SizedBox(height: 5.0,),
                            Builder(
                              builder: (context) => Consumer<AuthProvider>(
                                builder:(context,child,user)=>
                                    RaisedButton(
                                      color: Colors.green,
                                      disabledColor: Colors.grey,
                                      onPressed: !modalWindowOpen ? ()=>submit(context,'partner') : null,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          //color: Colors.green,
                                        ),
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                                        child: Text(
                                          'Sign In Partner'
                                          , style: TextStyle(color: Colors.white,),),
                                      ),
                                    ),
                              ),
                            ),
                            SizedBox(height: 25.0,),
                                            Center(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Don't have an account? ",
                                  style: Styles.p,
                                ),
                                TextSpan(
                                  text: 'Register.',
                                  style: Styles.p.copyWith(color: Colors.green[500]),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => {
                                      Navigator.pushNamed(context, RegistrationType.id),
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),


                            // Add TextFormFields and RaisedButton here.
                          ]
                      ),
                    ),
                  )
              ),
            ),
          ),
        ),
      ),
    );


  }
}










//class LogIn extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Log In'),
//        leading: Container(),
//      ),
//      body: Center(
//        child: Container(
//          child: Padding(
//            padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
//            child: LogInForm(),
//          ),
//        ),
//      ),
//    );
//  }
//}
//
//class LogInForm extends StatefulWidget {
//  const LogInForm({Key key}) : super(key: key);
//
//  @override
//  LogInFormState createState() => LogInFormState();
//}
//
//class LogInFormState extends State<LogInForm> {
//  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//  String email;
//  String password;
//  String message = '';
//
//  Future<void> submit() async {
//    final form = _formKey.currentState;
//    if (form.validate()) {
//      await Provider.of<AuthProvider>(context).login(email, password);
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    SizeConfig().init(context);
//    return Form(
//      key: _formKey,
//      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.stretch,
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: <Widget>[
//
//
//
//
//               Stack(
//                 children: <Widget>[
//                   Container(
//                     padding: EdgeInsets.fromLTRB(15.0, 30.0, 0.0, 0.0),
//                     child: Text('Hello',
//                         style: TextStyle(
//                             fontSize: 80.0, fontWeight: FontWeight.bold)),
//                   ),
//                   Container(
//                     padding: EdgeInsets.fromLTRB(16.0, 110.0, 0.0, 0.0),
//                     child: Text('There',
//                         style: TextStyle(
//                             fontSize: 80.0, fontWeight: FontWeight.bold)),
//                   ),
//                   Container(
//                     padding: EdgeInsets.fromLTRB(220.0, 110.0, 0.0, 0.0),
//                     child: Text('.',
//                         style: TextStyle(
//                             fontSize: 80.0,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.green)),
//                   ),
//                 ],
//               ),
//
//
//
//
//          Container(
//            child: Column(
//              children: <Widget>[
//
//                Text(
//                  'Sign in to the App',
//                  textAlign: TextAlign.center,
//                  style: Styles.h1,
//                ),
//                SizedBox(height: 10.0),
//                Consumer<AuthProvider>(
//                  builder: (context, provider, child) => provider.notification ?? NotificationText(''),
//                ),
//
//
//                TextFormField(
//                    decoration:Styles.flatFormFields .copyWith( labelText: 'EMAIL'),
//                    validator: (value) {
//                      email = value.trim();
//                      return Validate.validateEmail(value);
//                    }
//                ),
//                SizedBox(height: 15.0),
//                TextFormField(
//                    obscureText: true,
//                    decoration: Styles.flatFormFields .copyWith( labelText: 'PASSWORD'),
//                    validator: (value) {
//                      password = value.trim();
//                      return Validate.requiredField(value, 'Password is required.');
//                    }
//                ),
//                SizedBox(height: 15.0),
//                StyledFlatButton(
//                  'Sign In',
//                  onPressed: submit,
//                ),
//                SizedBox(height: 20.0),
//                Center(
//                  child: RichText(
//                    text: TextSpan(
//                      children: [
//                        TextSpan(
//                          text: "Don't have an account? ",
//                          style: Styles.p,
//                        ),
//                        TextSpan(
//                          text: 'Register.',
//                          style: Styles.p.copyWith(color: Colors.blue[500]),
//                          recognizer: TapGestureRecognizer()
//                            ..onTap = () => {
//                              Navigator.pushNamed(context, '/register'),
//                            },
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
//                SizedBox(height: 5.0),
//                Center(
//                  child: RichText(
//                    text: TextSpan(
//                        text: 'Forgot Your Password?',
//                        style: Styles.p.copyWith(color: Colors.blue[500]),
//                        recognizer: TapGestureRecognizer()
//                          ..onTap = () => {
//                            Navigator.pushNamed(context, '/password-reset'),
//                          }
//                    ),
//                  ),
//                ),
//              ],
//            ),
//          ),
//
//
//
//        ],
//      ),
//    );
//  }
//}




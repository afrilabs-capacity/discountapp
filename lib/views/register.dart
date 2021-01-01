import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/utils/validate.dart';
import 'package:flutter_todo/styles/styles.dart';
import 'package:flutter_todo/widgets/styled_flat_button.dart';






// Define a custom Form widget.
class Register extends StatefulWidget {
  @override
  RegisterState createState() {
    return RegisterState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class RegisterState extends State<Register> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
  String name;
  String email;
  String password;
  String passwordConfirm;
  String message = '';

  Map response = new Map();


//  Future<void> submit() async {
//    final form = _formKey.currentState;
//    if (form.validate()) {
//      response = await Provider.of<AuthProvider>(context)
//          .register(name, email, password, passwordConfirm);
//      if (response['success']) {
//        Navigator.pop(context);
//      } else {
//        setState(() {
//          message = response['message'];
//        });
//      }
//    }
//  }


  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
              key: _formKey,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                            child:Image.asset('assets/images/logo.png',scale: 3.0,)
                        ),
                        SizedBox(height: 25.0,),

                        Center(
                          child:Text('Sign in to continue'),
                        ),

                        TextFormField(
                          decoration: Styles.flatFormFields.copyWith(labelText: 'EMAIL',focusColor: Colors.pink),
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            email = value.trim();
                            return Validate.validateEmail(value);
                          },
                        ),

                        TextFormField(
                            decoration: Styles.flatFormFields.copyWith(labelText: 'PASSWORD',focusColor: Colors.pink),
                            validator: (value) {
                              password = value.trim();
                              return Validate.requiredField(value, 'Password is required.');
                            }

                        ),
                        SizedBox(height: 20.0),

                        Builder(
                          builder: (context) => RaisedButton(
                            color: Colors.green,
                            disabledColor: Colors.grey,
                            onPressed:(){
                             // submit();
                              final snackBar = SnackBar(content: Text('Yay! A SnackBar!'));
                              Scaffold.of(context).showSnackBar(snackBar);

                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                //color: Colors.green,
                              ),
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                              child: Text('Sign In', style: TextStyle(color: Colors.white),),
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
                                      Navigator.pushNamed(context, '/register'),
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
    );


  }
}








//class Register extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Register'),
//      ),
//      body: Center(
//        child: Container(
//          child: Padding(
//            padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
//            child: RegisterForm(),
//          ),
//        ),
//      ),
//    );
//  }
//}
//
//class RegisterForm extends StatefulWidget {
//  const RegisterForm({Key key}) : super(key: key);
//
//  @override
//  RegisterFormState createState() => RegisterFormState();
//}
//
//class RegisterFormState extends State<RegisterForm> {
//  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//  String name;
//  String email;
//  String password;
//  String passwordConfirm;
//  String message = '';
//
//  Map response = new Map();
//
//
//  Future<void> submit() async {
//    final form = _formKey.currentState;
//    if (form.validate()) {
//      response = await Provider.of<AuthProvider>(context)
//          .register(name, email, password, passwordConfirm);
//      if (response['success']) {
//        Navigator.pop(context);
//      } else {
//        setState(() {
//          message = response['message'];
//        });
//      }
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Form(
//      key: _formKey,
//      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.stretch,
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: <Widget>[
//          Text(
//            'Register Account',
//            textAlign: TextAlign.center,
//            style: Styles.h1,
//          ),
//          SizedBox(height: 10.0),
//          Text(
//            message,
//            textAlign: TextAlign.center,
//            style: Styles.error,
//          ),
//          SizedBox(height: 30.0),
//          TextFormField(
//            decoration: Styles.input.copyWith(
//              hintText: 'Name',
//            ),
//            validator: (value) {
//              name = value.trim();
//              return Validate.requiredField(value, 'Name is required.');
//            }
//          ),
//          SizedBox(height: 15.0),
//          TextFormField(
//            decoration: Styles.input.copyWith(
//              hintText: 'Email',
//            ),
//            validator: (value) {
//              email = value.trim();
//              return Validate.validateEmail(value);
//            }
//          ),
//          SizedBox(height: 15.0),
//          TextFormField(
//            obscureText: true,
//            decoration: Styles.input.copyWith(
//              hintText: 'Password',
//            ),
//            validator: (value) {
//              password = value.trim();
//              return Validate.requiredField(value, 'Password is required.');
//            }
//          ),
//          SizedBox(height: 15.0),
//          TextFormField(
//            obscureText: true,
//            decoration: Styles.input.copyWith(
//              hintText: 'Password Confirm',
//            ),
//            validator: (value) {
//              passwordConfirm = value.trim();
//              return Validate.requiredField(value, 'Password confirm is required.');
//            }
//          ),
//          SizedBox(height: 15.0),
//          StyledFlatButton(
//            'Register',
//            onPressed: submit,
//          ),
//        ],
//      ),
//    );
//  }
//}

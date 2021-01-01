import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/providers/user.dart';
import 'package:flutter_todo/providers/paymentmodal.dart';
import 'package:flutter_todo/providers/partner.dart';
import 'package:flutter_todo/providers/deal.dart';
import 'package:flutter_todo/providers/student.dart';
import 'package:flutter_todo/providers/message.dart';
import 'package:flutter_todo/providers/album.dart';
import 'package:flutter_todo/providers/route.dart';
import 'package:flutter_todo/providers/chat.dart';

import 'package:flutter_todo/views/loading.dart';
import 'package:flutter_todo/views/login.dart';
import 'package:flutter_todo/views/register.dart';
import 'package:flutter_todo/views/password_reset.dart';
import 'package:flutter/services.dart';
import 'views/registration_type.dart';
import 'package:flutter_todo/views/student_registration.dart';


void main() {

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
   // runApp(new MyApp());
    Provider.debugCheckInvalidValueType = null;
    runApp(
      MultiProvider(
       providers: [
          ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
          ProxyProvider<UserProvider, AuthProvider>(
            update: (_, userProvider, __) => AuthProvider(userProvider: userProvider),
          ),
//          ChangeNotifierProvider<UserProvider>(
//              create: (_) => UserProvider()
//          ),
//          ProxyProvider<UserProvider, AuthProvider>(
//            update: (_,userProvider, __) => AuthProvider( userProviderModel: userProvider.user),
//          ),
          //ChangeNotifierProvider<AuthProvider>(create: (context) => AuthProvider()),
          //ChangeNotifierProvider<UserProvider>(create: (context) => UserProvider()),
          ChangeNotifierProvider<PaymentModalProvider>(create: (context) => PaymentModalProvider()),
          ChangeNotifierProvider<PartnerProvider>(create: (context) => PartnerProvider()),
          ChangeNotifierProvider<DealProvider>(create: (context) => DealProvider()),
          ChangeNotifierProvider<StudentProvider>(create: (context) =>  StudentProvider()),
         ChangeNotifierProvider<MessageProvider>(create: (context) =>  MessageProvider()),
         ChangeNotifierProvider<AlbumProvider>(create: (context) =>   AlbumProvider()),
         ChangeNotifierProvider<RouteProvider>(create: (context) =>   RouteProvider()),
         ChangeNotifierProvider<ChatProvider>(create: (context) =>   ChatProvider()),
        ],
        //builder: (context) => AuthProvider(),
        child: MaterialApp(
          //initialRoute: true,
          routes: {
           '/': (context) => Router(),
            Login.id: (context) => Login (),
            '/register': (context) => Register(),
            RegistrationType.id: (context) => RegistrationType(),
            StudentRegistration.id: (context) => StudentRegistration(),
            '/password-reset': (context) => PasswordReset(),
          },
        ),
      ),
    );



  });

}





class Router extends StatelessWidget {

  static final id = 'Router';

  @override
  Widget build(BuildContext context) {

    //final authProvider = Provider.of<AuthProvider>(context,listen: false);
    //print(authProvider.status);
    return Loading();



  }




}
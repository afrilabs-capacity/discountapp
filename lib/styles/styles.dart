import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Styles {
  static TextStyle defaultStyle = TextStyle(
    color: Colors.grey[900]
  );

  static TextStyle h1 = defaultStyle.copyWith(
    fontWeight: FontWeight.w700,
    fontSize: 18.0,
    height: 22 / 18,
  );

  static TextStyle h2 = defaultStyle.copyWith(
    fontWeight: FontWeight.w600,
    fontSize: 17.0,
    height: 22 / 76,
  );

  static TextStyle p = defaultStyle.copyWith(
    fontSize: 16.0,
  );

  static TextStyle error = defaultStyle.copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
    color: Colors.red,
  );

  static TextStyle themeColor1 = defaultStyle.copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
    color: Colors.green,
  );
  static TextStyle themeColor2 = defaultStyle.copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
    color: Colors.pink,
  );


  static TextStyle lightText1 = defaultStyle.copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
    color: Colors.grey[200],
  );
  static TextStyle lightText2 = defaultStyle.copyWith(
      fontSize: 16.0,
      color: Colors.grey[600]
  );

  static TextStyle darkText1 = defaultStyle.copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
    color: Colors.black54
  );



  static InputDecoration input = InputDecoration(
    fillColor: Colors.white,
    focusColor: Colors.grey[900],
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.blue,
        width: 2.0,
      ),
    ),
    border: OutlineInputBorder(
      gapPadding: 1.0,
      borderSide: BorderSide(
        color: Colors.grey[600],
        width: 1.0,
      ),
    ),
    hintStyle: TextStyle(
      color: Colors.grey[600],
    ),
  );

  static  InputDecoration flatFormFields =   InputDecoration(
      labelStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.normal,fontSize: 17.0),);

  static  InputDecoration flatFormFieldsNoBorder =   InputDecoration(
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      contentPadding:
      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
    labelStyle: TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.normal,fontSize: 17.0),);

  static  InputDecoration flatFormFieldsRounded =   InputDecoration(
    labelStyle: TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.normal,fontSize: 17.0),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      borderSide: BorderSide(color: Colors.grey),
    ),
  );


  static Color myColor1 = Colors.green;

  static Color myColor2 = Colors.red;

  static Color myColor3 = Colors.orange;

  static Color myColor4 = Colors.purple;

  static Color myColor5 = Colors.purpleAccent;

  static Color myColor6 = Colors.pink;

  static Color myColor7 = Colors.white;



  static Color myColorShade1 = Colors.green[400];

  static Color myColorShade2 = Colors.red[300];

  static Color myColorShade3 = Colors.orange[300];

  static Color myColorShade4 = Colors.purple[300];

  static Color myColorShade5 = Colors.purpleAccent[300];

  static Color myColorShade6 = Colors.pink[300];

  static Color myColorShade7 = Colors.white;

  /*Landing page styles*/

  static double landingPageIconSize=30.0;

  static Color landingPageBackgroundColor = Colors.white;

  static Color landingPageMenuIconColor = Colors.red;

  //static Color landingPageMenuIconTextColor = Colors.red;




  static TextStyle textTheme1 = TextStyle(color: Colors.green);

  static TextStyle textTheme2 = TextStyle(color: Colors.white);

 static Decoration  boxDecoration1 = BoxDecoration(
//     boxShadow: <BoxShadow>[
//       BoxShadow(
//           color: Colors.grey[200],
//           blurRadius: 15.0,
//           offset: Offset(0.0, 0.4)
//       )
//     ],
//     color: Colors.white

 );


 static Decoration gradientFill1 =BoxDecoration(
  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
  gradient: LinearGradient(
  colors: [Colors.amber, Colors.cyan],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,)
  );



}

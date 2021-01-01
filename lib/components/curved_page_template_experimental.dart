import 'package:flutter/material.dart';

class CurvedPageTemplateExperimental extends StatelessWidget {
  CurvedPageTemplateExperimental({this.curvedChild,this.titleBold,this.titleLight});

  final Widget curvedChild;
  final String titleBold;
  final String titleLight;

  @override
  Widget build(BuildContext context) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[

        Container(
          //sheight: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/appbg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

//              Padding(
//                padding: EdgeInsets.only(top: 15.0, left: 10.0),
////            child: Row(
////              mainAxisAlignment: MainAxisAlignment.spaceBetween,
////              children: <Widget>[
////                IconButton(
////                  icon: GestureDetector(  onTap: (){
////                    Navigator.pop(context);
////                  },child: Icon(Icons.arrow_back_ios)),
////                  color: Colors.white,
////                  onPressed: () {},
////                ),
////                Container(
////                    width: 125.0,
////                    child: Row(
////                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
////                      children: <Widget>[
////                        IconButton(
////                          icon: Icon(Icons.filter_list),
////                          color: Colors.white,
////                          onPressed: () {},
////                        ),
////                        IconButton(
////                          icon: Icon(Icons.menu),
////                          color: Colors.white,
////                          onPressed: () {},
////                        )
////                      ],
////                    ))
////              ],
////            ),
//              ),
//              SizedBox(height: 35.0),
//              Padding(
//                padding: EdgeInsets.only(left: 40.0),
//                child: Row(
//                  children: <Widget>[
//                    Text(titleBold,
//                        style: TextStyle(
//                            fontFamily: 'Montserrat',
//                            color: Colors.white,
//                            fontWeight: FontWeight.bold,
//                            fontSize: 25.0)),
//                    SizedBox(width: 10.0),
//                    Text(titleLight,
//                        style: TextStyle(
//                            fontFamily: 'Montserrat',
//                            color: Colors.white,
//                            fontSize: 25.0))
//                  ],
//                ),
//              ),
              SizedBox(height: 40.0),
              Container(
//            height: MediaQuery.of(context).size.height - 160.0,
                //height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)/*,topRight: Radius.circular(75.0)*/),
                  ),
                  child: curvedChild
              ),





            ],

          ),
        )


      ],


    );
  }
}
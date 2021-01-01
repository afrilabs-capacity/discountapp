import 'package:flutter/material.dart';

class HeaderTemplate extends StatelessWidget {
  HeaderTemplate({this.titleBold,this.titleLight});


  final String titleBold;
  final String titleLight;

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.red,
//      decoration: BoxDecoration(
//        image: DecorationImage(
//          image: NetworkImage('https://www.hopefornigeriaonline.com/wp-content/uploads/2018/01/shopping-2613984_640.jpg'),
//          fit: BoxFit.cover,
//        ),
//      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0),
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
                Container(
                    width: 125.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.filter_list),
                          color: Colors.white,
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.menu),
                          color: Colors.white,
                          onPressed: () {},
                        )
                      ],
                    ))
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Padding(
            padding: EdgeInsets.only(left: 40.0),
            child: Row(
              children: <Widget>[
                Text(titleBold,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0)),
                SizedBox(width: 10.0),
                Text(titleLight,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 25.0))
              ],
            ),
          ),
          SizedBox(height: 40.0),
        ],

      ),
    );
  }
}
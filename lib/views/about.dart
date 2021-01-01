import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/styles/styles.dart';
import 'package:flutter_todo/utils/constants.dart';
import 'dart:math';




class About extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.green,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              MyNavigation(),
              //CircularSection(),
              PageLayout(data: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 0,),
                Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)/*,topRight: Radius.circular(75.0)*/),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage("$siteUrl/gallery/n7.jpg"),
                    ),
                  ),
                ),
                //Image.network("$siteUrl/gallery/n7.jpg"),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                    child: Container( child: Text('Youth life can be awesome. Whether you’re staying at home or living-it-up in a student flat, you’re gonna want to budget so you have enough money to save.',style: Styles.textTheme2),)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                  child: Center(child: Container( child: Text('Naija Green Card gets you access to thousands of exclusive discounts, making epic experiences with your mates more possible. For just ₦ 2,000 you get year round discounts with top brands, accessible right on your phone.',style: Styles.textTheme2,),)),
                )
              ],),)
              //PartnerListMenu()
            ]),
      ),
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
            Text('About Us!!',style: TextStyle(color:Colors.white,fontSize: 30.0),),
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
    return Expanded(
      child: Container(
        // height: MediaQuery.of(context).size.height-140,
        decoration: BoxDecoration(
          //color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)/*,topRight: Radius.circular(75.0)*/),

        ), child: data, ),
    );
  }
}


class CircularSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child: ClipPath(
        clipper: CurvedBottomClipper(),
        child: Container(
          width: double.infinity,
          color: Colors.white,
          height: 100.0,
          child: Text('Welcome')
        ),
      ),
    );
  }
}


class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // I've taken approximate height of curved part of view
    // Change it if you have exact spec for it
    final roundingHeight = size.height * 3 / 5;
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


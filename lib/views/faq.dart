import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/utils/constants.dart';
import 'package:flutter_todo/providers/user.dart';
import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/providers/album.dart';
import 'package:flutter_todo/styles/styles.dart';
import 'package:flutter_todo/models/photo.dart';
import 'package:flutter_todo/utils/validate.dart';
import 'package:flutter_todo/views/support_thank_you.dart';

class FrequentlyAsked extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return  SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.green,
        body:  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              MyNavigation(),
              PageLayout(data: Center(
                child:  ListView(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 30,),
                    QuestionCard(header: 'What can i do with my naijagreencard?',body: ''
                        'Our card is a premium discount card offering discounts from over 3000 partners nationwide.',),
                    SizedBox(height: 5,),
                    QuestionCard(header: 'How much is the naijagreencard?',body: ''
                        'The cost of the card is N2,000, this is void of delivery charges, delivery costs an extra N500.',),
                    SizedBox(height: 5,),
                    QuestionCard(header: 'What if a partner rejects my naijagreencard?',body: ''
                        'We have tidied especially with consenting partners and do not expect any of our esteemed partners to go back on our agreement, however if this is the case with you please reach us for further investigation.',),
                    SizedBox(height: 5,),
                    QuestionCard(header: 'What are your payment options?',body: ''
                        'We support a vast array of payment options, ranging from card payment to bank transfer. These features are clearly laid-out as you progress through your registration on our platform.',),


                  ],),




              ),)

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
    return   Row(
      children: <Widget>[
        IconButton(
          icon: GestureDetector(  onTap: (){
            Navigator.pop(context);
          },child: Icon(Icons.arrow_back_ios)),
          color: Colors.white,
          onPressed: () {},
        ),
        Text('FAQ',style: TextStyle(color:Colors.white,fontSize: 30.0),),
      ],
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
        child:  Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height-140,
            decoration: BoxDecoration(
              color: Colors.green[600],
              borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)/*,topRight: Radius.circular(75.0)*/),

            ), child: data, ),
        )
    );
  }
}




class QuestionCard extends StatelessWidget {
  final String header;
  final String body;
  QuestionCard({this.header,this.body});
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
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
            SizedBox(height: 5,),
            Text('$body',style: Styles.lightText2),
          ],
        ),
      ),
    );
  }
}
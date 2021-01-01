import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/views/loading.dart';


class SupportThanks extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return  SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.green,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            MyNavigation(),
            PageLayout(data: Center(
                child: Container( padding: EdgeInsets.all(20.0), child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.markunread,color: Colors.green[200],size: 150,),
                    Text('Message Sent',style: TextStyle(color: Colors.white,fontSize: 40.0),),
                    Text('Thanks for reaching out!! We do our best to respond to inquiries between 24-48hrs depending on cued requests.',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
                    SizedBox(height: 40,),
                    Builder(
                      builder: (context) =>ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width-20,
                        height: 50,
                        buttonColor: Colors.red,
                        child: RaisedButton(
                            onPressed: (){
                              Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context)=>Loading()));
                            },
                            child: Text("Okay",style: TextStyle(color: Colors.white),)
                        ),
                      ),
                    ),


                  ],
                ),)

            ),)

          ],
        ),
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
            SizedBox(height: 30,)
//            IconButton(
//              icon: GestureDetector(  onTap: (){
//                Navigator.pop(context);
//              },child: Icon(Icons.arrow_back_ios)),
//              color: Colors.white,
//              onPressed: () {},
//            ),
          //  Text('Success',style: TextStyle(color:Colors.white,fontSize: 30.0),),
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


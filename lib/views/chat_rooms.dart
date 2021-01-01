import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/views/chat_page.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/providers/user.dart';
import 'package:flutter_todo/utils/constants.dart';
import 'package:flutter_todo/utils/validate.dart';
import 'package:flutter_todo/styles/styles.dart';
import 'package:flutter_todo/views/landing_page.dart';
import 'package:flutter_todo/models/state.dart';

class ChatRoom extends StatefulWidget {

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom > {

  UserProvider _userProvider;

  Future<void>init(context)  async{
    _userProvider =  Provider.of<UserProvider>(context);
  }

  MyState myState= new MyState();

  @override
  Widget build(BuildContext context) {

    return  SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.green[600],
        appBar: AppBar(
            automaticallyImplyLeading: true,
            title: const Text('Chat Rooms',style: TextStyle(color: Colors.green),),
            iconTheme: IconThemeData(color: Colors.green),
            backgroundColor: Colors.white,
            leading: IconButton(icon:Icon(Icons.arrow_back),
              onPressed:() => Navigator.pop(context, false),
            ),actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.home,
              color: Colors.green,
            ),
            onPressed: () {
              Navigator.pushReplacement(context, PageRouteBuilder(
                transitionDuration: Duration(seconds: 0),
                pageBuilder: (context, animation1, animation2) => LandingPage(),
              ));
            },
          )
        ]),

        body: Column(
          children: <Widget>[
            SizedBox(height: 20,),
            //Text('Select chat room to continue '),
            SizedBox(height: 20,),
          Expanded(
            child:ListView.builder(
              itemCount:myState.states.length ,
              itemBuilder: (context, index) => RoomCard(header:myState.states[index].state,body: '',state:myState.states[index])
              ,
            ),

          )
        ],
        ),
      ),
    );
    //,);
    //);


    //return  consumer;
  }

  @override
  void dispose() {
   // _deliveryController.dispose();
    super.dispose();
  }



}


class RoomCard extends StatelessWidget {
  final String header;
  final String body;
  final MyState state;
  RoomCard({this.header,this.body,this.state});
  @override
  Widget build(BuildContext context) {
    return  Container(
      width:double.infinity,
      padding: const EdgeInsets.symmetric( horizontal: 25.0,vertical: 18.0),
      margin: EdgeInsets.symmetric(horizontal: 12,vertical: 10),
      decoration: BoxDecoration(
        //color: Colors.grey[100],
//        borderRadius: BorderRadius.only( topLeft: Radius.circular(5.0),
//          bottomLeft: Radius.circular(5.0),
//          bottomRight: Radius.circular(10.0),),
      color: Colors.white,
        boxShadow: [
        BoxShadow(
        color: Colors.black26,
        blurRadius: 1.0, // soften the shadow
        spreadRadius: 1.0, //extend the shadow
        offset: Offset(
          0.0, // Move to right 10  horizontally
          2.0, // Move to bottom 5 Vertically
        ),
      )
        ]
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('$header',style: TextStyle(fontSize: 18.0,color: Colors.red),),
          Container(
            padding: const EdgeInsets.symmetric( horizontal: 12.0,vertical: 8.0),
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only( topLeft: Radius.circular(5.0),
                  bottomLeft: Radius.circular(5.0),
                  bottomRight: Radius.circular(10.0),)
            ),
            child: GestureDetector(
              onTap: ()=> Navigator.push(context, PageRouteBuilder(
                transitionDuration: Duration(seconds: 0),
                pageBuilder: (context, animation1, animation2) => ChatPage(myState:state,),
              )),
              child: Row(
                children: <Widget>[
                  Icon(Icons.chat,color: Colors.white,),
                  SizedBox(width: 5,),
                   Text('Chat',style: Styles.textTheme2,)
                ],
              )),
            ),


          //Text('$body',style: Styles.lightText2),
        ],
      ),
    );
  }
}
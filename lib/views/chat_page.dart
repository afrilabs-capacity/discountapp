import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/models/user.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/providers/user.dart';
import 'package:flutter_todo/providers/chat.dart';
import 'package:flutter_todo/utils/constants.dart';
import 'package:flutter_todo/utils/validate.dart';
import 'package:flutter_todo/styles/styles.dart';
import 'package:flutter_todo/views/landing_page.dart';
import 'package:flutter_todo/models/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class ChatPage extends StatefulWidget {

  MyState myState;
  ChatPage({this.myState});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  UserProvider _userProvider;

  final firestore = Firestore.instance;

  Future<void>init(context)  async{
    _userProvider =  Provider.of<UserProvider>(context);
  }



  TextEditingController messageController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    Provider.of<ChatProvider>(context,listen: false).clearQuote();

    return  SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        //backgroundColor: Colors.green[600],
        appBar: AppBar(
            automaticallyImplyLeading: true,
            title:  Text('${widget.myState.state} (Partners Room)',style: TextStyle(color: Colors.green),),
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

        body: Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(image: new AssetImage("assets/images/chat_bg.jpg"), fit: BoxFit.cover,),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
          Consumer<UserProvider>(
          builder:(context,data,child)=>
              MessagesStream(myState: widget.myState,)),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Consumer<ChatProvider>(
                      builder:(context,data,child)=>
                      data.quote!=null?
                      Stack(children: <Widget>[
                        QuoteMessageBubble(sender: data.sender,text: data.quote,),
                        Align(
                            alignment: Alignment(0.9,-1.8),
                            child: GestureDetector(
                                onTap: (){
                                  data.clearQuote();
                                   setState(() {
                                   });
                                },
                                child: Icon(Icons.close,color: Colors.red,)))
                      ],):SizedBox()
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                    //color: Colors.red,
                    decoration: BoxDecoration(
                        color: Colors.white
                    ),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.0,vertical: 8.0),
                          child: Container(
                            //height: 45,
                            width: 300,
                            child: TextFormField(
                              controller:  messageController,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.done,
                              maxLines: null,
                              minLines: null,
                              //expands: true,
                              //controller: _deliveryController,
                              decoration: Styles.flatFormFieldsNoBorder.copyWith(
                                  filled: true,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 15,horizontal: 5),
                                  isDense: true,
                                  fillColor: Colors.grey[200],
                                  labelText: 'Enter text here',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  labelStyle: TextStyle(
                                      color: Colors.black26
                                  ),
                                  focusColor: Colors.pink
                              ),
                            ),
                          ),
                        ),
                        Consumer<UserProvider>(
                          builder:(context,data,child)=> GestureDetector(
                              onTap: (){

                                final chatProvider=Provider.of<ChatProvider>(context);

                                if(data.userAuthenticated.isEmpty)
                                  return;
                                final sender = data.userAuthenticated['account_type']=='student' ? data.userAuthenticated['name']:
                                data.userAuthenticated['account_type']=='admin'? 'Admin':
                                data.userAuthenticated['account_type']=='partner'? 'Partner':'';

                                final senderType = data.userAuthenticated['account_type']=='student' ? 'card_holder':
                                data.userAuthenticated['account_type']=='admin'? 'Admin':
                                data.userAuthenticated['account_type']=='partner'? 'Happy Bites':'';

                                if(messageController.text!=null && messageController.text!=''){
                                  firestore.collection('${widget.myState.id.toString()}').add({
                                    'text': messageController.text,
                                    'sender':sender,
                                    'type':senderType,
                                    'email':data.userAuthenticated['email'],
                                    'quote':{
                                      'is_quote':chatProvider.quote!=null?true:false,
                                      'sender':chatProvider.quote!=null?chatProvider.sender:null,
                                      'text':chatProvider.quote!=null?chatProvider.quote:null,
                                    },
                                    'created': FieldValue.serverTimestamp()
                                  }).then((ref){
                                    messageController.clear();
                                    if(Provider.of<ChatProvider>(context,listen: false).quote!=null)
                                      Provider.of<ChatProvider>(context,listen: false).clearQuote();
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    setState(() {

                                    });
                                  });
                                }


                              },

                              child: Icon(Icons.send,color: Colors.green,size: 38,)),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
    //,);
    //);


    //return  consumer;
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }



}




class MessagesStream extends StatelessWidget {
  final firestore = Firestore.instance;

  MyState myState;
  MessagesStream({this.myState});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('${myState.id.toString()}').orderBy('created', descending: false).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.green[600],
            ),
          );
        }
        final messages = snapshot.data.documents.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data['text'];
          final messageSender = message.data['sender'];
          final messageType = message.data['type'];
          final messageEmail = message.data['email'];
          final messageQuote = message.data['quote'];

          print(message.reference.documentID);

          final currentUser = 'braimahjake@gmail.com';

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            messageType: messageType,
            messageEmail: messageEmail,
            quote:messageQuote ,
          );

          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}


class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.messageType,this.messageEmail,this.quote});

  final String sender;
  final String text;
  final String messageType;
  final String messageEmail;
  Map<String,dynamic> quote;


  @override
  Widget build(BuildContext context) {

    print(messageEmail);

    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Consumer<UserProvider>(
        builder:(context,data,child)=> Column(
          crossAxisAlignment:
          data.userAuthenticated['email']==messageEmail ? CrossAxisAlignment.end: CrossAxisAlignment.start,
          children: <Widget>[

            if(!quote['is_quote'])
            MessageSender(sender: sender,messageEmail: messageEmail,messageType: messageType,),

            if(!quote['is_quote'])
            Material(
              borderRadius:data.userAuthenticated['email']==messageEmail
                  ? BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0))
                  : BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              elevation: 5.0,
              color: data.userAuthenticated['email']==messageEmail  ? Colors.green[600]: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: MessageBody(sender: sender,messageEmail: messageEmail,messageType: messageType,text: text,),
              ),
            ),
            if(quote['is_quote'])
            QuoteMessageBubble(sender:quote['sender'],text: quote['text'] ,quoteReplyText: text,quoteReplySender: sender,),

          ],



        ),
      ),
    );
  }
}




class QuoteMessageBubble extends StatelessWidget {
  QuoteMessageBubble({this.sender, this.text,this.quoteReplyText,this.quoteReplySender});

  final String sender;
  final String text;
  final String quoteReplyText;
  final String quoteReplySender;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onLongPress: (){
        Provider.of<ChatProvider>(context).setQuote(quoteReplyText,quoteReplySender);
      },
      child: Consumer<UserProvider>(
        builder:(context,data,child)=> Column(
          crossAxisAlignment: CrossAxisAlignment.end,
         // data.userAuthenticated['email']==messageEmail ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.only(
                  //topLeft: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  //bottomRight: Radius.circular(30.0)),
                  topRight: Radius.circular(30.0),
                ),
                //elevation: 5.0,
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
                    child: Text('$sender',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17),),
                  ),
                  Container(

                      width: double.infinity-20,
                      color: Colors.grey[800],
                      child: Padding(
                          padding:EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                          child: Text('$text',style: Styles.textTheme2,)))
                ],
              )
            ),

            if(quoteReplySender!=null)
            Container(
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                  ),
                  //elevation: 5.0,
                ),
              width: double.infinity-20,
                //color: Colors.grey[600],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 5,),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 20.0),
                    child: Text('Reply by $quoteReplySender',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
                  ),
                  Padding(
                      padding:EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
                      child: Text('$quoteReplyText',style: Styles.textTheme2,)),
                    SizedBox(height: 7,),

                ],)
            ),
          ],
        ),
      ),
    );
  }
}


class MessageSender extends StatelessWidget {
  final String text;
  final String sender;
  final String messageType;
  final String messageEmail;
  MessageSender({this.text,this.messageType,this.messageEmail,this.sender});


  @override
  Widget build(BuildContext context) {

    String textToCopy=Provider.of<UserProvider>(context).userAuthenticated.isNotEmpty?
    Provider.of<UserProvider>(context).userAuthenticated['email']==messageEmail ? 'Me':
    messageType=='card_holder'? '$sender (Card Holder)':sender:
    'jeo';

    return  Container(
      child: Text(textToCopy,
        style: TextStyle(
          fontSize: 12.0,
          color: Colors.white,
        ),

      ),
    );
  }
}


class MessageBody extends StatelessWidget {
  final String text;
  final String sender;
  final String messageType;
  final String messageEmail;
  MessageBody({this.text,this.messageType,this.messageEmail,this.sender});


  @override
  Widget build(BuildContext context) {

    String textToCopy=text;

    String senderText=Provider.of<UserProvider>(context).userAuthenticated.isNotEmpty?
    Provider.of<UserProvider>(context).userAuthenticated['email']==messageEmail ? 'Me':
    messageType=='card_holder'? '$sender (Card Holder)':sender:
    'jeo';

    return  Consumer<UserProvider>(
        builder:(context,data,child)=>Container(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Text(textToCopy,
            style: TextStyle(
              color: data.userAuthenticated['email']==messageEmail  ? Colors.white : Colors.black54,
              fontSize: 15.0,
            )

        ),
        onLongPress: () {
          //Clipboard.setData(new ClipboardData(text: textToCopy));
          Provider.of<ChatProvider>(context).setQuote(textToCopy, senderText);
        },
      ),
    ));
  }
}



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/views/admin/admin_partners.dart';
import 'package:flutter_todo/views/admin/admin_add_partner.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/providers/partner.dart';



class AdminPartnerMenu extends StatefulWidget {
  @override
  _AdminPartnerMenuState createState() => _AdminPartnerMenuState();
}

class _AdminPartnerMenuState extends State<AdminPartnerMenu> {

  AuthProvider _provider;

  PartnerProvider _partnerProvider;

  @override
  void didChangeDependencies() {
    _provider =  Provider.of<AuthProvider>(context,listen: false);
    _partnerProvider =  Provider.of<PartnerProvider>(context,listen: false);
    _partnerProvider.initPartners(_provider);
    super.didChangeDependencies();

  }

  @override
  Widget build(BuildContext context) {
    print('rebuilding');
//    final userAvatarWidget =
//    Center(
//        child: CircleAvatar(
//          backgroundColor: Colors.green,
//          backgroundImage:  NetworkImage("$siteUrl/uploads/card_holders/card_holders$_userAvatar"),
//          radius: MediaQuery.of(context).size.width/12,
//        ));

    return  Scaffold(
      resizeToAvoidBottomInset: false,
      //backgroundColor: Color(0xFF21BFBD),
      //backgroundColor: Colors.green,
      //backgroundColor: Colors.green,
//      appBar: AppBar(
//        title: const Text('Go Back',style: TextStyle(color: Colors.green),),
//        iconTheme: IconThemeData(color: Colors.green),
//        backgroundColor: Colors.white,
//
//      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child:  Container(
                color: Colors.green,
                child: Padding(
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
                        Text('',style: TextStyle(color:Colors.white,fontSize: 30.0),),
                      ],
                    )
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                color: Colors.green,
                child: Consumer<PartnerProvider>(
                  builder:(context,data,child)=> Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Partners',style: TextStyle(color: Colors.white,fontSize: 30.0),),
                      !data.loaded?
                      Text('0',style: TextStyle(color: Colors.white,fontSize: 60.0,fontWeight: FontWeight.bold),):
                      Text('${data.paginate.total}',style: TextStyle(color: Colors.white,fontSize: 60.0,fontWeight: FontWeight.bold),)

                    ],
                  ),
                ),),
            ),
            Expanded(
              flex: 7,
              child: Column(
                children: <Widget>[
              SizedBox(height: 50,),
                  SizedBox(
                    width: 230,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                              child: Divider()
                          ),

                          Text("Menu"),

                          Expanded(
                              child: Divider()
                          ),
                        ]
                    ),
                  ),
                  SizedBox(height: 35.0,),
                  SizedBox(
                    width: 250,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>AdminAddPartner(action: 'create',)));
                          },
                          child: Column(
                            children: <Widget>[
                              Icon(Icons.person_add,color: Colors.green,size: 40.0,),
                              Text('Add Partner',style: TextStyle(color: Colors.green),)

                            ],
                          ),
                        ),

                        GestureDetector(
                          onTap: (){
                            //Navigator.push(context,MaterialPageRoute(builder: (context)=>Login()));
                          },
                          child:  GestureDetector(
                            onTap: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>AdminPartners()));
                            },
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.remove_red_eye,color: Colors.green,size: 40.0,),
                                Text('View Partners',style: TextStyle(color: Colors.green),)

                              ],
                            ),
                          ),
                        ),



                      ],
                    ),
                  ),
                  SizedBox(height: 30.0,),

                ],
              ),
            )
          ],
        ),
      ),


    );

  }




}


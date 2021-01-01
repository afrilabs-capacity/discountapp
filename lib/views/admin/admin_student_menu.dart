import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/views/admin/admin_card_holders.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/providers/student.dart';
import 'package:flutter_todo/providers/auth.dart';



class AdminStudentMenu extends StatefulWidget {
  @override
  _AdminStudentMenuState createState() => _AdminStudentMenuState();
}

class _AdminStudentMenuState extends State<AdminStudentMenu> {

  AuthProvider _provider;

  StudentProvider _studentProvider;

  @override
  void didChangeDependencies() {
    _provider =  Provider.of<AuthProvider>(context,listen: false);
    _studentProvider =  Provider.of<StudentProvider>(context,listen: false);
    _studentProvider.initStudents(_provider);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      resizeToAvoidBottomInset: false,
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
                child: Consumer<StudentProvider>(
                  builder:(context,data,child)=> Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Card Holders',style: TextStyle(color: Colors.white,fontSize: 30.0),),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
//                        GestureDetector(
//                          onTap: (){
//                            Navigator.push(context,MaterialPageRoute(builder: (context)=>AdminAddPartner(action: 'create',)));
//                          },
//                          child: Column(
//                            children: <Widget>[
//                              Icon(Icons.person_add,color: Colors.green,size: 40.0,),
//                              Text('Add Partner',style: TextStyle(color: Colors.green),)
//
//                            ],
//                          ),
//                        ),

                        GestureDetector(
                          onTap: (){
                            //Navigator.push(context,MaterialPageRoute(builder: (context)=>Login()));
                          },
                          child:  GestureDetector(
                            onTap: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>AdminCardHolders()));
                            },
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.remove_red_eye,color: Colors.green,size: 40.0,),
                                Text('View Card Holders',style: TextStyle(color: Colors.green),)

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


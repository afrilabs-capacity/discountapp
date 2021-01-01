import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/models/student.dart';
import 'package:flutter_todo/styles/styles.dart';
import 'package:flutter_todo/utils/validate.dart';
import 'package:flutter_todo/models/state.dart';
import 'package:flutter_todo/models/category.dart';
import 'package:flutter_todo/models/discount.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/providers/student.dart';
import 'package:flutter_todo/providers/partner.dart';
import 'package:flutter_todo/views/admin/admin_single_partner.dart';
import 'package:flutter_todo/views/admin/admin_single_student.dart';


class AdminCardHolders extends StatefulWidget {
  @override
  _AdminCardHoldersState createState() => _AdminCardHoldersState();
}

class _AdminCardHoldersState extends State<AdminCardHolders> {


  AuthProvider _provider;

  StudentProvider _studentProvider;

  @override
  void didChangeDependencies() {
    print('we here');
    _provider =  Provider.of<AuthProvider>(context,listen: false);
    _studentProvider =  Provider.of<StudentProvider>(context,listen: false);
    _studentProvider.initStudents(_provider);
    super.didChangeDependencies();
  }


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
              Expanded(child: PageLayout(data: Column(children: <Widget>[
                MyFilter(_provider),
                SizedBox(height: 5.0,),
                StudentListMenu(),
                StudentList( _provider)

              ],),))
              //PartnerListMenu()
            ]),
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
            Text('Card Holders!!',style: TextStyle(color:Colors.white,fontSize: 30.0),),
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
    return Container(
      // height: MediaQuery.of(context).size.height-140,
      decoration: BoxDecoration(
        color: Colors.green[600],
        borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)/*,topRight: Radius.circular(75.0)*/),

      ), child: data, );
  }
}



class MyFilter extends StatefulWidget {

  AuthProvider  _provider;

  MyFilter(this._provider);

  @override
  _MyFilterState createState() => _MyFilterState();
}

class _MyFilterState extends State<MyFilter> {

  /* Instantiate MyState*/
  MyState myState= MyState();

  /* Instantiate MyCategory*/
  MyCategory myCategory= MyCategory();

  /* Instantiate MyCategory*/
  MyDiscount myDiscount= MyDiscount();

  /*business name search*/
  TextEditingController studentNameController = TextEditingController();

  /*payment reference*/
  TextEditingController referenceController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    //businessNameController.text="Happy Bites";
    //return Container(child:Text('hi there') ,);
    return  Consumer<StudentProvider>(
      builder: (context,data,child)=>Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:  BorderRadius.only(topLeft: Radius.circular(75.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black54,
                      blurRadius: 15.0,
                      offset: Offset(0.0, 0.4)
                  )
                ]
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all( 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Showing",
                              style: Styles.p,
                            ),
                            TextSpan(
                              text: ' (',
                              style: Styles.darkText1,
                            ),
                            TextSpan(
                              text: ' ${data.students!=null ? data.students.length : 0 } ',
                              style: Styles.themeColor2,
                            ),
                            TextSpan(
                              text: ') ',
                              style: Styles.darkText1,
                            ),
                            TextSpan(
                              text: 'of',
                              style: Styles.p,
                            ),
                            TextSpan(
                              text: ' (',
                              style: Styles.darkText1,
                            ),
                            TextSpan(
                              text: ' ${data.paginate!=null ? data.paginate.total.toString() : 0 }',
                              style: Styles.themeColor2,
                            ),
                            TextSpan(
                              text: ' )',
                              style: Styles.darkText1,
                            ),
                            TextSpan(
                              text: ' results',
                              style: Styles.p,
                            ),
                          ],
                        ),
                      ),

                      // Text('Showing (${data.partners!=null ? data.partners.length : 0 }) of (${data.paginate!=null ? data.paginate.total.toString() : 0 }) results',style: TextStyle(fontSize: 16.0),),
                      //Text('Deals!!',style: TextStyle(color:Colors.green,fontSize: 30.0),),
                      Row(

                        children: <Widget>[
                          Text('filter',style: TextStyle(color:Colors.black),),
                          GestureDetector(
                              onTap: (){
                                setState(() {
                                  data.showFilter=!data.showFilter;
                                });
                              },
                              child: Icon(Icons.sort,color:Colors.pink,))
                        ],
                      )
                    ],
                  ),
                ),

//                Padding(
//                  padding: const EdgeInsets.only(bottom: 8.0),
//                  child: Container(
//                    decoration: BoxDecoration(
//                      //color: Colors.grey[200],
//                        borderRadius: BorderRadius.all(Radius.circular(25.0))
//                    ),
//
//                    // padding: EdgeInsets.all(10.0),
//                    //margin: EdgeInsets.symmetric(horizontal: 15.0),
//                    child:  Text("Search here",textAlign: TextAlign.left,style:Styles.darkText1.copyWith(fontWeight: FontWeight.w500),),
//
//                  ),
//                ),

                if (data.showFilter)

                  Padding(
                    padding: const EdgeInsets.symmetric( horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        DropdownButton<String>(
                          isExpanded:true,
                          //underline: Text(''),
                          icon: Icon(Icons.keyboard_arrow_down),
                          underline: Container(color:data.dropDownValidation_1, height:1.0),
                          hint: Text('State',style: TextStyle(color: Colors.black)),
                          value: data.selectedState,
                          items: myState.states.map<DropdownMenuItem<String>>( (value)=> DropdownMenuItem<String>(child:
                          Text(value.state,style: TextStyle(color: Colors.black),),value:value.id.toString(),)  ).toList(),
                          //DropdownMenuItem(child: Text('USD',style: TextStyle(color: Colors.black),),value:'USD' ,),

                          onChanged:(value){
                            setState(() {
                              data.selectedState=value;
                              //validateIdTypeField();
                            });
                          } ,

                        ),


                      ],
                    ),
                  ),

                if (data.showFilter)  SizedBox(height: 5.0 )
                else
                  SizedBox(height: 8.0 ),

                if (data.showFilter)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 45,
                      child: TextFormField(
                        controller:  studentNameController,
                        //controller: _deliveryController,
                        decoration: Styles.flatFormFieldsRounded.copyWith(
                            filled: true,
                            fillColor: Colors.grey[200],
                            labelText: 'Student Name',
                            labelStyle: TextStyle(
                                color: Colors.black
                            ),
                            focusColor: Colors.pink
                        ),
                      ),
                    ),
                  ),
                if (data.showFilter)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 45,
                      child: TextFormField(
                        controller:  referenceController,
                        //controller: _deliveryController,
                        decoration: Styles.flatFormFieldsRounded.copyWith(
                            filled: true,
                            fillColor: Colors.grey[200],
                            labelText: 'Payment Reference',
                            labelStyle: TextStyle(
                                color: Colors.black
                            ),
                            focusColor: Colors.pink
                        ),
                      ),
                    ),
                  ),
                if (data.showFilter)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: ButtonTheme(
                            minWidth: MediaQuery.of(context).size.width-20,
                            height: 40,
                            buttonColor: Colors.green[900],
                            child: GestureDetector(
                              onTap:(){},
                              child: RaisedButton(
                                onPressed: () {
                                  data.studentSearch(widget._provider,reference: referenceController.text,name:studentNameController.text );
                                },
                                child: Text("Search",style: TextStyle(color: Colors.white),),
                              ),
                            ),
                          ),),
                        SizedBox(width: 10.0,),
                        Expanded(
                            child: GestureDetector(
                              onTap:(){
                                data.selectedState=null;
                                if(studentNameController!=null)
                                  studentNameController.clear();
                                if(referenceController!=null)
                                  referenceController.clear();
                                data.initStudents(widget._provider);
                                setState(() {

                                });
                              },
                              child: Row(children: <Widget>[
                                Text('reset'),
                                Icon(Icons.refresh,color: Styles.myColor1,),
                              ],),
                            )
                        ),
                      ],
                    ),
                  )

              ],
            ),
          ),



        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    studentNameController.dispose();
    referenceController.dispose();
    super.dispose();
  }


}



class StudentListMenu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentProvider>(
        builder:(context,data,child)=> data.loaded ? Expanded( flex: 1,  child:   Container(
          //color: Colors.grey[100],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(flex:1, child: Row(
                  children: <Widget>[
                    Flexible(
                        flex:2,
                        child: Text('Title',style: Styles.h2.copyWith(color: Colors.green[100],fontWeight: FontWeight.w400)))
                  ],
                )),
                Expanded(flex:3, child: Row(
                  children: <Widget>[
                    Flexible(child: Center(child: Text('Name',overflow: TextOverflow.ellipsis, style: Styles.h2.copyWith(color: Colors.green[100],fontWeight: FontWeight.w400))))
                  ],
                )),

                SizedBox(width: 5.0,),
                Expanded(flex:2, child: Row(
                  children: <Widget>[
                    Flexible(child: Text('State',style: Styles.h2.copyWith(color: Colors.green[100],fontWeight: FontWeight.w400)))
                  ],
                )),
                Expanded(flex:2, child: Text('Reg.As',style: Styles.h2.copyWith(color: Colors.green[100],fontWeight: FontWeight.w400))),
                Expanded(flex:1, child: Text('',style: Styles.h2.copyWith(color: Colors.green[100],fontWeight: FontWeight.w400))),
                SizedBox(width: 1.0,),
                //Expanded(flex:2, child: Text('Edit',style: TextStyle(fontWeight: FontWeight.bold)))
              ],
            ),
          ),
        ),) : SizedBox()
    );
  }



}


class StudentList extends StatelessWidget {

  AuthProvider  _provider;

  StudentList(this._provider);

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentProvider>(
      builder: (context,data,child)=>Expanded(
          flex: 11,
          child: data.loaded ? NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!data.loadMore && scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                // _loadData();
                // start loading data
                data.loadMoreData( _provider);

              }
            },
            child: ListView.builder(
              itemCount: data.students.length,
              itemBuilder: (context, index) {
                return  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                          ),
                          child: Row(
                            children: <Widget>[
                              SizedBox(),
                              Expanded(flex:1, child: Row(
                                children: <Widget>[
                                  Flexible(flex:2, child: Text('${data.students[index].title}'))
                                ],
                              )),
                              Expanded(flex:4, child: Row(
                                children: <Widget>[
                                  Flexible(child: Text( '${data.students[index].firstName}',style: TextStyle(color: Colors.pink),)),
                                  SizedBox(width: 5,),
                                  Flexible(child: Text( '${data.students[index].lastName}',style: TextStyle(color: Colors.pink),))
                                ],
                              )),


                              Expanded(flex:2, child: Row(
                                children: <Widget>[
                                  Flexible(child: Text('${data.students[index].state['name']}',style: TextStyle(color: Colors.teal)))
                                ],
                              )),
                              Expanded(
                                flex: 2,
                                child:  Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.green,
                                  ),
                                  child: Text('${data.students[index].cardHolderType}',style: Styles.textTheme2,),),
                              ), Expanded(
                                flex:2,
                                child:
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, PageRouteBuilder(
                                      transitionDuration: Duration(seconds: 0),
                                      pageBuilder: (context, animation1, animation2) => AdminSingleStudent(student:data.students[index] ,),
                                    ));
                                    //Navigator.push(context,MaterialPageRoute(builder: (context) => AdminSinglePartner(partner:data.students[index],)));
                                  },
                                  child: Icon(Icons.remove_red_eye,color: Styles.myColor1,)
                                  ,),

                              ),
                              // Expanded(flex:2,child: Icon(Icons.edit,color: Styles.iconColor),),
                            ],
                          ),
                        ),
                        SizedBox(height: 5,)
                        //Divider(),
                      ],
                    )
                );
              },
            ),
          ) : Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('Waiting for card holders.........',style: TextStyle(color: Colors.white),),
              Skeleton(width: MediaQuery.of(context).size.width-20,),
              SizedBox(height: 20,),
              Skeleton(width: MediaQuery.of(context).size.width-30,),
              SizedBox(height: 20,),
              Skeleton(width: MediaQuery.of(context).size.width-40,),
              SizedBox(height: 20,),
              Skeleton(width: MediaQuery.of(context).size.width-50,),
              SizedBox(height: 20,),
              Skeleton(width: MediaQuery.of(context).size.width-60,),
              SizedBox(height: 20,),
            ],)
      ),
    );
  }
}



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/styles/styles.dart';
import 'package:flutter_todo/utils/constants.dart';
import 'package:flutter_todo/utils/validate.dart';
import 'package:flutter_todo/models/state.dart';
import 'package:flutter_todo/models/category.dart';
import 'package:flutter_todo/models/discount.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/providers/partner.dart';
import 'package:flutter_todo/providers/deal.dart';
import 'package:flutter_todo/views/admin/admin_single_partner.dart';




class DealsPage extends StatefulWidget {
  @override
  _DealsPageState createState() => _DealsPageState();
}

class _DealsPageState extends State<DealsPage> {

  AuthProvider _provider;

  DealProvider _partnerProvider;

  @override
  void didChangeDependencies() {
    print('we here');
    _provider =  Provider.of<AuthProvider>(context,listen: false);
    _partnerProvider =  Provider.of<DealProvider>(context,listen: false);
    _partnerProvider.initPartners(_provider);
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
                SizedBox(height: 2.0,),
                PartnerListMenu(),
                PartnerList( _provider)

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
            Text('Browse Deals!!',style: TextStyle(color:Colors.white,fontSize: 30.0),),
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
  TextEditingController businessNameController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    //businessNameController.text="Happy Bites";
    //return Container(child:Text('hi there') ,);
    return  Consumer<DealProvider>(
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
                              text: ' ${data.partners!=null ? data.partners.length : 0 } ',
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

                      //Text('Showing (${data.partners!=null ? data.partners.length : 0 }) of (${data.paginate!=null ? data.paginate.total.toString() : 0 }) results',style: TextStyle(fontSize: 16.0),),
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
                              child: Icon(Icons.sort,color:Colors.pink,)),
                          GestureDetector(
                              onTap: (){
                                data.flipDealsView();
                              },
                              child: data.imageView ? Icon(Icons.list,color:Colors.pink,)  : Icon(Icons.grid_on,color:Colors.pink,)
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      //color: Colors.grey[200],
                        borderRadius: BorderRadius.all(Radius.circular(25.0))
                    ),

                    child:  Text("Search by Business Name, Category, Discount or State",textAlign: TextAlign.left,style: Styles.darkText1.copyWith(fontWeight: FontWeight.w500),),

                  ),
                ),

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
                        DropdownButton<String>(
                          isExpanded:true,
                          underline: Container(color:data.dropDownValidation_1, height:1.0),
                          hint: Text('Discount',style: TextStyle(color: Colors.black)),
                          value: data.selectedDiscount,
                          items: myDiscount.discounts.map<DropdownMenuItem<String>>( (value)=> DropdownMenuItem<String>(child:
                          Text(value.discount.toString(),style: TextStyle(color: Colors.black),),value:value.discount.toString(),)  ).toList(),
                          //DropdownMenuItem(child: Text('USD',style: TextStyle(color: Colors.black),),value:'USD' ,),

                          onChanged:(value){

                            setState(() {
                              data.selectedDiscount=value;
                              //validateIdTypeField();
                            });
                          } ,

                        ),

                        DropdownButton<String>(
                          isExpanded:true,
                          underline: Container(color:data.dropDownValidation_1, height:1.0),
                          hint: Text('Category',style: TextStyle(color: Colors.black)),
                          value: data.selectedCategory,
                          items: myCategory.categories.map<DropdownMenuItem<String>>( (value)=> DropdownMenuItem<String>(child:
                          Text(value.category,style: TextStyle(color: Colors.black),),value:value.id.toString(),)  ).toList(),
                          //DropdownMenuItem(child: Text('USD',style: TextStyle(color: Colors.black),),value:'USD' ,),

                          onChanged:(value){

                            setState(() {
                              data.selectedCategory=value;
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
                        controller:  businessNameController,
                        //controller: _deliveryController,
                        decoration: Styles.flatFormFieldsRounded.copyWith(
                            filled: true,
                            fillColor: Colors.grey[200],
                            labelText: 'Business Name',
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
                            buttonColor: Colors.green,
                            child: GestureDetector(
                              onTap:(){},
                              child: RaisedButton(
                                onPressed: () {
                                  data.partnerSearch(widget._provider, businessNameController.text);
                                },
                                child: Text("Search",style: TextStyle(color: Colors.white),),
                              ),
                            ),
                          ),),
                        SizedBox(width: 10.0,),
                        Expanded(
                            child: GestureDetector(
                              onTap:(){
                                data.selectedCategory=null;
                                data.selectedState=null;
                                data.selectedDiscount=null;
                                if(businessNameController!=null)
                                  businessNameController.clear();
                                data.initPartners(widget._provider);
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
    businessNameController.dispose();
    super.dispose();
  }


}



class PartnerListMenu extends StatefulWidget {
  @override
  _PartnerListMenuState createState() => _PartnerListMenuState();
}

class _PartnerListMenuState extends State<PartnerListMenu> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DealProvider>(
        builder:(context,data,child)=> data.loaded && !data.imageView   ?

        Expanded( flex: 1,  child:   Container(
          //color: Colors.grey[100],
          child:  Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(flex:7, child: Row(
                  children: <Widget>[
                    Flexible(child: Text('Business Name',style: Styles.h2.copyWith(color: Colors.green[100],fontWeight: FontWeight.w400)))
                  ],
                )),
                Expanded(flex:4, child: Row(
                  children: <Widget>[
                    Flexible(child: Text( 'Category',style: Styles.h2.copyWith(color: Colors.green[100],fontWeight: FontWeight.w400),))
                  ],
                )),
                SizedBox(width: 5.0,),
                Expanded(flex:4, child: Row(
                  children: <Widget>[
                    Flexible(child: Text('State',style: Styles.h2.copyWith(color: Colors.green[100],fontWeight: FontWeight.w400)))
                  ],
                )),
                Expanded(flex:2, child: Text('View',style: Styles.h2.copyWith(color: Colors.green[100],fontWeight: FontWeight.w400))),
                SizedBox(width: 1.0,),
                //Expanded(flex:2, child: Text('Edit',style: TextStyle(fontWeight: FontWeight.bold)))
              ],
            ),
          )
        ),) : SizedBox()
    );
  }



}


class PartnerList extends StatelessWidget {

  AuthProvider  _provider;

  PartnerList(this._provider);

  @override
  Widget build(BuildContext context) {
    return Consumer<DealProvider>(
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
              itemCount: data.partners.length,
              itemBuilder: (context, index) {
                return  !data.imageView ?  Padding(
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
                              Expanded(flex:7, child: Row(
                                children: <Widget>[
                                  Flexible(child: Text('${data.partners[index].nameOfBusiness}'))
                                ],
                              )),
                              Expanded(flex:4, child: Row(
                                children: <Widget>[
                                  Flexible(child: Text( '${data.partners[index].category['name']}',style: TextStyle(color: Colors.pink),))
                                ],
                              )),

                              Expanded(flex:4, child: Row(
                                children: <Widget>[
                                  Flexible(child: Text('${data.partners[index].state['name']}',style: TextStyle(color: Colors.teal)))
                                ],
                              )),
                              Expanded(flex:2, child: GestureDetector(
                                  onTap: (){
                                    Navigator.push(context,MaterialPageRoute(builder: (context) => AdminSinglePartner(partner:data.partners[index],)));
                                  },
                                  child: Icon(Icons.remove_red_eye,color: Styles.myColor1,))),

                            ],
                          ),

                        ),
                        SizedBox(height: 5,)
                        //Divider(),
                      ],
                    )
                ) : GestureDetector(
                  onTap: ()=> Navigator.push(context,MaterialPageRoute(builder: (context) => AdminSinglePartner(partner:data.partners[index],))),
                  child: Container(
                    padding: EdgeInsets.all(25.0),
                    child: Container(
                      padding: EdgeInsets.only(bottom: 25.0),
                      //margin: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.black54,
                                blurRadius: 15.0,
                                offset: Offset(0.0, 0.4)
                            )
                          ],
                          color: Colors.white

                      ),
                      //color:Colors.grey[200],
                      child: Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Image.network('$siteUrl/categories/${data.partners[index].category['id']}/${data.partners[index].categoryImage}'),
                              Align(
                                alignment:Alignment(1.0, 1.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(25),bottomRight:Radius.circular(25) )
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 17.0,horizontal: 10.0),
                                  child: Text('${data.partners[index].discount}% off',style: TextStyle(color: Colors.white),),
                                ),
                              )
                            ],
                          ),


                          SizedBox(height: 10.0,),
                          Text('${data.partners[index].nameOfBusiness}',style: TextStyle(fontSize: 23.0,color: Colors.green)),
                          Column(

                            children: <Widget>[
                              SizedBox(height: 10.0,),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.location_on,color: Colors.green),
                                  SizedBox(width: 5.0,),
                                  Text('${data.partners[index].businessLocation}',style: TextStyle(color: Colors.black54),)
                                ],
                              ),
                              SizedBox(height: 10.0,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.phone,color: Colors.green),
                                  SizedBox(width: 5.0,),
                                  Text('${data.partners[index].phone}',style: TextStyle(color: Colors.black54),),

                                ],
                              ),
                              SizedBox(height: 7.0,),
                              Text('${data.partners[index].category['name']}',style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold,fontSize: 21.0),),
                              SizedBox(height: 7.0,),
                              Text('${data.partners[index].state['name']}',style: TextStyle(color: Colors.black87,fontSize: 16.0),)
                            ],
                          ),


                        ],
                      ),
                    ),
                  ),
                );





              },
            ),
          ) : Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('Waiting for partners.........',style: TextStyle(color: Colors.white),),
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



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/styles/styles.dart';
import 'package:flutter_todo/utils/validate.dart';
import 'package:flutter_todo/models/state.dart';
import 'package:flutter_todo/models/category.dart';
import 'package:flutter_todo/views/admin/admin_partner_menu.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/models/partner.dart';
import 'package:flutter_todo/utils/constants.dart';
import 'package:flutter_todo/providers/user.dart';
import 'package:flutter_todo/views/admin/admin_add_partner.dart';
import 'package:flutter_todo/providers/route.dart';

class AdminSinglePartner extends StatefulWidget {

  final Partner partner;
  String routeIntent;

  AdminSinglePartner({this.partner,this.routeIntent});

  @override
  _AdminSinglePartnerState createState() => _AdminSinglePartnerState();
}

class _AdminSinglePartnerState extends State<AdminSinglePartner> {

  String pcpLoader = 'Primary Contact Person';

  String nobLoader ='Name of Business';

  String phLoader ='Position Held';

  String lobLoader ='Location of Business';

  String wLoader ='website';

  String eLoader = 'Email';

  String pLoader = 'Phone';

  String sLoader ='State';

  String cLoader ='Category';

  bool loaded=false;


  List<Widget> buildWidgetList({Partner partner}){

    List<Widget> partnerInfo=[];

    partnerInfo.add(
        Container(
          //decoration: Styles.boxDecoration1,
          child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 3.0,),
            PaymentCard(header:'Name of Business' ,body:widget.partner.nameOfBusiness ,loaded: loaded,),
            //!loaded ? Skeleton(width: nobLoader.length.toDouble()*100,) : Text('${widget.partner.nameOfBusiness}',style: Styles.lightText2,),


          ],),
        )
    );
    partnerInfo.add(
        Container(
          //decoration: Styles.boxDecoration1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PaymentCard(header:'Primary Contact Person' ,body:widget.partner.primaryContactPerson,loaded: loaded ,)

          ],),
        )
    );

    partnerInfo.add(
        Container(
          //decoration: Styles.boxDecoration1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PaymentCard(header:'Position Held' ,body:widget.partner.positionHeld,loaded: loaded ,)

          ],),
        )
    );

    partnerInfo.add(
        Container(
          //decoration: Styles.boxDecoration1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PaymentCard(header:'Location of Business' ,body:widget.partner.businessLocation,loaded: loaded ,)

          ],),
        )
    );


    partnerInfo.add(
        Container(
          //decoration: Styles.boxDecoration1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PaymentCard(header:'website' ,body:widget.partner.website!=null ?widget.partner.website:'NA',loaded: loaded ,)

          ],),
        )
    );


    partnerInfo.add(
        Container(
          //decoration: Styles.boxDecoration1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PaymentCard(header:'Email' ,body:widget.partner.email,loaded: loaded ,)

          ],),
        )
    );

    partnerInfo.add(
        Container(
          //decoration: Styles.boxDecoration1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PaymentCard(header:'Phone' ,body:widget.partner.phone ,loaded: loaded,)
          ],),
        )
    );

    partnerInfo.add(
        Container(
          //decoration: Styles.boxDecoration1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PaymentCard(header:'Category' ,body:widget.partner.category['name'] ,loaded: loaded,)
          ],),
        )
    );


    partnerInfo.add(
        Container(
          //decoration: Styles.boxDecoration1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PaymentCard(header:'Discount' ,body:'${widget.partner.discount}%',loaded: loaded ,)
          ],),
        )
    );

    partnerInfo.add(
        Container(
          //decoration: Styles.boxDecoration1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PaymentCard(header:'State' ,body:'${widget.partner.state['name']}',loaded: loaded ,)
          ],),
        )
    );


    return partnerInfo;
  }


  @override
  Widget build(BuildContext context) {
    if(!loaded) Future.delayed(Duration(milliseconds: 2000),(){
     if(mounted){
       setState(() {
         loaded=!loaded;
       });
     }
    });
    return  SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Container(
          child:
              CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                   delegate: MySliverAppBar(expandedHeight: 200,partner: widget.partner,routeIntent:widget.routeIntent),
                    //delegate:
                    pinned: true,
                  ),
                  SliverList(

                    delegate: SliverChildListDelegate(
                        buildWidgetList(partner: widget.partner )
                    ),
                  )
                ],
              ),

        ),
      ),
    );
  }
}




class Skeleton extends StatefulWidget {
  final double height;
  final double width;

  Skeleton({Key key, this.height = 20, this.width = 200 }) : super(key: key);

  createState() => SkeletonState();
}

class SkeletonState extends State<Skeleton> with SingleTickerProviderStateMixin {
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

    _controller.repeat();
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      width:  widget.width,
      height: widget.height,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment(gradientPosition.value, 0),
              end: Alignment(-1, 0),
              colors: [Colors.white, Colors.grey[300], Colors.white]
          )
      ),
    );
  //return SizedBox();
  }

  @override
  void dispose() {

    _controller.dispose();
    super.dispose();
  }


}


class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  Partner partner;
  String routeIntent;

  MySliverAppBar({@required this.expandedHeight,this.partner,this.routeIntent});

  UserProvider userProvider;

  Map userAuthenticated;


//  init(context)  async{
//    userProvider = Provider.of<UserProvider>(context);
//    userAuthenticated= await userProvider.userData();
//    print(userProvider.name);
//    print('Hi there');
//  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    //print(Provider.of<UserProvider>(context).accountType);

    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight:Radius.circular(25) ),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage('$siteUrl/categories/${partner.category['id']}/${partner.categoryImage}'),
            ),
          ),
        ),

//        Image.network(
//            '$siteUrl/categories/${partner.category['id']}/${partner.categoryImage}',
//            fit: BoxFit.cover
//        ),
        Center(
          child: Opacity(
            opacity: 0.4,
            child: Container(
              //color:Colors.black54,
            )
          ),
        ),

        Align(
          alignment:Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black26,
              ),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: GestureDetector(  onTap: (){
                      if(routeIntent==null && routeIntent!='admin_partner_menu')
                        Navigator.pop(context);
                      if(routeIntent!=null && routeIntent=='admin_partner_menu')
                        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => AdminPartnerMenu()));

                    },child: Icon(Icons.arrow_back_ios)),
                    color: Colors.white,
                    onPressed: () {},
                  ),
                  Flexible(child: Text("${partner.nameOfBusiness}",overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 24.0),))
                ],
              ),
            ),
          ),
        ),


              Consumer<UserProvider>(
    builder: (context,data,child)=>
        data.accountType=='admin' ? GestureDetector(
          onTap: ()=>Navigator.push(context,MaterialPageRoute(builder: (context)=>AdminAddPartner(partner: partner,action: 'update',))),
          child: Align(
              alignment: Alignment(0.5, 1.4),
              child: Opacity(
                opacity: (1 - shrinkOffset / expandedHeight),
                child:  ClipOval(
                  child: Material(
                    color: Colors.green, // button color
                    child: InkWell(
                      splashColor: Colors.green, // inkwell color
                      child:  SizedBox(width: 56, height: 56, child:
                             Icon(Icons.edit,color: Colors.white,)  ),
                      //onTap:()=>print('clicked')
                          //()=>Navigator.push(context,MaterialPageRoute(builder: (context)=>AdminAddPartner(partner: partner,action: 'update',))),
                    ),
                  ),
                )
              ),
            ),
        ): SizedBox(),
        ),

        Align(
          alignment: Alignment(0.9, 1.4),
          child: Opacity(
              opacity: (1 - shrinkOffset / expandedHeight),
              child:  ClipOval(
                child: Material(
                  color: Colors.red, // button color
                  child: Container(
                    padding: partner.discount>=10 ? EdgeInsets.symmetric(horizontal: 16,vertical: 19):EdgeInsets.all(20),
                    decoration: BoxDecoration(
                    ),
                    child: Text('${partner.discount}%',style: Styles.textTheme2,),),
                ),
              )
          ),
        )

      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}



class PaymentCard extends StatelessWidget {
  final String header;
  final String body;
  final bool loaded;
  PaymentCard({this.header,this.body,this.loaded});
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 3),
      child: Container(
        margin: const EdgeInsets.all(1.0),
        width:double.infinity,
        padding: const EdgeInsets.symmetric( horizontal: 25.0,vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          //borderRadius: BorderRadius.only(topLeft: Radius.circular(45.0),bottomRight: Radius.circular(25.0) )
        ),
        child:  loaded ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('$header',style: TextStyle(fontSize: 18.0,color: Colors.green),),
            Text('$body',style: Styles.lightText2),
          ],
        ):SkeletonPack(),
      ),
    );
  }
}


class SkeletonPack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Skeleton(width: MediaQuery.of(context).size.width-20,),
        SizedBox(height: 20,),
        Skeleton(width: MediaQuery.of(context).size.width-20,),
        SizedBox(height: 20,),
        Skeleton(width: MediaQuery.of(context).size.width-20,),
        SizedBox(height: 20,),
        Skeleton(width: MediaQuery.of(context).size.width-20,),
        SizedBox(height: 20,),
        Skeleton(width: MediaQuery.of(context).size.width-20,),
        SizedBox(height: 20,),
        Skeleton(width: MediaQuery.of(context).size.width-20,),
        SizedBox(height: 20,),
        Skeleton(width: MediaQuery.of(context).size.width-20,),
        SizedBox(height: 20,),
        Skeleton(width: MediaQuery.of(context).size.width-20,),
        SizedBox(height: 20,),
        Skeleton(width: MediaQuery.of(context).size.width-20,),
        SizedBox(height: 20,),
        Skeleton(width: MediaQuery.of(context).size.width-20,),
        SizedBox(height: 20,),
        Skeleton(width: MediaQuery.of(context).size.width-20,),
        SizedBox(height: 20,),
        Skeleton(width: MediaQuery.of(context).size.width-20,),
        SizedBox(height: 20,),
      ],);
  }
}



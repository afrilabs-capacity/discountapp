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

class Album extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return  SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.green,
        body: Consumer<AlbumProvider>(
          builder:(context,data,child) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              MyNavigation(),
              PageLayout(data: Center(
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20,),
                    AlbumList()
                  ],),


              ),)

            ],
          ),
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
            Text('Events',style: TextStyle(color:Colors.white,fontSize: 30.0),),
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




class AlbumList extends StatefulWidget {
  @override
  _AlbumListState createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> {

  AuthProvider _provider;

  bool modalWindowOpen;

  PersistentBottomSheetController bottomSheetController;

  showModalBottom(BuildContext context,List<Photo> photos, String directory) async {
    modalWindowOpen=true;
    return Scaffold.of(context).showBottomSheet(
          (BuildContext context){
        return Center(
          child: Container(
            color: Colors.black,
            child: Container(
              //height: 70,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0),topRight: Radius.circular(25.0))
                ),
                //width: MediaQuery.of(context).size.width-40,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Center(child:

                        ClipOval(
                          child: Material(
                            color: Colors.grey[100], // button color
                            child: InkWell(
                              splashColor: Colors.white, // inkwell color
                              child:  SizedBox(width: 56, height: 56, child:
                              Icon(Icons.close,size: 30,color: Colors.red,) ),
                              onTap: ()=>bottomSheetController.close(),
                            ),
                          ),
                        ),

//
                        ),),
                      Divider(),
                      SizedBox(height: 3,),
                     if(Provider.of<AlbumProvider>(context).currentImageId!=null)
                     Expanded(
                       flex: 5,
                       child:  Container(
                       width: double.infinity-20,
                       padding: EdgeInsets.all(12.0),
                       margin: EdgeInsets.all(5.0),
                       decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.all(Radius.circular(20.0)),
                         image: DecorationImage(
                           fit: BoxFit.cover,
                           image: NetworkImage('$siteUrl/events/$directory/${photos[Provider.of<AlbumProvider>(context).currentImageId].title}'),
                         ),
                       ),
                       // child: Image.Network("$siteUrl/events/${data.albums[index].directory}/${data.albums[index].photos[0].title}")
                     ),),
                      Expanded(
                          flex: 5,
                          child: GridView.count(
                            // Create a grid with 2 columns. If you change the scrollDirection to
                            // horizontal, this produces 2 rows.
                            crossAxisCount: 3,
                            // Generate 100 widgets that display their index in the List.
                            children: List.generate(photos.length, (index) {
                              return Center(
                                child: GestureDetector(
                                  onTap: (){
                                    bottomSheetController.setState((){
                                      Provider.of<AlbumProvider>(context).currentImageId=index;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(12.0),
                                    margin: EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage('$siteUrl/events/$directory/${photos[index].title}'),
                                      ),
                                    ),
                                   // child: Image.Network("$siteUrl/events/${data.albums[index].directory}/${data.albums[index].photos[0].title}")
                                  ),
                                )
                              );
                            }),
                          )
                      )
                    ],
                  ),
                )

            ),
          ),
        );

      },
      backgroundColor: Colors.black54,
    );
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _provider = Provider.of<AuthProvider>(context,listen: false);
    final albumProvider = Provider.of<AlbumProvider>(context,listen: false);
    albumProvider.initAlbums(_provider);
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<AlbumProvider>(
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
            child: Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: ListView.builder(
                itemCount: data.albums.length,
                itemBuilder: (context, index) {
                  return  GestureDetector(
                    onTap: ()async{
                      //bottomSheetController = await  showModalBottom(context,data.messages[index]);
                      //print(data.messages[index]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20.0))
                        ),
                        child: Container(child: Row(children: <Widget>[
                          Expanded(flex:1,child: CircleAvatar(
                            //radius: 20,
                            backgroundColor: Colors.green,
                            backgroundImage:  NetworkImage("$siteUrl/events/${data.albums[index].directory}/${data.albums[index].photos[0].title}"),
                            //radius: MediaQuery.of(context).size.width/12,
                          )),
                          SizedBox(width: 10,),
                          Expanded( flex:3,child: Text('${data.albums[index].title}')),
                          SizedBox(width: 10,),
                          Expanded(child: Text('(${data.albums[index].photos.length})')),
                          Expanded( child: GestureDetector(
                              onTap: ()async{
                                bottomSheetController = await  showModalBottom(context,data.albums[index].photos,data.albums[index].directory);
                                Provider.of<AlbumProvider>(context).currentImageId=null;
                              },
                              child: Icon(Icons.remove_red_eye,color: Styles.myColor1,))),
                        ],),)
                      ),
                    ),
                  );




                },
              ),
            ),
          ) : Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('Waiting for albums.........',style: TextStyle(color: Colors.white),),
              Skeleton(width: MediaQuery.of(context).size.width-20,),
              SizedBox(height: 3,),
              Skeleton(width: MediaQuery.of(context).size.width-30,),
              SizedBox(height: 3,),
              Skeleton(width: MediaQuery.of(context).size.width-40,),
              SizedBox(height:3,),
              Skeleton(width: MediaQuery.of(context).size.width-50,),

            ],)
      ),
    );
  }
}



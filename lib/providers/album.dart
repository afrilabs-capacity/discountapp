import 'package:flutter/material.dart';
import 'package:flutter_todo/models/paginate.dart';
import 'package:flutter_todo/models/album.dart';
import 'package:flutter_todo/services/albumService.dart';


class AlbumProvider with ChangeNotifier{

  /* Empty list of partners*/
  List<Album> albums = [];

  /* Empty pagination data*/
  Paginate  paginate;

  /*loading indicator*/
  bool loadMore=false;

  /*do we have initial data*/
  bool loaded=false;

  bool showFilter=false;

  int currentImageId;


  initAlbums(_provider)async{
    //_provider =  Provider.of<AuthProvider>(context);
    albums=[];
    AlbumService albumService =AlbumService(_provider);
    var response =await albumService.fetchAlbums();
    //Map apiResponse=jsonDecode( response['success']);
    if(response['code']==401){
      print('token expired');
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
    }

    if(response['success']){
      albums=response['data'];
      paginate=response['paginate'];
      loaded=true;
      //print(paginate.nextPageUrl);
      notifyListeners();
    }

//    Future.delayed(Duration(milliseconds: 3000),(){
//      showFilter=false;
//      notifyListeners();
//    });


  }



  loadMoreData(_provider)async{
    print(paginate.nextPageUrl);
    if(paginate.nextPageUrl==null)
      return;
    loadMore=true;
    print('loading more');
    //notifyListeners();
    AlbumService albumService =AlbumService(_provider);
    var response =await albumService.fetchAlbumsPaginate(paginate.nextPageUrl);

    if(response['code']==401){
      print('token expired');
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
    }

    if(response['success']){
      albums=albums+response['data'];
      paginate=response['paginate'];
      //print(response);
      //print(paginate.nextPageUrl);
      loadMore=false;
      notifyListeners();
    }
    loadMore=false;
    notifyListeners();
  }


}
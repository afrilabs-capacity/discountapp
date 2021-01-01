
class MyCategory{
  int id;
  String category;
  MyCategory({this.id,this.category});

  List get categories=> _getCategories();

  _getCategories(){
    List categoryList= [
      MyCategory(id:1,category:'Departmental Stores'),
      MyCategory(id:2,category:'Food & Restaurant'),
      MyCategory(id:3,category:'Fashion & Apparel'),
      MyCategory(id:4,category: 'General market'),
      MyCategory(id:5,category:'Health Services'),
      MyCategory(id:6,category:'Insurance & Banking'),
      MyCategory(id:7,category:'Leisure& Entertainment'),
      MyCategory(id:8,category:'Laundry and Dry Cleaning'),
      MyCategory(id:9,category:'Study Essentials'),
      MyCategory(id:10,category:'Sport Gear & Fitness',),
      MyCategory(id:11,category:'Travel and Holidays'),
      MyCategory(id:12,category:'Technology'),
      MyCategory(id:13,category:'Telecommunications'),

    ];
    return categoryList;

  }




}
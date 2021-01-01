
class MyDiscount{
  int discount;
  MyDiscount({this.discount});

  List get discounts=> _getDiscounts();

  _getDiscounts(){
    List discountList= [
      MyDiscount(discount:5),
      MyDiscount(discount:10),
      MyDiscount(discount:15),
      MyDiscount(discount:20),
      MyDiscount(discount:25),
      MyDiscount(discount:30),
      MyDiscount(discount:35),
      MyDiscount(discount:40),
      MyDiscount(discount:45),
      MyDiscount(discount:50,),
    ];
    return discountList;

  }




}
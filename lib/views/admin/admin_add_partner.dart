import 'package:flutter/material.dart';
import 'package:flutter_todo/styles/styles.dart';
import 'package:flutter_todo/utils/validate.dart';
import 'package:flutter_todo/models/state.dart';
import 'package:flutter_todo/models/category.dart';
import 'package:flutter_todo/models/discount.dart';
import 'package:flutter_todo/views/admin/admin_single_partner.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/providers/partner.dart';
import 'package:flutter_todo/providers/route.dart';
import 'package:flutter_todo/models/partner.dart';


class AdminAddPartner extends StatefulWidget {
  static final id = 'registration_type';
  Partner partner;

  String action;

  AdminAddPartner({this.partner,this.action});

  @override
  _AdminAddPartnerState createState() => _AdminAddPartnerState();
}

class _AdminAddPartnerState extends State<AdminAddPartner> {

  /* Selected State*/
  String selectedState;

  /* Selected Category*/
  String selectedCategory;

  /* Selected Discount*/
  String selectedDiscount;

  /* Set the color of dropDown button based on validation*/
  Color dropDownValidation_0= Colors.grey;
  Color dropDownValidation_1= Colors.grey;
  Color dropDownValidation_2= Colors.grey;

  /* Set the color of dropDown button based on validation*/
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /* Instantiate MyState*/
  MyState myState= MyState();

  /* Instantiate MyCategory*/
  MyCategory myCategory= MyCategory();

  /* Instantiate MyCategory*/
  MyDiscount myDiscount= MyDiscount();

/* Handle for our ScrollView*/
  ScrollController _scrollController = new ScrollController();

  /*Store API response object*/
  Map response = new Map();


  bool modalWindowOpen=false;

  /* Text controllers*/
  TextEditingController contactPersonController =TextEditingController();
  TextEditingController phoneController =TextEditingController();
  TextEditingController businessNameController =TextEditingController();
  TextEditingController positionHeldController =TextEditingController();
  TextEditingController businessLocationController =TextEditingController();
  TextEditingController emailController =TextEditingController();
  TextEditingController websiteController =TextEditingController();

  /*fake controllers just to keep naming consistent*/
  String stateController;
  String categoryController;
  String discountController;

  String actionController;
  String partnerIdController;

  /* Dummy data field*/
  initFields(){
    if(widget.action=='update'){
      partnerIdController=widget.partner.id.toString();
      selectedState=widget.partner.state['id'].toString();
      selectedCategory=widget.partner.category['id'].toString();
      selectedDiscount=widget.partner.discount.toString();
      stateController=selectedState;
      categoryController=selectedCategory;
      discountController=selectedDiscount;
      contactPersonController.text=widget.partner.primaryContactPerson;
      phoneController.text=widget.partner.phone;
      businessNameController.text=widget.partner.nameOfBusiness;
      positionHeldController.text=widget.partner.positionHeld;
      businessLocationController.text=widget.partner.businessLocation;
      emailController.text=widget.partner.email;
      websiteController.text=widget.partner.website;
      actionController='update';
      //print('we here initializing');
    }else{
      stateController=selectedState;
      categoryController=selectedCategory;
      discountController=selectedDiscount;
      actionController='create';
    }


  }

/* BottomSheetModal */
  showModalBottom(BuildContext context) async {
    modalWindowOpen=true;
    return Scaffold.of(context).showBottomSheet(
          (BuildContext context){
        return Center(
          child: Container(
            color: Colors.black,
            child: Container(
                height: 70,
                color: Colors.white,
                width: MediaQuery.of(context).size.width-40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: 35,),
                    Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green),)),
                    SizedBox(width: 35,),
                    Text('Submitting...')
                  ],
                )

            ),
          ),
        );

      },
      backgroundColor: Colors.black54,
    );
  }

  showModalBottomDismiss(dynamic errorBag){
    //Map errors=jsonDecode(errorBag);

    List<Widget> apiErrors=[];
    //print(errors['first_name']);
    errorBag.forEach((key,value){
      apiErrors.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Icon(Icons.error_outline,color: Colors.pink,),
              SizedBox(width: 5.0,),
              Flexible(child: Text(errorBag[key][0].toString(),style: TextStyle(color: Colors.pink),)),
            ],
          )
      ));
      //print(value);
    });

    int errorCount=apiErrors.length;

    return showModalBottomSheet(
        context: context,builder: (context){
      return Container(
        color: Colors.black45,
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0),topRight: Radius.circular(25.0))
            ),
            height: double.infinity,
            child: Column(
              children: <Widget>[
                SizedBox(height: 15.0,),
                Text('We found ($errorCount) errors',style: TextStyle(fontSize: 20.0),),
                Divider(),
                SizedBox(height: 10.0,),
                Expanded(
                  child: ListView(
                      shrinkWrap: true,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: apiErrors
                  ),
                ),
              ],
            )
        ),
      );
    }

    );

  }

  submit(BuildContext context) async {
    validateCategorySelect();
    validateStateSelect();
    validateDiscount();
    if(_formKey.currentState.validate() && selectedCategory!=null && selectedState!=null && selectedDiscount!=null){
      PersistentBottomSheetController bottomSheetController =await showModalBottom(context);
     /*contact server and wait for response*/

      response = await Provider.of<PartnerProvider>(context)
          .registerPartner(
          Provider.of<AuthProvider>(context,listen: false),
           partnerIdController: partnerIdController,
           stateController:stateController,
          categoryController:categoryController,
          contactPersonController:contactPersonController.text,
          phoneController:phoneController.text,
          businessNameController:businessNameController.text,
          positionHeldController:positionHeldController.text,
          businessLocationController:businessLocationController.text,
          emailController:emailController.text,
          websiteController:websiteController.text,
          discountController: discountController,
          regTypeController:'partner',
          actionController: actionController
      );

      //print(selectedDiscount);
      if (response['success']) {
        //bottomSheetController.close();
        Future.delayed(Duration(milliseconds: 4000), () {
          bottomSheetController.close();
          modalWindowOpen = false;
//          final snackBar = SnackBar(content: Text('Updated'),backgroundColor: Colors.green[600],);
//          Scaffold.of(context).showSnackBar(snackBar);
          print('success');
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => AdminSinglePartner(partner: response['data'],routeIntent: 'admin_partner_menu',)));


          // _showModal();
        });
        return;

      } else {
        if (response['errors'] != null){
          Future.delayed(Duration(milliseconds: 6000), () {
            bottomSheetController.close();
            modalWindowOpen = false;
            showModalBottomDismiss(response['errors']);
            // _showModal();
          });
          return;
          //print(response['errors']);
        }

      }

      Future.delayed(Duration(milliseconds: 6000), () {
        bottomSheetController.close();
        modalWindowOpen = false;
        final snackBar = SnackBar(content: Text('Server error please try again later'));
        Scaffold.of(context).showSnackBar(snackBar);
        // _showModal();
      });

    }

    if(contactPersonController.text!=null && phoneController.text!=null && businessNameController.text!=null && positionHeldController.text!=null && businessLocationController.text!=null && emailController.text==null){
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }

    if(contactPersonController.text!=null && phoneController.text!=null && businessNameController.text!=null && positionHeldController.text!=null && businessLocationController.text!=null){

      if(selectedState==null || selectedCategory==null)
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);

    }



  }

  void validateCategorySelect(){
    if(selectedCategory==null){
      setState(() {
        dropDownValidation_0= Colors.red;
      });
    }else{
      setState(() {
        dropDownValidation_0= Colors.grey;
      });

    }
  }

  void validateStateSelect(){
    if(selectedState==null){
      setState(() {
        dropDownValidation_1= Colors.red;
      });
    }else{
      setState(() {
        dropDownValidation_1= Colors.grey;
      });

    }
  }


  void validateDiscount(){
    if(selectedDiscount==null){
      setState(() {
        dropDownValidation_2= Colors.red;
      });
    }else{
      setState(() {
        dropDownValidation_2= Colors.grey;
      });

    }

  }


  @override
  void initState() {
    // TODO: implement initState
    //testApi();
      super.initState();
      contactPersonController.addListener(()=>null);
      phoneController.addListener(()=>null);
      businessNameController.addListener(()=>null);
      positionHeldController.addListener(()=>null);
      businessLocationController.addListener(()=>null);
      emailController.addListener(()=>null);
      websiteController.addListener(()=>null);
      initFields();
  }


  @override
  Widget build(BuildContext context){

    return  WillPopScope(
      onWillPop: () async =>  modalWindowOpen ?  false : true,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.green[600],
            body: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[

                  Expanded(
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
                          widget.action=='create' ? Text('Add Partner',style: TextStyle(color:Colors.white,fontSize: 30.0),): Text('Update Partner',style: TextStyle(color:Colors.white,fontSize: 30.0),),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Container(
                      width: double.infinity,
                      //height: MediaQuery.of(context).size.height-10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)/*,topRight: Radius.circular(75.0)*/),
                      ),
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[

                          SizedBox(height: 30.0,),
                            Text('Complete required fields to add a partner'),
                            SizedBox(height: 20.0,),
                            Expanded(
                              child: Form(
                                key: _formKey,
                                child: ListView(
                                  controller: _scrollController,
                                  children: <Widget>[

                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: TextFormField(
                                        controller: contactPersonController,
                                        decoration: Styles.flatFormFields.copyWith(labelText: 'Primary Contact person',focusColor: Colors.pink),
                                        // The validator receives the text that the user has entered.
                                        validator: (value) {
                                          //email = value.trim();
                                          return Validate.requiredField(value,'Primary Contact person required');
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: phoneController,
                                        decoration: Styles.flatFormFields.copyWith(labelText: 'Mobile No',focusColor: Colors.pink),
                                        // The validator receives the text that the user has entered.
                                        validator: (value) {
                                          //email = value.trim();
                                          return Validate.validatePhone(value,'Mobile No required');
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: TextFormField(
                                        controller: businessNameController,
                                        decoration: Styles.flatFormFields.copyWith(labelText: 'Name of Business',focusColor: Colors.pink),
                                        // The validator receives the text that the user has entered.
                                        validator: (value) {
                                          //email = value.trim();
                                          return Validate.requiredField(value,'Business Name required');
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: TextFormField(
                                        controller: positionHeldController,
                                        decoration: Styles.flatFormFields.copyWith(labelText: 'Position held in Company',focusColor: Colors.pink),
                                        // The validator receives the text that the user has entered.
                                        validator: (value) {
                                          //email = value.trim();
                                          return Validate.requiredField(value,'Position held  required');
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: TextFormField(
                                       // maxLength: 60,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        maxLength: 40,
                                        textInputAction: TextInputAction.done,
                                        controller:businessLocationController ,
                                        decoration: Styles.flatFormFields.copyWith(labelText: 'Location of Business',focusColor: Colors.pink),
                                        // The validator receives the text that the user has entered.
                                        validator: (value) {
                                          //email = value.trim();
                                          return Validate.requiredField(value,'Business location required');
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical:1.0),
                                      child: TextFormField(
                                        controller:emailController ,
                                        decoration: Styles.flatFormFields.copyWith(labelText: 'Email',focusColor: Colors.pink),
                                        // The validator receives the text that the user has entered.
                                        validator: (value) {
                                          //email = value.trim();
                                          return Validate.validateEmail(value);
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: TextFormField(
                                        controller:websiteController ,
                                        decoration: Styles.flatFormFields.copyWith(labelText: 'Website(optional)',focusColor: Colors.pink),
                                        // The validator receives the text that the user has entered.

                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: DropdownButton<String>(
                                        isExpanded:true,
                                        //underline: Text(''),
                                        icon: Icon(Icons.keyboard_arrow_down),
                                        underline: Container(color:dropDownValidation_0, height:1.0),
                                        hint: Text('State',style: TextStyle(color: Colors.black)),
                                        value: selectedState,
                                        items: myState.states.map<DropdownMenuItem<String>>( (value)=> DropdownMenuItem<String>(child:
                                        Text(value.state,style: TextStyle(color: Colors.black),),value:value.id.toString(),)  ).toList(),
                                        //DropdownMenuItem(child: Text('USD',style: TextStyle(color: Colors.black),),value:'USD' ,),

                                        onChanged:(value){
                                          setState(() {
                                            selectedState=value;
                                            stateController=value;
                                            //validateIdTypeField();
                                          });
                                        } ,

                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DropdownButton<String>(
                                        isExpanded:true,
                                        underline: Container(color:dropDownValidation_1, height:1.0),
                                        hint: Text('Category',style: TextStyle(color: Colors.black)),
                                        value: selectedCategory,
                                        items: myCategory.categories.map<DropdownMenuItem<String>>( (value)=> DropdownMenuItem<String>(child:
                                        Text(value.category,style: TextStyle(color: Colors.black),),value:value.id.toString(),)  ).toList(),
                                        //DropdownMenuItem(child: Text('USD',style: TextStyle(color: Colors.black),),value:'USD' ,),
                                        onChanged:(value){
                                          setState(() {
                                            selectedCategory=value;
                                            categoryController=value;
                                            //validateIdTypeField();
                                          });
                                        } ,

                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DropdownButton<String>(
                                        isExpanded:true,
                                        underline: Container(color:dropDownValidation_2, height:1.0),
                                        hint: Text('Discount',style: TextStyle(color: Colors.black)),
                                        value: selectedDiscount,
                                        items: myDiscount.discounts.map<DropdownMenuItem<String>>( (value)=> DropdownMenuItem<String>(child:
                                        Text(value.discount.toString(),style: TextStyle(color: Colors.black),),value:value.discount.toString(),)  ).toList(),
                                        //DropdownMenuItem(child: Text('USD',style: TextStyle(color: Colors.black),),value:'USD' ,),
                                        onChanged:(value){
                                          setState(() {
                                            selectedDiscount=value;
                                            discountController=value;
                                            //validateIdTypeField();
                                          });
                                        } ,

                                      ),
                                    ),


                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height:30,),
                            Builder(
                              builder: (context) =>ButtonTheme(
                                minWidth: MediaQuery.of(context).size.width-20,
                                height: 50,
                                buttonColor: Colors.green[600],
                                child: RaisedButton(
                                  onPressed: ()=> submit(context),
                                  child: widget.action=='create' ?   Text("Add",style: TextStyle(color: Colors.white),) : Text("Update",style: TextStyle(color: Colors.white),),
                                ),
                              ),
                            ),
                            SizedBox(height: 10,)
                        ],
                      ),
                    ),
                  ),
                ],

              ),
            ),
          ),
      ),
    );
  }


  @override
  void dispose() {
    contactPersonController.dispose();
phoneController.dispose();
businessNameController.dispose();
positionHeldController.dispose();
businessLocationController.dispose();
emailController.dispose();
websiteController.dispose();
//myFocusNode.dispose();
    super.dispose();
  }



}


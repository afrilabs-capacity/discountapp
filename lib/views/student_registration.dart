import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/utils/validate.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/styles/styles.dart';
import 'package:intl/intl.dart';
import 'package:flutter_todo/models/state.dart';
import 'package:flutter_todo/components/header_green.dart';
import 'package:flutter_todo/views/upload.dart';
//import '';


enum Sex { MALE, FEMALE }


class StudentRegistration extends StatefulWidget {
  static final id = 'student_registration';
  @override
  _StudentRegistrationState createState() => _StudentRegistrationState();
}

class _StudentRegistrationState extends State<StudentRegistration> {

  /*global keys*/
  final GlobalKey<FormState> _formKey_0 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey_1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey_2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey_3 = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  /*Set focus on desired widget*/
  FocusNode myFocusNode;
  /*Store API response object*/
  Map response = new Map();
  /*Store messages*/
  String message = '';

  /*BottomSheetModal open or closed*/
  bool modalWindowOpen=false;

  //TextEditingController titleController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  //TextEditingController sexController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  //TextEditingController stateController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  //TextEditingController idTypeController = TextEditingController();
  TextEditingController idNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  //TextEditingController regTypeController = TextEditingController();
  TextEditingController instituteSchoolController = TextEditingController();
  TextEditingController matriculationExamNumberController = TextEditingController();
  TextEditingController levelExpectedGraduationYearController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();






  /*List of titles*/
  String titleDropdownValue = 'Plese select title';

  List<String> titleList = ['Mr','Mrs'];

  List<String> idTypeList = ['International Passports','Driver\'s Licence','VOTERS\'S CARD','STUDENT ID Card'];

  List<String> sexList = ['Male','Female'];

  /*selects*/
  String selectedTitle;
  String selectedIdType;
  String selectedState;
  String selectedSex;

  /*date instance*/
  DateTime selectedDate = DateTime.now();

  /*date format instance*/
  DateFormat dateFormat = DateFormat("d-MM-yyyy");

  /*select field validation*/
  String titleValidation='';
  String idTypeValidation='';
  String stateValidation='';

  /* Instantiate MyState*/
  MyState myState= MyState();

  /* BottomSheetModal */
  showModalBottom() async {
    modalWindowOpen=true;
    return _scaffoldKey.currentState.showBottomSheet(
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

    Future <void> submit() async {
    if (formValidationComplete()) {
        //print('contacting registration server');
        PersistentBottomSheetController bottomSheetController = await showModalBottom();
        response = await Provider.of<AuthProvider>(context)
            .register(
            titleController:selectedTitle,
            firstNameController:firstNameController.text,
            middleNameController:middleNameController.text,
            lastNameController:lastNameController.text,
            addressController:addressController.text,
            sexController:selectedSex,
            cityController:cityController.text,
            stateController:selectedState,
            dobController:dobController.text,
            idTypeController:selectedIdType,
            idNumberController:idNumberController.text,
            emailController:emailController.text,
            phoneController:phoneController.text,
            regTypeController:'student',
            instituteSchoolController:instituteSchoolController.text,
            matriculationExamNumberController:matriculationExamNumberController.text,
            levelExpectedGraduationYearController:levelExpectedGraduationYearController.text,
            passwordController:passwordController.text,
            passwordConfirmController:passwordConfirmController.text,
            cardHolderController:'student'
        );
        if (response['success']) {
          //Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => UploadPassport()));
        } else {
          if (response['errors'] != null){
            Future.delayed(Duration(milliseconds: 6000), () {
              bottomSheetController.close();
              modalWindowOpen = false;
              showModalBottomDismiss(response['errors']);
              // _showModal();
            });
            return;
            print(response['errors']);

          }


        }

        Future.delayed(Duration(milliseconds: 6000), () {
          bottomSheetController.close();
          modalWindowOpen = false;
          final snackBar = SnackBar(content: Text('Server error please try again later'));
          _scaffoldKey.currentState.showSnackBar(snackBar);
          // _showModal();
        });


      }
    }




  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
                //primarySwatch: buttonTextColor,//OK/Cancel button text color
                primaryColor: Colors.green,//Head background
                accentColor:  Colors.green,

              colorScheme: ColorScheme.light(primary: Colors.green),
              buttonTheme: ButtonThemeData(
                  textTheme: ButtonTextTheme.primary
              ),
              //dialogBackgroundColor: Colors.white,//Background color
            ),
            child: child,
          );
        },
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1965, 8),
        lastDate: DateTime(2101),


    );

    FocusScope.of(context).requestFocus(myFocusNode);

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dobController.text=dateFormat.format(selectedDate);
        print(selectedDate);
        //dobController.f
      });
  }



  List buildSteps(){
    List<Step> steps = [];
     steps.add( Step(
      isActive: false,
      state: stepStateMapping[0],
      title: const Text('Bio Information'),
      content: Form(
        autovalidate: false,
        key: _formKey_0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DropdownButton<String>(
              underline: Container(color:dropDownValidation_0, height:1.0),
              hint: Text('Please select title',style: TextStyle(color: Colors.black)),
              value: selectedTitle,
              items: titleList.map<DropdownMenuItem<String>>( (String value)=> DropdownMenuItem<String>(child: Text(value,style: TextStyle(color: Colors.black),),value:value ,)  ).toList(),
              //DropdownMenuItem(child: Text('USD',style: TextStyle(color: Colors.black),),value:'USD' ,),

              onChanged:(value){

                setState(() {
                  selectedTitle=value;
                  validateTitleField();
                  validateIdTypeField();
                });
              }

            ),
//            Text(titleValidation,style: TextStyle(color:
//            Colors.red),),
            TextFormField(
              controller: firstNameController,
              decoration: Styles.flatFormFields.copyWith(labelText: 'FIRST NAME',focusColor: Colors.pink),
              // The validator receives the text that the user has entered.
              validator: (value) {
                //email = value.trim();
                return Validate.requiredField(value,'First Name required');
              },
              //style: TextStyle(fontWeight: FontWeight.w100,color: Colors.black),
            ),
            TextFormField(
              controller: middleNameController,
              decoration: Styles.flatFormFields.copyWith(labelText: 'MIDDLE NAME (optional)',focusColor: Colors.pink),
              // The validator receives the text that the user has entered.
//              validator: (value) {
//                //email = value.trim();
//                return Validate.requiredField(value,'Middle Name required');
//              },
            ),

            TextFormField(
              controller: lastNameController,
              decoration: Styles.flatFormFields.copyWith(labelText: 'LAST NAME',focusColor: Colors.pink),
              // The validator receives the text that the user has entered.
              validator: (value) {
                //email = value.trim();
                return Validate.requiredField(value,'Last Name required');
              },
            ),

            InkWell(
              onTap: () {
                _selectDate(context);   // Call Function that has showDatePicker()
              },
              child: IgnorePointer(
                child: new TextFormField(
                  focusNode: myFocusNode,
                  controller: dobController,
                  decoration: new InputDecoration(hintText: 'DATE OF BIRTH'),
                  maxLength: 10,
                  validator: (value) {
                    //email = value.trim();
                    return Validate.requiredField(value,'Date of birth required');
                  },
                  //onSaved: (String val) {},
                ),
              ),
            ),
            DropdownButton<String>(
                underline: Container(color:dropDownValidation_3, height:1.0),
                hint: Text('Please select sex',style: TextStyle(color: Colors.black)),
                value: selectedSex,
                items: sexList.map<DropdownMenuItem<String>>( (String value)=> DropdownMenuItem<String>(child: Text(value,style: TextStyle(color: Colors.black),),value:value ,)  ).toList(),
                //DropdownMenuItem(child: Text('USD',style: TextStyle(color: Colors.black),),value:'USD' ,),

                onChanged:(value){

                  setState(() {
                    selectedSex=value;
                    validateSexField();

                  });
                }

            ),

          ],
        ),
      ),
    ) );


    steps.add( Step(
    isActive: false,
    state: stepStateMapping[1],
    title: const Text('Identification'),
    content: Form(
      autovalidate: false,
      key: _formKey_1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
      DropdownButton<String>(
        underline: Container(color:dropDownValidation_1, height:1.0),
                            hint: Text('Please select ID Type',style: TextStyle(color: Colors.black)),
                            value: selectedIdType,
                            items: idTypeList.map<DropdownMenuItem<String>>( (String value)=> DropdownMenuItem<String>(child: Text(value,style: TextStyle(color: Colors.black),),value:value ,)  ).toList(),
                            //DropdownMenuItem(child: Text('USD',style: TextStyle(color: Colors.black),),value:'USD' ,),

                            onChanged:(value){

                              setState(() {
                                selectedIdType=value;
                                validateIdTypeField();
                              });
                            } ,

                          ),
//                          Text(idTypeValidation,style: TextStyle(color:
//                          Colors.red),),
                      SizedBox(height: 5.0,),

                          TextFormField(
                            controller: idNumberController,
                            decoration: Styles.flatFormFields.copyWith(labelText: 'ID Number',focusColor: Colors.pink),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              //email = value.trim();
                              return Validate.requiredField(value,'ID Number required');
                            },
                            //style: TextStyle(fontWeight: FontWeight.w100,color: Colors.black),
                          ),

        TextFormField(
          controller: addressController,
          decoration: Styles.flatFormFields.copyWith(labelText: 'ADRESS',focusColor: Colors.pink),
          // The validator receives the text that the user has entered.
          validator: (value) {
            //email = value.trim();
            return Validate.requiredField(value,'Adress required');
          },
          //style: TextStyle(fontWeight: FontWeight.w100,color: Colors.black),
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          controller: phoneController,
          decoration: Styles.flatFormFields.copyWith(labelText: 'PHONE',focusColor: Colors.pink,),
          // The validator receives the text that the user has entered.
//                                    validator: (value) {
//                                      //email = value.trim();
//                                      return Validate.requiredField(value,'Enter Valid Phone Number');
//                                    },
          //style: TextStyle(fontWeight: FontWeight.w100,color: Colors.black),
        ),
        SizedBox(height: 10.0,),
        DropdownButton<String>(
          underline: Container(color:dropDownValidation_2, height:1.0),
          hint: Text('Please select State',style: TextStyle(color: Colors.black)),
          value: selectedState,
          items: myState.states.map<DropdownMenuItem<String>>( (value)=> DropdownMenuItem<String>(child:
          Text(value.state,style: TextStyle(color: Colors.black),),value:value.id.toString(),)  ).toList(),
          //DropdownMenuItem(child: Text('USD',style: TextStyle(color: Colors.black),),value:'USD' ,),

          onChanged:(value){

            setState(() {
              selectedState=value;
              print(selectedState);
              validateStateField();
            });
          } ,

        ),SizedBox(height: 5.0,),
        TextFormField(

          controller:cityController ,
          decoration: Styles.flatFormFields.copyWith(labelText: 'CITY',focusColor: Colors.pink,),
          // The validator receives the text that the user has entered.
                                    validator: (value) {
                                      //email = value.trim();
                                      return Validate.requiredField(value,'City required');
                                    },
          //style: TextStyle(fontWeight: FontWeight.w100,color: Colors.black),
        ),

                          SizedBox(height: 5.0,),
//                                  Container(
//                                    alignment: Alignment.centerLeft,
//                                    child: Text(
//                                        'SEX',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey,fontSize: 17.0)
//                                    ),
//                                  ),

      ],
      ),
    ),
    ) );


    steps.add( Step(
    isActive: false,
    state:  stepStateMapping[2],
    title: const Text('Education'),
    content: Form(
      autovalidate: false,
      key: _formKey_2,
      child: Column(
      children: <Widget>[

//        Text(stateValidation,style: TextStyle(color:
//        Colors.red),),

        TextFormField(
          controller: instituteSchoolController,
          decoration: Styles.flatFormFields.copyWith(labelText: 'INSTITUTE / SCHOOL ATTENDED',focusColor: Colors.pink,),
          // The validator receives the text that the user has entered.
          validator: (value) {
            //email = value.trim();
            return Validate.requiredField(value,'Institute / School required');
          },
          //style: TextStyle(fontWeight: FontWeight.w100,color: Colors.black),
        ),
//

                          SizedBox(height: 10.0,),
                          TextFormField(
                            controller: levelExpectedGraduationYearController,
                            decoration: Styles.flatFormFields.copyWith(labelText: 'GRADUATION YEAR / LEVEL',focusColor: Colors.pink,),
                            // The validator receives the text that the user has entered.
                                    validator: (value) {
                                      //email = value.trim();
                                      return Validate.requiredField(value,'Level / Graduation Year required');
                                    },
                            //style: TextStyle(fontWeight: FontWeight.w100,color: Colors.black),
                          ),

        TextFormField(
          controller: matriculationExamNumberController,
          decoration: Styles.flatFormFields.copyWith(labelText: 'MATRICULATION NUMBER',focusColor: Colors.pink,),
          // The validator receives the text that the user has entered.
          validator: (value) {
            //email = value.trim();
            return Validate.requiredField(value,'Matriculation Number required');
          },
          //style: TextStyle(fontWeight: FontWeight.w100,color: Colors.black),
        ),
      ],
      ),
    ),
    ) );

    steps.add( Step(
      isActive: false,
      state:  stepStateMapping[3],
      title: const Text('Authorization'),
      content: Form(
        autovalidate: false,
        key: _formKey_3,
        child: Column(
          children: <Widget>[

//        Text(stateValidation,style: TextStyle(color:
//        Colors.red),),
            SizedBox(height: 8.0,),

//

            SizedBox(height: 10.0,),


            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              decoration: Styles.flatFormFields.copyWith(labelText: 'EMAIL',focusColor: Colors.pink,),
              // The validator receives the text that the user has entered.
              validator: (value) {
                //email = value.trim();
                return Validate.validateEmail(value);
              },
              //style: TextStyle(fontWeight: FontWeight.w100,color: Colors.black),
            ),

            TextFormField(
              obscureText: true,
              controller: passwordController,
              decoration: Styles.flatFormFields.copyWith(labelText: 'PASSWORD',focusColor: Colors.pink,),
              // The validator receives the text that the user has entered.
              validator: (value) {
                //email = value.trim();
                return Validate.passwordValidate(value);
              },
              //style: TextStyle(fontWeight: FontWeight.w100,color: Colors.black),
            ),
            SizedBox(height: 10.0,),
            TextFormField(
              obscureText: true,
              controller: passwordConfirmController,
              decoration: Styles.flatFormFields.copyWith(labelText: 'PASSWORD CONFIRM',focusColor: Colors.pink,),
              // The validator receives the text that the user has entered.
              validator: (value) {
                //email = value.trim();
                return Validate.passwordConfirmValidate(value, passwordController.text);
              },
              //style: TextStyle(fontWeight: FontWeight.w100,color: Colors.black),
            ),
          ],
        ),
      ),
    ) );

    return steps;

  }


  List<StepState> _listState;



  void validateTitleField(){
    if(selectedTitle==null){
      setState(() {
        dropDownValidation_0= Colors.red;
      });
    }else{
      setState(() {
        dropDownValidation_0= Colors.grey;
      });

    }
  }

  void validateIdTypeField(){
    if(selectedIdType==null){
      setState(() {
        dropDownValidation_1= Colors.red;
      });
    }else{

      setState(() {
        dropDownValidation_1= Colors.grey;
      });

    }

  }

  void validateStateField(){
    if(selectedState==null){
      setState(() {
        dropDownValidation_2= Colors.red;
      });
    }else{
      setState(() {
        dropDownValidation_2= Colors.grey;
      });

    }

  }

  /*
  *Validate sex dropdown field
  *
  */
  void validateSexField(){
    if(selectedSex==null){
      setState(() {
        dropDownValidation_3= Colors.red;
      });
    }else{
      setState(() {
        dropDownValidation_3= Colors.grey;
      });

    }

  }

  @override
  void initState() {

    _listState = [
      StepState.indexed,
      StepState.editing,
      StepState.complete,
      StepState.error,
    ];

    firstNameController.text = "Attah";
    middleNameController.text = "John";
    lastNameController.text = "Braimah";
    addressController.text = "Plot b56 phase 2 site Kubwa Abuja";
    cityController.text = "Kubwa";
    dobController.text = "26-03-2020";
    idNumberController.text = "CPA/344/2004";
    emailController.text = "mydiynuggets360@gmail.com";
    phoneController.text = "07036066056";
    instituteSchoolController.text = "Benue State University";
    matriculationExamNumberController.text = "GYGSFET/33737";
    levelExpectedGraduationYearController .text= "2018";
    passwordController.text = "123456";
    passwordConfirmController.text = "123456";

    myFocusNode = FocusNode();
    super.initState();
  }


  /* Set the state of our form steps complete / editing / error / disabled */
  StepState stepState_0= StepState.editing;
  StepState stepState_1=StepState.disabled;
  StepState stepState_2=StepState.disabled;
  StepState stepState_3=StepState.disabled;

  /* Set the color of dropDown button based on validation*/
  Color dropDownValidation_0= Colors.grey;
  Color dropDownValidation_1= Colors.grey;
  Color dropDownValidation_2= Colors.grey;
  Color dropDownValidation_3= Colors.grey;

 /* Set form completion states*/
  bool stepComplete_0=false;
  bool stepComplete_1=false;
  bool stepComplete_2=false;
  bool stepComplete_3=false;


  /* Variable to track current form step*/
 int currentStep = 0;

  /* Track if all steps are complete*/
  bool complete = false;

  /* Variable to hold our state icons*/
  final Map<int, StepState> stepStateMapping = {
    0:StepState.editing,
    1:StepState.disabled,
    2:StepState.disabled,
    3:StepState.disabled
  };

  /* Map of steps and level of completion*/
  final Map<int, bool> stepCompleteMapping = {
    0:false,
    1:false,
    2:false,
    3:false
  };

  /* Used to validate Dropdowns based on "currentStep"*/
 bool validateSelectsBasedOnStep(){
   if(currentStep==0){
     if(selectedTitle==null || selectedSex==null){
       return false;
     }
     return true;
   }

   if(currentStep==1){
     if(selectedIdType==null || selectedState==null){
       return false;
     }
     return true;

   }
   return true;
 }

  /*Check if Map<T>stepKeyMapping which contains our list of steps is true or false based on the current step "currentStep".
    * To do this, we use !stepKeyMapping[currentStep].currentState.validate() which is similar to
    * form.currentState.validated(), returns true or false. We combine this with validateSelectsBasedOnStep()
    * which also returns true or false. validateSelectsBasedOnStep() is responsible for validating the dropdowns in each step
    * based on "currentStep". if  !stepKeyMapping[currentStep].currentState.validate() ||  validateSelectsBasedOnStep()==false
    * evaluates to false then we set the completion of the current step to false and set the appropriate step icon with
    * stepCompleteMapping[currentStep]=false and stepStateMapping[currentStep]=StepState.error.
    * If !stepKeyMapping[currentStep].currentState.validate() ||  validateSelectsBasedOnStep()==false evaluate to true
    * we set the completion of current state to "complete" with stepStateMapping[currentStep]=StepState.complete, set the next step
    * to editing with stepStateMapping[currentStep+1]=StepState.editing and update our Map of complete steps to true with
    * stepCompleteMapping[currentStep]=true.
    */
 bool validateSteps(){
    final Map<int, GlobalKey<FormState>> stepKeyMapping = {
      0:_formKey_0,
      1:_formKey_1,
      2:_formKey_2,
      3:_formKey_3
    };

    //Validate Dropdown field for title
    validateTitleField();
    //Validate Dropdown field for ID Type
    validateIdTypeField();
    //Validate Dropdown field for state
    validateStateField();
    //Validate Dropdown field for sex
    validateSexField();

    if (!stepKeyMapping[currentStep].currentState.validate() ||  validateSelectsBasedOnStep()==false) {
      stepCompleteMapping[currentStep]=false;
      stepStateMapping[currentStep]=StepState.error;
      return false;
    }
   stepStateMapping[currentStep]=StepState.complete;
   stepStateMapping[currentStep+1]=StepState.editing;
   stepCompleteMapping[currentStep]=true;
    return true;
   }

  /*
  * Check if user is done filling the form
  * We loop through our Map stepCompleteMapping which holds a list of key to form mapping eg stepCompleteMapping[0] means
  * step 1 or form 1. If any step is false we update our global flag "stepsComplete" to false or true depending on weather
  * we find a true or false while looping.
  */
  bool formValidationComplete(){
   bool stepsComplete=false;
   stepCompleteMapping.forEach((index,value)=> stepCompleteMapping[index]==true ? stepsComplete=true :  stepsComplete=false);
   if(stepsComplete)
      return true;
    else
      return false;
  }

  /*
  *  We check is the
  */
  next() { if(currentStep==3 && formValidationComplete()) submit() /*print(currentStep)*/;
  validateSteps() ?
      //currentStep + 1 != 4 ? goTo(currentStep + 1) : setState(() => complete = true);
    currentStep  != buildSteps().length-1  ?
    currentStep++ : setState(() => complete = true) :
    setState(() => complete = false) ;

   //print("going forward $currentStep");
  }

  /*
  * We check to see if the currentStep is greater than 0, because 0 means first step.
  * If it's greater than 0 then we can set the current step to disabled and move the user to
  * the previous step. The disabled feature just keeps the user from clicking a step to select, we
  * prefer the form is sequentially filled up to the point of submission.
  */
  cancel() {
    if (currentStep > 0) {
      setState(() {
        stepStateMapping[currentStep]=StepState.disabled;
        currentStep--;
        stepStateMapping[currentStep]=StepState.editing;
        //print("going back $currentStep");
      });

    }
  }


  /*
  * Map stepCompleteMapping holds a list of completion values for our step
  * example stepCompleteMapping[0] might be false meaning the first step
  * has not been filled completely. Once any step is completed the step
  * icon changes to a check sign. We test if the current step != step passed to us
  * from stepper callback, if it's not then the user is moving to another step and we need to set the right
  * icon for the previous step.
  */
  goTo(int step) {
    //setState(() => currentStep = step);
    setState(() {
      if(currentStep!=step){
        stepCompleteMapping[currentStep]==true ? stepStateMapping[currentStep]=StepState.complete : stepStateMapping[currentStep]=StepState.disabled;
        stepStateMapping[step]=StepState.editing;
        currentStep = step;
      }

      //stepStateMapping[currentStep]=StepState.editing;
    });

  }






  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async =>  modalWindowOpen ?  false : true,
      child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: true,
          //backgroundColor: Color(0xFF21BFBD),
          //backgroundColor: Colors.green,
          body:SafeArea(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[

                  Container(
                    color:Colors.green,
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
                          Text('Students Registration!!',style: TextStyle(color:Colors.white,fontSize: 25.0),),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Stepper(
                      controlsBuilder:
                          (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                        return Padding(
                          padding: const EdgeInsets.symmetric( horizontal: 10.0, vertical: 10.0),
                          child: StepControlButtons(currentStep: currentStep,onStepContinue: onStepContinue,onStepCancel: onStepCancel,),
                        );
                      },
                      type: StepperType.vertical,
                      currentStep: currentStep,
                      onStepContinue: next,
                      onStepTapped: (step) => goTo(step),
                      onStepCancel: cancel,
                      steps: buildSteps(),
                    ),
                  ),


                ],

              ),
            ),
          )


      ),
    );
 }

  @override
  void dispose() {

    //titleController.dispose();
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    idNumberController.dispose();
    addressController.dispose();
    //sexController.dispose();
    cityController.dispose();
    //stateController.dispose();
    dobController.dispose();
    //idTypeController.dispose();
    phoneController.dispose();
    emailController.dispose();
    //regTypeController.dispose();
    instituteSchoolController.dispose();
    matriculationExamNumberController.dispose();
    levelExpectedGraduationYearController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    myFocusNode.dispose();
    super.dispose();
 }



}

class StepControlButtons extends StatelessWidget {
  const StepControlButtons({
    Key key,
    @required this.currentStep,this.onStepContinue, this.onStepCancel
  }) : super(key: key);

  final int currentStep;
  final Function onStepContinue;
  final Function onStepCancel;

  @override
  Widget build(BuildContext context) {

   return   currentStep!=0 ? Row(

      children: <Widget>[

           FlatButton(
            color: Colors.green,
            textColor: Colors.white,
            onPressed: onStepContinue,
            child:  currentStep==3 ?  const Text('REGISTER') : const Text('CONTINUE')  ,
          ),

        FlatButton(
          onPressed: onStepCancel,
          child:  currentStep==0 ? const Text('')  : const Text('PREVIOUS'),
        ),
      ],
     ) :
   Row(
     children: <Widget>[
   Expanded(
     child: FlatButton(
       color: Colors.green,
       textColor: Colors.white,
       onPressed: onStepContinue,
       child:  Text('CONTINUE')  ,
     ),
   ),
     ],
   );





  }
}


import 'package:flutter_todo/models/payment.dart';

class  Student{
  int id;
  Map state;
  String email;
  String phone;
  String title;
  String firstName;
  String middleName;
  String lastName;
  String address;
  String sex;
  String city;
  String dateOfBirth;
  String idType;
  String idNumber;
  String passport;
  String regType;
  String cardHolderType;
  String instituteSchool;
  String matriculationExamNumber;
  String levelExpectedGraduationYear;
  String callNumberNYSC;
  String placeOfPrimaryAssignment;
  String createdAt;
  String updatedAt;
  List<Payment> payments;


  Student({this.id,this.state,this.email, this.phone,this.title,this.firstName,this.middleName,this.lastName,this.address,this.sex,this.city,this.dateOfBirth,this.idType,this.idNumber,this.passport,this.regType,this.cardHolderType,this.instituteSchool,this.matriculationExamNumber,this.levelExpectedGraduationYear,this.callNumberNYSC,this.placeOfPrimaryAssignment,this.createdAt,this.updatedAt,this.payments});

  factory Student.fromJson(Map<String, dynamic> json) {
    final payment= json['payments'];
   List<Payment> dataList= payment.map<Payment>((data)=>Payment.fromJson(data)).toList();
    return Student(
      id: json['id'] as int,
      title: json['title'] as String,
      firstName: json['first_name'] as String,
      middleName: json['middle_name'] as String,
      lastName: json['last_name'] as String,
      address: json['address'] as String,
      sex: json['sex'] as String,
      city: json['city'] as String,
      state:{'id':json['state']['id'],'name':json['state']['name']},
      dateOfBirth: json['dob'] as String,
      idType: json['id_type'] as String,
      idNumber: json['id_number'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      passport: json['passport'] as String,
      regType: json['reg_type'] as String,
        cardHolderType: json['card_holder_type'] as String,
      instituteSchool: json['institute_school'] as dynamic,
      matriculationExamNumber: json['mat_exam_num'] as dynamic,
      levelExpectedGraduationYear: json['level_expected_grauation_year'] as dynamic,
        callNumberNYSC: json['nysc_call_up_number'] as dynamic,
        placeOfPrimaryAssignment: json['place_of_primary'] as dynamic,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      payments: dataList

    );
  }


}
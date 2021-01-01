class  Message{
  int id;
  int userId;
  String email;
  String accountType;
  String name;
  String message;
  String status;
  String createdAt;
  String updatedAt;


  Message({this.id,this.userId,this.name,this.email,this.accountType,this.message,this.status, this.createdAt,this.updatedAt});

  factory Message.fromJson(Map<String, dynamic> json) {


    return Message(
      id: json['id'] as int,
      userId: json['user_id'] as dynamic,
      email: json['email'] as String,
      accountType: json['account_type'] as String,
      name: json['name'] as String,
      status: json['status'] as String,
      message: json['message'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }


}
class  Payment{

  int id;
  String type;
  int userId;
  String reference;
  String status;
  int amount;
  String expiry;
  String registered;
  String delivery;
  String createdAt;
  String updatedAt;

  Payment({this.id,this.type,this.userId,this.reference,this.status,this.amount,this.delivery,this.expiry,this.registered,this.createdAt,this.updatedAt});

  factory Payment.fromJson(Map<String, dynamic> json) {

    return Payment(
      id: json['id'],
      type: json['type'],
      userId: json['user_id'],
      reference: json['reference'],
      status: json['status'] ,
      amount: json['amount'],
      delivery: json['delivery'],
        expiry: json['expiry'],
        registered: json['registered'],
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String
    );
  }


}
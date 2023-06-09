class UserModel {
  String? id;
  String? fullName;
  String? phone;
  String? email;
  String? password;
  String? accountType;
  String? busNumber;
  String? image;
  String? date;
  String? fcmToken;
  

  UserModel({
    this.id,
    this.fullName,
    this.phone,
    this.email,
    this.password,
    this.accountType = '',
    this.busNumber = '',
    this.image = "avatar.jpg",
    this.date,
    this.fcmToken,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    accountType = json['accountType'];
    busNumber = json['busNumber'];
    image = json['image'];
    date = json['date'];
    fcmToken = json['fcmToken'];
  }

   Map<String, dynamic> toJson() {
     Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullName'] = this.fullName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['password'] = this.password;
    data['accountType'] = this.accountType;
    data['busNumber'] = this.busNumber;
    data['image'] = this.image;
    data['date'] = this.date;
    data['fcmToken'] = this.fcmToken;
    return data;
  }
}

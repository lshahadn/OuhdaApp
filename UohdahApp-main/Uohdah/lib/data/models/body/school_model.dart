import 'package:bustracking/data/models/body/user_model.dart';

class SchoolModel {
  String? id;
  String? schoolName;
  String? email;
  String? created_at;

  SchoolModel({
    this.id,
    this.schoolName,
    this.email,
    this.created_at,
  });

  SchoolModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    schoolName = json['schoolName'];
    email = json['email'];
    created_at = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.created_at;
    data['schoolName'] = this.schoolName;
    data['email'] = this.email;
    return data;
  }
}

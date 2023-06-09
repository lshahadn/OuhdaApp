import 'package:bustracking/data/models/body/user_model.dart';

class NotificationModel {
  String? id;
  String? title;
  String? body;
  String? created_at;

  NotificationModel({
    this.id,
    this.title,
    this.body,
    this.created_at,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    created_at = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.created_at;
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }
}

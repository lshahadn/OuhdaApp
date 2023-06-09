import 'package:bustracking/data/models/body/user_model.dart';

class RouteModel {
  String? id;
  String? route;
  String? lng;
  String? lat;
  String? created_at;

  RouteModel({
    this.id,
    this.route,
    this.lng,
    this.lat,
    this.created_at,
  });

  RouteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    route = json['route'];
    lat = json['lat'];
    lng = json['lng'];
    created_at = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.created_at;
    data['route'] = this.route;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

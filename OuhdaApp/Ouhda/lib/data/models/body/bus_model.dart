import 'package:bustracking/data/models/body/route_model.dart';
import 'package:bustracking/data/models/body/user_model.dart';

class BusModel {
  String? id;
  String? bus_number;
  RouteModel? route;
  String? created_at;

  BusModel({
    this.id,
    this.bus_number,
    this.route,
    this.created_at,
  });

  BusModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bus_number = json['bus_number'];
    route = RouteModel.fromJson(json['route']);
    created_at = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.created_at;
    data['bus_number'] = this.bus_number;
    data['route'] = this.route!.toJson();
    return data;
  }
}

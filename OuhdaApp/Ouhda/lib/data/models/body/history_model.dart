import 'package:bustracking/data/models/body/route_model.dart';
import 'package:bustracking/data/models/body/user_model.dart';

class HistoryModel {
  String? id;
  String? date;
  String? to_bus_at;
  String? at_school;
  String? return_to_bus_at;
  String? return_to_parent_at;
  String? driver_id;

  HistoryModel({
    this.id,
    this.date,
    this.to_bus_at,
    this.at_school,
    this.return_to_bus_at,
    this.return_to_parent_at,
    this.driver_id,
  });

  HistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    to_bus_at = json['to_bus_at'];
    at_school = json['at_school'];
    return_to_bus_at = json['return_to_bus_at'];
    return_to_parent_at = json['return_to_parent_at'];
    driver_id = json['driver_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['to_bus_at'] = this.to_bus_at;
    data['at_school'] = this.at_school;
    data['return_to_bus_at'] = this.return_to_bus_at;
    data['return_to_parent_at'] = this.return_to_parent_at;
    data['driver_id'] = this.driver_id;
    return data;
  }
}

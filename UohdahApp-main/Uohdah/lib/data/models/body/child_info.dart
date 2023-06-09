import 'package:bustracking/data/models/body/bus_model.dart';
import 'package:bustracking/data/models/body/school_model.dart';
import 'package:bustracking/data/models/body/user_model.dart';

class ChildModel {
  String? id;
  String? name;
  String? address;
  SchoolModel? school;
  BusModel? bus;
  String? className;
  String? image;
  String? status;
  String? parentId;
  String? parentPhone;
  String? datePicked;
  String? dateAbsent;
  String? driverId;
  String? goOrReturn;

  ChildModel({
    this.id,
    this.name,
    this.address,
    this.school,
    this.bus,
    this.className,
    this.image,
    this.status,
    this.parentId,
    this.parentPhone,
    this.datePicked,
    this.dateAbsent,
    this.driverId,
    this.goOrReturn,
  });

  ChildModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    school = SchoolModel.fromJson(json['school']);
    bus = BusModel.fromJson(json['bus']);
    className = json['className'];
    image = json['image'];
    status = json['status'];
    parentId = json['parentId'];
    parentPhone = json['parentPhone'];
    datePicked = json['datePicked'];
    dateAbsent = json['dateAbsent'];
    driverId = json['driverId'];
    goOrReturn = json['goOrReturn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['address'] = this.address;
    data['school'] = this.school!.toJson();
    data['bus'] = this.bus!.toJson();
    data['className'] = this.className;
    data['status'] = this.status;
    data['parentId'] = this.parentId;
    data['parentPhone'] = this.parentPhone;
    data['datePicked'] = this.datePicked;
    data['dateAbsent'] = this.dateAbsent;
    data['driverId'] = this.driverId;
    data['goOrReturn'] = this.goOrReturn;

    return data;
  }
}

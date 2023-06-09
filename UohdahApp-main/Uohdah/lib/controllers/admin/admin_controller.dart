import 'dart:io';

import 'package:bustracking/data/models/body/bus_model.dart';
import 'package:bustracking/data/models/body/child_info.dart';
import 'package:bustracking/data/models/body/config_model.dart';
import 'package:bustracking/data/models/body/route_model.dart';
import 'package:bustracking/data/models/body/school_model.dart';
import 'package:bustracking/data/models/body/user_model.dart';
import 'package:bustracking/data/repository/admin_repo.dart';
import 'package:bustracking/data/repository/parent_repo.dart';
import 'package:bustracking/data/repository/splash_repo.dart';
import 'package:bustracking/helper/route_helper.dart';
import 'package:bustracking/layout/widgets/custom_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AdminController extends GetxController implements GetxService {
  final AdminRepo adminRepo;
  AdminController({required this.adminRepo});

  bool _isLoading = false;
  File? image;
  List<RouteModel> routes = [RouteModel(id: "0", route: "Select Route")];
  List<UserModel> parents = [];
  RouteModel? selectedRoute;

  bool get isLoading => _isLoading;

  Future getRoutes() async {
    _isLoading = true;
    update();

    adminRepo.getRoutes().then((value) {
      routes = [RouteModel(id: "0", route: "Select Route")];
      print(value);
      value.forEach((element) {
        print(element);
        routes.add(RouteModel.fromJson(element.data()));
      });
      print("dddddd");
      _isLoading = false;
      update();
    }).catchError((err) {
      _isLoading = false;
      update();
    });
  }

  Future getParents() async {
    _isLoading = true;
    update();

    adminRepo.getParents().then((value) {
      parents = [];
      print(value);
      value.forEach((element) {
        print(element);
        parents.add(UserModel.fromJson(element.data()));
      });
      _isLoading = false;
      update();
    }).catchError((err) {
      _isLoading = false;
      update();
    });
  }

  Future<bool> addNewSchool(email, schoolName) async {
    bool status = true;
    _isLoading = true;
    update();

    SchoolModel model = SchoolModel(
      schoolName: schoolName,
      email: email,
      created_at: DateTime.now().toIso8601String(),
    );
    adminRepo.addNewSchool(model).then((value) {
      print(value);
      _isLoading = false;
      update();
      status = value;
    }).catchError((err) {
      _isLoading = false;
      update();
      status = false;
    });

    return status;
  }

  Future<bool> updateNewSchool(email, schoolName, id) async {
    bool status = true;
    _isLoading = true;
    update();

    adminRepo.updateNewSchool(email, schoolName, id).then((value) {
      print(value);
      _isLoading = false;
      update();
      status = value;
    }).catchError((err) {
      _isLoading = false;
      update();
      status = false;
    });

    return status;
  }

  deleteSchool(id) async {
    _isLoading = true;
    update();

    adminRepo.deleteSchool(id).then((value) {
      print(value);
      _isLoading = false;
      update();
      showCustomSnackBar("School Deleted Successfully!", isError: false);
    }).catchError((err) {
      _isLoading = false;
      update();
      showCustomSnackBar("Failed to Delete School!", isError: true);
    });
  }

   selectRoute(val) async {
    selectedRoute = val;
    update();
  }

  Future<bool> addNewBus(busNum, RouteModel route) async {
    bool status = true;
    _isLoading = true;
    update();

    BusModel model = BusModel(
      bus_number: busNum,
      route: route,
      created_at: DateTime.now().toIso8601String(),
    );
    adminRepo.addNewBus(model).then((value) {
      print(value);
      _isLoading = false;
      update();
      status = value;
    }).catchError((err) {
      _isLoading = false;
      update();
      status = false;
    });

    return status;
  }

  Future<bool> updateNewBus(busNum, RouteModel? route, id) async {
    bool status = true;
    _isLoading = true;
    update();

    adminRepo.updateNewBus(busNum, route, id).then((value) {
      print(value);
      _isLoading = false;
      update();
      status = value;
    }).catchError((err) {
      _isLoading = false;
      update();
      status = false;
    });

    return status;
  }

  deleteBus(id) async {
    _isLoading = true;
    update();

    adminRepo.deleteBus(id).then((value) {
      print(value);
      _isLoading = false;
      update();
      showCustomSnackBar("Bus Deleted Successfully!", isError: false);
    }).catchError((err) {
      _isLoading = false;
      update();
      showCustomSnackBar("Failed to Delete Bus!", isError: true);
    });
  }

  Future<bool> addNewRoute(route, lat, lng) async {
    bool status = true;
    _isLoading = true;
    update();

    RouteModel model = RouteModel(
      route: route,
      lat: lat,
      lng: lng,
      created_at: DateTime.now().toIso8601String(),
    );
    adminRepo.addNewRoute(model).then((value) {
      print(value);
      _isLoading = false;
      update();
      status = value;
    }).catchError((err) {
      _isLoading = false;
      update();
      status = false;
    });

    return status;
  }

  Future<bool> updateNewRoute(route, lat, lng, id) async {
    bool status = true;
    _isLoading = true;
    update();

    adminRepo.updateNewRoute(route, lat, lng, id).then((value) {
      print(value);
      _isLoading = false;
      update();
      status = value;
    }).catchError((err) {
      _isLoading = false;
      update();
      status = false;
    });

    return status;
  }

  deleteRoute(id) async {
    _isLoading = true;
    update();

    adminRepo.deleteRoute(id).then((value) {
      print(value);
      _isLoading = false;
      update();
      showCustomSnackBar("Route Deleted Successfully!", isError: false);
    }).catchError((err) {
      _isLoading = false;
      update();
      showCustomSnackBar("Failed to Delete Route!", isError: true);
    });
  }

  deleteUser(id) async {
    _isLoading = true;
    update();

    adminRepo.deleteUser(id).then((value) {
      print(value);
      _isLoading = false;
      update();
      showCustomSnackBar("Parent Deleted Successfully!", isError: false);
    }).catchError((err) {
      _isLoading = false;
      update();
      showCustomSnackBar("Failed to Delete Parent!", isError: true);
    });
  }
}

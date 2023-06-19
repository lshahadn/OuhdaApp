import 'package:bustracking/data/models/body/bus_model.dart';
import 'package:bustracking/data/models/body/child_info.dart';
import 'package:bustracking/data/models/body/route_model.dart';
import 'package:bustracking/data/models/body/school_model.dart';
import 'package:bustracking/util/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminRepo {
  final SharedPreferences sharedPreferences;
  AdminRepo({required this.sharedPreferences});

  Future getRoutes() async {
    var routes;
    await FirebaseFirestore.instance.collection('routes').get().then((value) {
      routes = value.docs;
    });

    return routes;
  }

  Future getParents() async {
    var parents;
    await FirebaseFirestore.instance
        .collection('users')
        .where('accountType', isEqualTo: 'parent')
        .get()
        .then((value) {
      parents = value.docs;
    });

    return parents;
  }

  Future<bool> addNewSchool(SchoolModel model) async {
    bool status = true;
    FirebaseFirestore.instance
        .collection('schools')
        .add(model.toJson())
        .then((value) {
      FirebaseFirestore.instance
          .collection('schools')
          .doc(value.id)
          .update({"id": value.id});
    }).catchError((error) {
      print(error.toString());
      status = false;
    });
    print(status);
    return status;
  }

  Future<bool> updateNewSchool(email, className, id) async {
    bool status = true;
    FirebaseFirestore.instance
        .collection('schools')
        .doc(id)
        .update({"email": email, "schoolName": className})
        .then((value) {})
        .catchError((error) {
          print(error.toString());
          status = false;
        });
    print(status);
    return status;
  }

  Future<bool> deleteSchool(id) async {
    bool status = true;
    FirebaseFirestore.instance
        .collection('schools')
        .doc(id)
        .delete()
        .then((value) {})
        .catchError((error) {
      print(error.toString());
      status = false;
    });
    print(status);
    return status;
  }

  Future<bool> addNewBus(BusModel model) async {
    bool status = true;
    FirebaseFirestore.instance
        .collection('bus')
        .add(model.toJson())
        .then((value) {
          
      FirebaseFirestore.instance
          .collection('bus')
          .doc(value.id)
          .update({"id": value.id});
    }).catchError((error) {
      print(error.toString());
      status = false;
    });
    print(status);
    return status;
  }

  Future<bool> updateNewBus(busNum, RouteModel? route, id) async {
    bool status = true;
    FirebaseFirestore.instance
        .collection('bus')
        .doc(id)
        .update(route != null
            ? {"bus_number": busNum, "route": route.toJson()}
            : {"bus_number": busNum})
        .then((value) {})
        .catchError((error) {
      print(error.toString());
      status = false;
    });
    print(status);
    return status;
  }

  Future<bool> deleteBus(id) async {
    bool status = true;
    FirebaseFirestore.instance
        .collection('bus')
        .doc(id)
        .delete()
        .then((value) {})
        .catchError((error) {
      print(error.toString());
      status = false;
    });
    print(status);
    return status;
  }

  Future<bool> addNewRoute(RouteModel model) async {
    bool status = true;
    FirebaseFirestore.instance
        .collection('routes')
        .add(model.toJson())
        .then((value) {
      FirebaseFirestore.instance
          .collection('routes')
          .doc(value.id)
          .update({"id": value.id});
    }).catchError((error) {
      print(error.toString());
      status = false;
    });
    print(status);
    return status;
  }

  Future<bool> updateNewRoute(route, lat, lng, id) async {
    bool status = true;
    FirebaseFirestore.instance
        .collection('routes')
        .doc(id)
        .update({"route": route, 'lat': lat, 'lng': lng})
        .then((value) {})
        .catchError((error) {
          print(error.toString());
          status = false;
        });
    print(status);
    return status;
  }

  Future<bool> deleteRoute(id) async {
    bool status = true;
    FirebaseFirestore.instance
        .collection('routes')
        .doc(id)
        .delete()
        .then((value) {})
        .catchError((error) {
      print(error.toString());
      status = false;
    });
    print(status);
    return status;
  }

  Future<bool> deleteUser(id) async {
    bool status = true;
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .delete()
        .then((value) {})
        .catchError((error) {
      print(error.toString());
      status = false;
    });
    print(status);
    return status;
  }
}

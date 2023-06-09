import 'dart:io';

import 'package:bustracking/data/models/body/bus_model.dart';
import 'package:bustracking/data/models/body/child_info.dart';
import 'package:bustracking/data/models/body/config_model.dart';
import 'package:bustracking/data/models/body/history_model.dart';
import 'package:bustracking/data/models/body/route_model.dart';
import 'package:bustracking/data/models/body/school_model.dart';
import 'package:bustracking/data/models/body/user_model.dart';
import 'package:bustracking/data/repository/parent_repo.dart';
import 'package:bustracking/data/repository/splash_repo.dart';
import 'package:bustracking/layout/widgets/custom_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ParentController extends GetxController implements GetxService {
  final ParentRepo parnetRepo;
  ParentController({required this.parnetRepo});

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firebase = FirebaseFirestore.instance;
  bool _isLoading = false;
  bool _isImageLoading = false;
  File? image;
  List<BusModel> buses = [
    BusModel(
        id: "0",
        bus_number: "Select Bus Number",
        route: RouteModel(route: 'Select Route'))
  ];
  List<SchoolModel> schools = [
    SchoolModel(
      id: "0",
      schoolName: "Select School",
    )
  ];
  SchoolModel? selectedSchool;
  BusModel? selectedBus;
  UserModel? driver;

  List<HistoryModel> history = [];
  List<UserModel> drivers = [
    UserModel(fullName: "Select Driver", id: "0"),
  ];

  UserModel? selectedDriver;
  bool get isLoading => _isLoading;
  bool get isImageLoading => _isImageLoading;

  Future getBuses() async {
    _isLoading = true;
    update();

    parnetRepo.getBuses().then((value) {
      buses = [
        BusModel(
            id: "0",
            bus_number: "Select Bus Number",
            route: RouteModel(route: 'Select Route'))
      ];
      print(value);
      value.forEach((element) {
        print(element);
        buses.add(BusModel.fromJson(element.data()));
      });
      _isLoading = false;
      update();
    }).catchError((err) {
      _isLoading = false;
      update();
    });
  }

  String getUsername() {
    return parnetRepo.getUsername();
  }

  String getCurrentUserID() {
    return parnetRepo.getCurrentUserID();
  }

  String getCurrentUserPhone() {
    return parnetRepo.getPhone();
  }

  Future selectImage() async {
    _isImageLoading = true;
    update();
    final _image = await ImagePicker().getImage(source: ImageSource.gallery);
    image = File(_image!.path);
    _isImageLoading = false;
    update();
  }

  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> uploadImage(File file) async {
    // Create a reference to the location where you want to store the file in Firebase Storage
    Reference ref = storage.ref().child('images/${DateTime.now().toString()}');

    // Upload the file to Firebase Storage
    UploadTask uploadTask = ref.putFile(file);

    // Wait for the upload to complete and return the download URL
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    // Return the download URL
    return downloadUrl;
  }

  Future<bool> addNewChild(fullName, address, className,
      SchoolModel selectedSchool, driver, BusModel bus) async {
    bool status = true;
    _isLoading = true;
    update();
    print(selectedDriver!.id);
    await uploadImage(image!).then((value) async {
      ChildModel model = ChildModel(
          name: fullName,
          address: address,
          school: selectedSchool,
          bus: bus,
          className: className,
          driverId: selectedDriver!.id.toString(),
          parentId: getCurrentUserID(),
          parentPhone: getCurrentUserPhone(),
          status: 'at_home',
          goOrReturn: 'at_home',
          dateAbsent: '',
          datePicked: '',
          image: value);
      await parnetRepo.addNewChild(model).then((value) {
        print(value);
        _isLoading = false;
        status = value;
        selectedDriver = null;
        selectedBus = null;
        image = null;
        update();
      });
    }).catchError((err) {
      _isLoading = false;
      update();
      status = false;
    });

    return status;
  }

  void selectDriver(val) {
    selectedDriver = val;
    update();
  }

  void selectSchool(val) {
    selectedSchool = val;
    update();
  }

  Future getSchools() async {
    _isLoading = true;
    update();

    parnetRepo.getSchools().then((value) {
      schools = [
        SchoolModel(
          id: "0",
          schoolName: "Select School",
        )
      ];
      value.forEach((element) {
        print(element);
        schools.add(SchoolModel.fromJson(element.data()));
      });
      _isLoading = false;
      update();
    }).catchError((err) {
      _isLoading = false;
      update();
    });
  }

  Future getDrivers() async {
    _isLoading = true;
    update();

    parnetRepo.getDrivers().then((value) {
      drivers = [UserModel(fullName: "Select Driver", id: "0")];
      print(value);
      value.forEach((element) {
        print(element);
        drivers.add(UserModel.fromJson(element.data()));
      });
      _isLoading = false;
      update();
    }).catchError((err) {
      _isLoading = false;
      update();
    });
  }

  Future getAllHistoryOfStudent(id) async {
    _isLoading = true;
    update();
    print("------- id -----------");
    print(id);

    parnetRepo.getAllHistoryOfStudent(id).then((value) {
      history = [];
      print(value);
      value.forEach((element) {
        print(element);
        history.add(HistoryModel.fromJson(element.data()));
      });
      print(history);
      _isLoading = false;
      update();
    }).catchError((err) {
      _isLoading = false;
      update();
    });
  }

  Future getDriver(id) async {
    _isLoading = true;
    update();

    parnetRepo.getDriver(id).then((value) {
      print(value);
      value.forEach((element) {
        driver = UserModel.fromJson(element.data());
        selectedDriver = UserModel.fromJson(element.data());
      });
      _isLoading = false;
      update();
    }).catchError((err) {
      _isLoading = false;
      update();
    });
  }

  UserModel? parent;

  Future getParent(id) async {
    _isLoading = true;
    update();

    parnetRepo.getDriver(id).then((value) {
      print(value);
      value.forEach((element) {
        parent = UserModel.fromJson(element.data());
      });
      _isLoading = false;
      update();
    }).catchError((err) {
      _isLoading = false;
      update();
    });
  }

  bool markAsAbsent(id, name, driverId) {
    bool status = true;
    _isLoading = true;
    update();

    parnetRepo.markAsAbsent(id, name, driverId).then((value) {
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

  void selectBus(val) {
    selectedBus = val;
    update();
  }

  deleteChild(id) async {
    _isLoading = true;
    update();

    parnetRepo.deleteChild(id).then((value) {
      print(value);
      _isLoading = false;
      update();
      showCustomSnackBar("Child Deleted Successfully!", isError: false);
    }).catchError((err) {
      _isLoading = false;
      update();
      showCustomSnackBar("Failed to Delete Child!", isError: true);
    });
  }

  Future<bool> updateChild(id, fullName, school, className) async {
    bool status = true;
    _isLoading = true;
    update();

    if (image != null) {
      await uploadImage(image!).then((value) async {
        parnetRepo
            .updateChild(id, value, fullName, school, className)
            .then((value) {
          print(value);
          _isLoading = false;
          update();
          status = value;
        }).catchError((err) {
          _isLoading = false;
          update();
          status = false;
        });
      }).catchError((err) {
        _isLoading = false;
        update();
        status = false;
      });
    } else {
      parnetRepo.updateChild(id, '', fullName, school, className).then((value) {
        print(value);
        _isLoading = false;
        update();
        status = value;
      }).catchError((err) {
        _isLoading = false;
        update();
        status = false;
      });
    }

    return status;
  }
}

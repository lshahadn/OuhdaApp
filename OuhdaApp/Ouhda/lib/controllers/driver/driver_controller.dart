import 'dart:io';

import 'package:bustracking/data/models/body/child_info.dart';
import 'package:bustracking/data/models/body/config_model.dart';
import 'package:bustracking/data/models/body/user_model.dart';
import 'package:bustracking/data/repository/driver_repo.dart';
import 'package:bustracking/data/repository/parent_repo.dart';
import 'package:bustracking/data/repository/splash_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DriverController extends GetxController implements GetxService {
  final DriverRepo driverRepo;
  DriverController({required this.driverRepo});

  bool _isLoading = false;
  String allLength = '0';
  String pickedLength = '0';
  String droppedLength = '0';
  String absentLength = '0';
  bool _isImageLoading = false;
  File? image;

  bool get isLoading => _isLoading;
  bool get isImageLoading => _isImageLoading;

  String getUsername() {
    return driverRepo.getUsername();
  }

  String getCurrentUserID() {
    return driverRepo.getCurrentUserID();
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

  bool markAs(mark, id, name, parentId, goOrReturn) {
    bool status = true;
    _isLoading = true;
    update();

    driverRepo.markAs(mark, id, name, parentId, goOrReturn).then((value) {
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

  Future<String> getLengthOfEachStatus(String type) async {
    try {
      final query = buildChildrenQuery(type);
      final snapshots = await query.get();
      return snapshots.docs.length.toString();
    } catch (e) {
      // Handle the error here (e.g. show an error message to the user)
      print('Error retrieving query snapshots: $e');
      return '0';
    }
  }

  Future<void> getDataOf(type) async {
    if (type == 'picked') {
      pickedLength = await getLengthOfEachStatus('picked');
    } else if (type == 'drop') {
      droppedLength = await getLengthOfEachStatus('drop');
    } else if (type == 'absent') {
      absentLength = await getLengthOfEachStatus('absent');
    } else {
      allLength = await getLengthOfEachStatus('all');
    }
  }

  Query buildChildrenQuery(String type) {
    final query = FirebaseFirestore.instance
        .collection('children')
        .where('driverId', isEqualTo: getCurrentUserID());

    if (type == 'picked') {
      return query.where('status', isEqualTo: 'picked');
    } else if (type == 'drop') {
      return query.where('status', whereIn: ['drop', 'at_school']);
    } else if (type == 'absent') {
      return query.where('status', isEqualTo: 'absent');
    } else {
      return query;
    }
  }

  Future<bool> startTrip() async {
    bool status = true;
    _isLoading = true;
    update();
    await driverRepo.startTrip().then((value) {
      print(value);
      _isLoading = false;
      status = value;
      update();
    });

    return status;
  }

  Future<bool> endTrip(duration) async {
    bool status = true;
    _isLoading = true;
    update();
    await driverRepo.endTrip(duration).then((value) {
      print(value);
      _isLoading = false;
      status = value;
      update();
    });

    return status;
  }

  getParent(id) async {
    _isLoading = true;
    update();

    driverRepo.getParent(id).then((value) {
      print(value);
      value.forEach((element) {
        return UserModel.fromJson(element.data());
      });
      _isLoading = false;
      update();
    }).catchError((err) {
      _isLoading = false;
      update();
    });
    return UserModel(id: '0');
  }
}

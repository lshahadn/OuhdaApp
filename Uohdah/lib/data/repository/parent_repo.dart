import 'package:bustracking/data/models/body/bus_model.dart';
import 'package:bustracking/data/models/body/child_info.dart';
import 'package:bustracking/data/models/body/notification_model.dart';
import 'package:bustracking/util/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParentRepo {
  final SharedPreferences sharedPreferences;
  ParentRepo({required this.sharedPreferences});

  String getUsername() {
    return sharedPreferences.getString(AppConstants.USER_NAME) ?? '';
  }

  String getPhone() {
    return sharedPreferences.getString(AppConstants.PHONE) ?? '';
  }

  String getCurrentUserID() {
    return sharedPreferences.getString(AppConstants.USER_ID) ?? '';
  }

  Future<bool> addNewChild(ChildModel model) async {
    bool status = true;
    try {
      final userRef = FirebaseFirestore.instance.collection('children');
      final userDoc = await userRef.add(model.toJson());
      await userDoc.update({"id": userDoc.id});
    } catch (error) {
      print(error.toString());
      status = false;
    }
    print(status);
    return status;
  }

  Future getDrivers() async {
    var drivers;
    await FirebaseFirestore.instance
        .collection('users')
        .where("accountType", isEqualTo: 'driver')
        .get()
        .then((value) {
      drivers = value.docs;
    });

    return drivers;
  }

  Future getSchools() async {
    var schools;
    await FirebaseFirestore.instance.collection('schools').get().then((value) {
      schools = value.docs;
    });

    return schools;
  }

  Future getAllHistoryOfStudent(id) async {
    print("___________ lasr ___________");
    print(id);
    var history;
    await FirebaseFirestore.instance
        .collection('children')
        // .doc('7y4TdO9w1mncIdrh1rjo')
        .doc(id)
        .collection("history")
        .get()
        .then((value) {
      history = value.docs;
      print(" -------------- history --------------");
      print(history);
    });

    return history;
  }

  Future getDriver(id) async {
    var driver;
    await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: id)
        .get()
        .then((value) {
      driver = value.docs;
    });

    return driver;
  }

  Future getBuses() async {
    var buses;
    await FirebaseFirestore.instance.collection('bus').get().then((value) {
      buses = value.docs;
    });

    return buses;
  }

  Future<bool> deleteChild(id) async {
    bool status = true;
    FirebaseFirestore.instance
        .collection('children')
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

  Future<bool> updateChild(id, image, fullName, school, className) async {
    bool status = true;
    print('id');
    print(id);
    FirebaseFirestore.instance
        .collection('children')
        .doc(id.toString())
        .update(image != ''
            ? {
                "name": fullName,
                'className': className,
                'image': image
              }
            : {"name": fullName, 'className': className})
        .then((value) {})
        .catchError((error) {
      print(error.toString());
      status = false;
    });
    print(status);
    return status;
  }

  Future<void> sendNotification(String title, String message, parentId) async {
    try {
      NotificationModel model = NotificationModel(
          title: title,
          body: message,
          created_at: DateTime.now().toIso8601String());
      await addNewNotification(model, parentId);
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  Future<bool> addNewNotification(NotificationModel model, parentId) async {
    bool status = true;
    try {
      final notificationRef = FirebaseFirestore.instance
          .collection('users')
          .doc(parentId)
          .collection('notifications');
      final notificationDoc = await notificationRef.add(model.toJson());
      await notificationDoc.update({"id": notificationDoc.id});
    } catch (error) {
      print(error.toString());
      status = false;
    }
    print(status);
    return status;
  }

  Future<bool> markAsAbsent(id, name, driverId) async {
    bool status = true;
    final today = DateTime.now();
    final dateOnly = DateTime(today.year, today.month, today.day);
    var dateAsString = '${dateOnly.day}/${dateOnly.month}/${dateOnly.year}';
    // Update status for the child
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('children')
        .where('id', isEqualTo: id)
        .get();

    final List<DocumentSnapshot> documentsToUpdate = querySnapshot.docs;

    for (DocumentSnapshot document in documentsToUpdate) {
      final DocumentReference documentRef =
          FirebaseFirestore.instance.collection('children').doc(document.id);

      await documentRef.update({
        'status': 'absent',
        'dateAbsent': dateAsString,
      }).then((value) {
        sendNotification(
            'Child Absent', 'Sorry, My child $name is absent today!', driverId);
      }).catchError((error) {
        print(error.toString());
        status = false;
      });
    }

    print(status);
    return status;
  }
}

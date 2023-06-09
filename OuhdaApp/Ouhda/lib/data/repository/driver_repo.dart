import 'package:bustracking/data/models/body/child_info.dart';
import 'package:bustracking/data/models/body/notification_model.dart';
import 'package:bustracking/helper/notification_helper.dart';
import 'package:bustracking/util/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverRepo {
  final SharedPreferences sharedPreferences;
  DriverRepo({required this.sharedPreferences});

  String getUsername() {
    return sharedPreferences.getString(AppConstants.USER_NAME) ?? '';
  }

  String getCurrentUserID() {
    return sharedPreferences.getString(AppConstants.USER_ID) ?? '';
  }

  Future<void> sendNotification(String title, String message, parentId) async {
    try {
      // NotificationAPI.showNotification(
      //     title: title, body: message, payload: 'picked');
      NotificationModel model = NotificationModel(
          title: title,
          body: message,
          created_at: DateTime.now().toIso8601String());
      await addNewNotification(model, parentId);
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  Future<bool> markAs(mark, id, name, parentId, goOrReturn) async {
    final today = DateTime.now();
    final dateOnly = DateTime(today.year, today.month, today.day);
    var dateAsString = '${dateOnly.day}/${dateOnly.month}/${dateOnly.year}';
    bool status = true;
    // update driver status
    FirebaseFirestore.instance
        .collection('children')
        .doc(id)
        .update(mark == 'picked'
            ? {
                'status': mark,
                'datePicked': dateAsString,
                'goOrReturn': goOrReturn
              }
            : {
                'status': mark,
                'dateDrop': dateAsString,
                'goOrReturn': goOrReturn
              })
        .then((value) async {
      // send notification
      sendNotification(
          'Child Picked', 'Your child $name has been picked!', parentId);
      // Add To History
      final queryRef = FirebaseFirestore.instance
          .collection('children')
          .doc(id)
          .collection('history');

      var time = TimeOfDay.fromDateTime(today); // convert to TimeOfDay object

      try {
        print("------------- mark");
        print(mark);
        print(goOrReturn);
        if (mark == 'picked' && goOrReturn == 'to_bus') {
          final queryDoc = await queryRef.add({
            "date": dateAsString,
            "to_bus_at": '${time.hour}:${time.minute}',
            "driver_id": getCurrentUserID(),
          });
          await queryDoc.update({"id": queryDoc.id});
        } else if (mark == 'at_school') {
          final querySnapshot =
              await queryRef.where('date', isEqualTo: dateAsString).get();
          if (querySnapshot.size == 1) {
            final queryDoc = querySnapshot.docs.first;
            await _updateDocumentInTransaction(queryDoc.reference, {
              "at_school": '${time.hour}:${time.minute}',
            });
          }
        } else if (goOrReturn == 'return_to_bus') {
          final querySnapshot =
              await queryRef.where('date', isEqualTo: dateAsString).get();
          if (querySnapshot.size == 1) {
            final queryDoc = querySnapshot.docs.first;
            await _updateDocumentInTransaction(queryDoc.reference, {
              "return_to_bus_at": '${time.hour}:${time.minute}',
            });
          }
        } else if (goOrReturn == 'return_to_parent') {
          final querySnapshot =
              await queryRef.where('date', isEqualTo: dateAsString).get();
          if (querySnapshot.size == 1) {
            final queryDoc = querySnapshot.docs.first;
            await _updateDocumentInTransaction(queryDoc.reference, {
              "return_to_parent_at": '${time.hour}:${time.minute}',
            });
          }
        }
      } catch (e) {
        print('Error updating document: $e');
      }
    }).catchError((error) {
      print(error.toString());
      status = false;
    });

    print(status);
    return status;
  }

  Future<void> _updateDocumentInTransaction(
      DocumentReference reference, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      await transaction.update(reference, data);
    });
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

  String tripId = '';
  Future<bool> startTrip() async {
    final today = DateTime.now();
    final dateOnly = DateTime(today.year, today.month, today.day);
    var dateAsString = '${dateOnly.day}/${dateOnly.month}/${dateOnly.year}';
    var time = TimeOfDay.fromDateTime(today); // convert to TimeOfDay object

    bool status = true;
    try {
      final queryRef = FirebaseFirestore.instance.collection('history');
      final querySnapshot = await queryRef
          .where("date", isEqualTo: dateAsString)
          .get(); // Wait for the query execution

      if (querySnapshot.docs.isNotEmpty) {
        queryRef.where("date", isEqualTo: dateAsString).get().then((value) {
          queryRef.doc(value.docs[0].id).update({
            "return_at": '${time.hour}:${time.minute}',
            "status": "return",
          });
        });
        return status;
      } else {
        final queryDoc = await queryRef.add({
          "going_at": '${time.hour}:${time.minute}',
          "date": dateAsString,
          "status": "going",
          "driver_id": getCurrentUserID(),
        });
        await queryDoc.update({"id": queryDoc.id});
        tripId = queryDoc.id;
      }
    } catch (error) {
      print(error.toString());
      status = false;
    }
    print(status);
    return status;
  }

  Future<bool> endTrip(duration) async {
    final today = DateTime.now();
    final dateOnly = DateTime(today.year, today.month, today.day);
    var dateAsString = '${dateOnly.day}/${dateOnly.month}/${dateOnly.year}';
    var time = TimeOfDay.fromDateTime(today); // convert to TimeOfDay object

    bool status = true;
    try {
      final mainQueryRef = FirebaseFirestore.instance.collection('history');
      final querySnapshot = await mainQueryRef
          .where("date", isEqualTo: dateAsString)
          .where("status", isEqualTo: 'return')
          .get(); // Wait for the query execution

      if (querySnapshot.docs.isNotEmpty) {
        final mainDoc = querySnapshot.docs[0];
        await mainQueryRef.doc(mainDoc.id).update({
          "return_end_at": '${time.hour}:${time.minute}',
          "return_duration": duration,
        });
        return status;
      } else {
        final queryRef =
            FirebaseFirestore.instance.collection('history').doc(tripId);
        await queryRef.update({
          "going_end_at": '${time.hour}:${time.minute}',
          "going_duration": duration,
        });
        tripId = '';
      }
    } catch (error) {
      print(error.toString());
      status = false;
    }

    print(status);
    return status;
  }

    Future getParent(id) async {
    var parent;
    await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: id)
        .get()
        .then((value) {
      parent = value.docs;
    });

    return parent;
  }
}

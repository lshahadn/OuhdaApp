import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:bustracking/layout/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';

class AttendanceScanner extends StatefulWidget {
  const AttendanceScanner({Key? key}) : super(key: key);

  @override
  _AttendanceScannerState createState() => _AttendanceScannerState();
}

class _AttendanceScannerState extends State<AttendanceScanner> {
  bool _scanning = false;

  Future<void> _scanQRCode() async {
    // Request camera permission
    var cameraStatus = await Permission.camera.request();
    if (cameraStatus != PermissionStatus.granted) {
      // Permission not granted, show error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Camera access denied'),
          content:
              Text('Please grant camera permission to use the QR scanner.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    try {
      final result = await BarcodeScanner.scan();
      final id = result.rawContent;

      setState(() {
        _scanning = true;
      });

      // Add attendance record to Firestore
      FirebaseFirestore.instance.collection('children').doc(id).update({
        'status': 'picked',
        'datePicked': DateTime.now().toIso8601String()
      }).then((value) {
        showCustomSnackBar("Child Picked successfully!");
      }).catchError((err) {
        showCustomSnackBar("error: $err");
      });

      setState(() {
        _scanning = false;
      });
    } on PlatformException catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Unknown error'),
          content: Text('An unknown error occurred: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Scan QR Code to take attendance',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _scanning ? null : _scanQRCode,
              child: _scanning
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    )
                  : Text('Scan QR Code'),
            ),
          ],
        ),
      ),
    );
  }
}

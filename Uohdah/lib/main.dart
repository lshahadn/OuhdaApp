import 'dart:io';
import 'dart:ui';
import 'package:bustracking/layout/screens/splash/splash_screen.dart';

import 'helper/get_di.dart' as di;
import 'package:bustracking/controllers/auth_controller.dart';
import 'package:bustracking/controllers/splash_controller.dart';
import 'package:bustracking/data/models/body/notification_body.dart';
import 'package:bustracking/helper/notification_helper.dart';
import 'package:bustracking/helper/route_helper.dart';
import 'package:bustracking/theme/dark_theme.dart';
import 'package:bustracking/theme/light_theme.dart';
import 'package:bustracking/util/app_constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_utils/src/platform/platform.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();

  try {
    await Firebase.initializeApp();
    await di.init();

    FirebaseMessaging.instance.subscribeToTopic("messaging");
      await NotificationAPI.init();
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final NotificationBody? body;
  const MyApp({
    super.key,
    this.body,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(builder: (splashController) {
      return GetMaterialApp(
        title: AppConstants.APP_NAME,
        debugShowCheckedModeBanner: false,
        navigatorKey: Get.key,
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
        ),
        theme: light,
        initialRoute: RouteHelper.getSplashRoute(),
        getPages: RouteHelper.routes,
        // home: SplashScreen(),
        defaultTransition: Transition.topLevel,
        transitionDuration: const Duration(milliseconds: 500),
      );
    });
  }
}

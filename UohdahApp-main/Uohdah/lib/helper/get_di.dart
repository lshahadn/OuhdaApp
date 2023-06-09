import 'dart:convert';

import 'package:bustracking/controllers/admin/admin_controller.dart';
import 'package:bustracking/controllers/auth_controller.dart';
import 'package:bustracking/controllers/driver/driver_controller.dart';
import 'package:bustracking/controllers/location_controller.dart';
import 'package:bustracking/controllers/onboarding_controller.dart';
import 'package:bustracking/controllers/parent/parent_controller.dart';
import 'package:bustracking/controllers/splash_controller.dart';
import 'package:bustracking/data/repository/admin_repo.dart';
import 'package:bustracking/data/repository/auth_repo.dart';
import 'package:bustracking/data/repository/driver_repo.dart';
import 'package:bustracking/data/repository/location_repo.dart';
import 'package:bustracking/data/repository/onboarding_repo.dart';
import 'package:bustracking/data/repository/parent_repo.dart';
import 'package:bustracking/data/repository/splash_repo.dart';
import 'package:bustracking/data/repository/user_repo.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);

  // Repository
  Get.lazyPut(() => SplashRepo(sharedPreferences: Get.find()));
  Get.lazyPut(() => OnBoardingRepo());
  Get.lazyPut(() => AuthRepo(sharedPreferences: Get.find()));
  Get.lazyPut(() => ParentRepo( sharedPreferences: Get.find()));
  Get.lazyPut(() => AdminRepo(sharedPreferences: Get.find()));
  Get.lazyPut(() => DriverRepo(sharedPreferences: Get.find()));

  // Controller
  Get.lazyPut(() => SplashController(splashRepo: Get.find()));
  Get.lazyPut(() => OnBoardingController(onboardingRepo: Get.find()));
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => ParentController(parnetRepo: Get.find()));
  Get.lazyPut(() => AdminController(adminRepo: Get.find()));
  Get.lazyPut(() => DriverController(driverRepo: Get.find()));
  
  
}

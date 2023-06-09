import 'dart:convert';

import 'package:bustracking/controllers/splash_controller.dart';
import 'package:bustracking/data/models/body/child_info.dart';
import 'package:bustracking/data/models/body/notification_body.dart';
import 'package:bustracking/data/models/body/user_model.dart';
import 'package:bustracking/data/models/response/address_model.dart';
import 'package:bustracking/layout/screens/AdminScreens/bus/add_bus_screen.dart';
import 'package:bustracking/layout/screens/AdminScreens/bus/buss_screen.dart';
import 'package:bustracking/layout/screens/AdminScreens/drivers/drivers_screen.dart';
import 'package:bustracking/layout/screens/AdminScreens/parents/parents_screen.dart';
import 'package:bustracking/layout/screens/AdminScreens/routes/add_route_screen.dart';
import 'package:bustracking/layout/screens/AdminScreens/routes/routes_screen.dart';
import 'package:bustracking/layout/screens/AdminScreens/schools/add_school_screen.dart';
import 'package:bustracking/layout/screens/AdminScreens/schools/schools_screen.dart';
import 'package:bustracking/layout/screens/AdminScreens/tracking/history_bus_timeline_screen.dart';
import 'package:bustracking/layout/screens/AdminScreens/update_parent_screen.dart';
import 'package:bustracking/layout/screens/DriverScreens/AttendanceScanner.dart';
import 'package:bustracking/layout/screens/DriverScreens/home/driver_home_screen.dart';
import 'package:bustracking/layout/screens/DriverScreens/qr_generator_screen.dart';
import 'package:bustracking/layout/screens/ParentsScreens/home/update_child_screen.dart';
import 'package:bustracking/layout/screens/auth/forget_pass_screen.dart';
import 'package:bustracking/layout/screens/notifications_screen.dart';
import 'package:bustracking/layout/screens/ParentsScreens/home/add_child_screen.dart';
import 'package:bustracking/layout/screens/ParentsScreens/home/parent_home_screen.dart';
import 'package:bustracking/layout/screens/ParentsScreens/history/live_status_screen.dart';
import 'package:bustracking/layout/screens/profile/profile_screen.dart';
import 'package:bustracking/layout/screens/profile/update_profile_screen.dart';
import 'package:bustracking/layout/screens/auth/sign_in_screen.dart';
import 'package:bustracking/layout/screens/auth/sign_up_screen.dart';
import 'package:bustracking/layout/screens/splash/splash_screen.dart';
import 'package:bustracking/layout/widgets/not_found.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../layout/screens/AdminScreens/home/admin_home_screen.dart';

class RouteHelper {
  static const String initial = '/';
  static const String driverHome = '/driver-home';
  static const String parentHome = '/parent-home';
  static const String adminHome = '/admin-home';

  static const String splash = '/splash';
  static const String forgetPass = '/forget-pass';
  static const String onBoarding = '/on-boarding';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String accessLocation = '/access-location';
  static const String pickMap = '/pick-map';
  // --- admin routes -----
  static const String liveTrackingMap = '/live-tracking-map';
  static const String schools = '/schools';
  static const String addNewSchool = '/add-new-school';
  static const String bus = '/bus';
  static const String busHistory = '/bus-history';
  static const String addNewBus = '/add-new-bus';
  static const String routess = '/routess';
  static const String addNewRoute = '/add-new-route';
  static const String liveStatus = '/live-status';
  static const String addEditLocation = '/add-edit-location';
  static const String addChild = '/add-child';
  static const String parentAdmin = '/admin-parent';
  static const String driverAdmin = '/driver-parent';

  static const String main = '/main';
  static const String updateChild = '/update-child';

  static const String profile = '/profile';
  static const String updateProfile = '/update-profile';
  static const String updateParentProfile = '/update-parent-profile';
  static const String notification = '/notification';
  static const String map = '/map';
  static const String address = '/address';
  static const String qrGenerator = '/qr-generator';
  static const String attendanceScanner = '/attendance-scanner';

  static String getInitialRoute() => '$initial';
  static String getDriverHomeRoute() => '$driverHome';
  static String getParentHomeRoute() => '$parentHome';
  static String getAdminHomeRoute() => '$adminHome';
  static String getAdminParentRoute() => '$parentAdmin';
  static String getDriverAdminRoute() => '$driverAdmin';
  static String getQrGeneratorRoute() => '$qrGenerator';
  static String getAttendanceScannerRoute() => '$attendanceScanner';

  static String getLiveStatusRoute(ChildModel model) {
    List<int> _encoded = utf8.encode(jsonEncode(model.toJson()));
    String _data = base64Encode(_encoded);
    return '$liveStatus?model=$_data';
  }

  static String getAddEditLocationRoute() => '$addEditLocation';
  static String getAddChildRoute() => '$addChild';
  static String getSplashRoute() {
    return '$splash';
  }

  static String getOnBoardingRoute() => '$onBoarding';
  static String getSignInRoute() => '$signIn';
  static String getLiveTrackingMapRoute() => '$liveTrackingMap';
  static String getSchoolsRoute() => '$schools';
  static String getAddNewSchoolRoute() => '$addNewSchool';
  static String getBusRoute() => '$bus';
  static String getAddNewBusRoute() => '$addNewBus';
  static String getRoutesRoute() => '$routess';
  static String getAddNewRouteRoute() => '$addNewRoute';
  static String getSignUpRoute() => '$signUp';
  static String getForgetPassRoute() => '$forgetPass';
  static String getBusHistoryRoute() => '$busHistory';

  static String getAccessLocationRoute(String page) =>
      '$accessLocation?page=$page';
  static String getPickMapRoute(String page, bool canRoute) =>
      '$pickMap?page=$page&route=${canRoute.toString()}';
  // static String getInterestRoute() => '$interest';
  static String getMainRoute(String page) => '$main?page=$page';

  static String getProfileRoute() => '$profile';
  
  static String getUpdateProfileRoute(UserModel model) {
    List<int> _encoded = utf8.encode(jsonEncode(model.toJson()));
    String _data = base64Encode(_encoded);
    return '$updateProfile?model=$_data';
  }

  static String getUpdateParentProfileRoute(UserModel model) {
    List<int> _encoded = utf8.encode(jsonEncode(model.toJson()));
    String _data = base64Encode(_encoded);
    return '$updateParentProfile?model=$_data';
  }

  static String getUpdateChildRoute(ChildModel model) {
    List<int> _encoded = utf8.encode(jsonEncode(model.toJson()));
    String _data = base64Encode(_encoded);
    return '$updateChild?model=$_data';
  }

  static String getNotificationRoute() => '$notification';
  static String getMapRoute(AddressModel addressModel, String page) {
    List<int> _encoded = utf8.encode(jsonEncode(addressModel.toJson()));
    String _data = base64Encode(_encoded);
    return '$map?address=$_data&page=$page';
  }

  static String getAddressRoute() => '$address';

  static List<GetPage> routes = [
    GetPage(name: driverHome, page: () => getRoute(HomeDriverScreen())),
    GetPage(name: parentHome, page: () => getRoute(HomeParentScreen())),
    GetPage(name: adminHome, page: () => getRoute(HomeAdminScreen())),
    GetPage(name: driverAdmin, page: () => getRoute(DriversScreen())),
    GetPage(name: forgetPass, page: () => getRoute(ForgetPasswordScreen())),
    GetPage(
        name: liveStatus,
        page: () {
          List<int> _decode =
              base64Decode(Get.parameters['model']!.replaceAll(' ', '+'));
          ChildModel _data =
              ChildModel.fromJson(jsonDecode(utf8.decode(_decode)));
          return LiveStatusScreen(model: _data);
        }),

    GetPage(name: addChild, page: () => getRoute(AddChildScreen())),
    GetPage(name: busHistory, page: () => getRoute(BusHistoryTimeline())),
    GetPage(name: addNewSchool, page: () => getRoute(AddSchoolScreen())),
    GetPage(name: schools, page: () => getRoute(SchoolsScreen())),
    GetPage(name: addNewBus, page: () => getRoute(AddBusScreen())),
    GetPage(name: bus, page: () => getRoute(BussScreen())),
    GetPage(name: addNewRoute, page: () => getRoute(AddRouteScreen())),
    GetPage(name: routess, page: () => getRoute(RoutesScreen())),
    GetPage(name: parentAdmin, page: () => getRoute(ParentsScreen())),
    GetPage(name: notification, page: () => getRoute(NotificationsScreen())),
    GetPage(name: profile, page: () => getRoute(ProfileScreen())),
    GetPage(
        name: qrGenerator,
        page: () {
          List<int> _decode =
              base64Decode(Get.parameters['model']!.replaceAll(' ', '+'));
          ChildModel _data =
              ChildModel.fromJson(jsonDecode(utf8.decode(_decode)));
          return QRCodeGenerator(model: _data);
        }),
    GetPage(name: attendanceScanner, page: () => getRoute(AttendanceScanner())),
    GetPage(name: profile, page: () => getRoute(ProfileScreen())),
    GetPage(
        name: updateProfile,
        page: () {
          List<int> _decode =
              base64Decode(Get.parameters['model']!.replaceAll(' ', '+'));
          UserModel _data =
              UserModel.fromJson(jsonDecode(utf8.decode(_decode)));
          return UpdateProfileScreen(userModel: _data);
        }),
    GetPage(
        name: updateParentProfile,
        page: () {
          List<int> _decode =
              base64Decode(Get.parameters['model']!.replaceAll(' ', '+'));
          UserModel _data =
              UserModel.fromJson(jsonDecode(utf8.decode(_decode)));
          return UpdateParentScreen(userModel: _data);
        }),

    GetPage(
        name: updateChild,
        page: () {
          List<int> _decode =
              base64Decode(Get.parameters['model']!.replaceAll(' ', '+'));
          ChildModel _data =
              ChildModel.fromJson(jsonDecode(utf8.decode(_decode)));
          return UpdateChildScreen(model: _data);
        }),
    GetPage(
        name: splash,
        page: () {
          return SplashScreen();
        }),

    // GetPage(name: onBoarding, page: () => OnBoardingScreen()),
    GetPage(name: signIn, page: () => SignInScreen()),
    GetPage(name: signUp, page: () => SignUpScreen()),
  ];

  static getRoute(Widget navigateTo) {
    return navigateTo;
  }
}

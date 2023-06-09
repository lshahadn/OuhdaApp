import 'dart:async';
import 'dart:convert';

import 'package:bustracking/controllers/auth_controller.dart';
import 'package:bustracking/controllers/splash_controller.dart';
import 'package:bustracking/data/models/body/notification_body.dart';
import 'package:bustracking/helper/route_helper.dart';
import 'package:bustracking/layout/widgets/no_internet_screen.dart';
import 'package:bustracking/util/app_constants.dart';
import 'package:bustracking/util/images.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen();

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  StreamSubscription<ConnectivityResult>? _onConnectivityChanged;
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..forward();
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);
    // CompaingCubit.get(context).toggleCampaign(true);
    bool _firstTime = true;
    _onConnectivityChanged = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (!_firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi &&
            result != ConnectivityResult.mobile;
        isNotConnected
            ? SizedBox()
            : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? 'no_connection'.tr : 'connected'.tr,
            textAlign: TextAlign.center,
          ),
        ));
        if (!isNotConnected) {
          _route();
        }
      }
      _firstTime = false;
    });

    Get.find<SplashController>().initSharedData();

    _route();
  }

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged!.cancel();
  }

  void _route() {
    // Get.offNamed(RouteHelper.getSignInRoute(RouteHelper.splash));
    Timer(Duration(seconds: 4), () {
      var userAccount = Get.find<SplashController>().getUserAccountType();
      if (userAccount == 'driver') {
        Get.offAndToNamed(RouteHelper.getDriverHomeRoute());
      } else if (userAccount == 'parent') {
        Get.offAndToNamed(RouteHelper.getParentHomeRoute());
      } else if (userAccount == 'admin') {
        Get.offAndToNamed(RouteHelper.getAdminHomeRoute());
      } else {
        Get.offAndToNamed(RouteHelper.getSignInRoute());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _globalKey,
      body: GetBuilder<SplashController>(builder: (splashController) {
        return Center(
          child: splashController.hasConnection
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScaleTransition(
                        scale: animation,
                        child: Center(
                            child: Container(
                          width: 250,
                          child: Image.asset(
                            Images.bus_logo_image,
                            // width: double.maxFinite,
                          ),
                        ))),
                  ],
                )
              : NoInternetScreen(child: SplashScreen()),
        );
      }),
    );
  }
}

import 'package:bustracking/data/models/body/config_model.dart';
import 'package:bustracking/data/repository/splash_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashController extends GetxController implements GetxService {
  final SplashRepo splashRepo;
  SplashController({required this.splashRepo});

  ConfigModel? _configModel;
  bool _firstTimeConnectionCheck = true;
  bool _hasConnection = true;
  int _nearestRestaurantIndex = -1;

  // ConfigModel get configModel => _configModel;
  DateTime get currentTime => DateTime.now();
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;
  bool get hasConnection => _hasConnection;
  int get nearestRestaurantIndex => _nearestRestaurantIndex;

  Future<bool> initSharedData() {
    return splashRepo.initSharedData();
  }

  String getUserAccountType() {
    return splashRepo.getUserAccountType();
  }
}

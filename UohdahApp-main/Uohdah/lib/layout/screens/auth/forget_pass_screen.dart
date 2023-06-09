import 'dart:async';
import 'dart:io';

import 'package:bustracking/controllers/auth_controller.dart';
import 'package:bustracking/helper/route_helper.dart';
import 'package:bustracking/layout/widgets/custom_button.dart';
import 'package:bustracking/layout/widgets/custom_snackbar.dart';
import 'package:bustracking/layout/widgets/custom_text_field.dart';
import 'package:bustracking/util/app_constants.dart';
import 'package:bustracking/util/dimensions.dart';
import 'package:bustracking/util/images.dart';
import 'package:bustracking/util/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ForgetPasswordScreen extends StatefulWidget {
  ForgetPasswordScreen();

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final FocusNode _emailFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        child: Container(
          decoration: context.width > 700
              ? BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 5,
                        spreadRadius: 1)
                  ],
                )
              : null,
          child: GetBuilder<AuthController>(builder: (authController) {
            return Column(children: [
              Image.asset(Images.bus_logo_image, width: 200, height: 200),
              const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
              Center(
                child: Text(
                  'Forget Password',
                  style: TextStyle(
                      fontSize: 30.0,
                      letterSpacing: 3.0,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.mainColor,
                      fontFamily: 'Cairo'),
                ),
              ),
              const SizedBox(height: 50),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade200,
                        spreadRadius: 1,
                        blurRadius: 5)
                  ],
                ),
                child: Column(children: [
                  CustomTextField(
                    hintText: 'email',
                    controller: _emailController,
                    focusNode: _emailFocus,
                    inputType: TextInputType.emailAddress,
                  ),
                ]),
              ),
              const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              !authController.isLoading
                  ? CustomButton(
                      buttonText: 'Send Link',
                      onPressed: () => _sendLink(authController))
                  : const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Back",
                        style: TextStyle(
                            color: AppConstants.mainColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0),
                      )),
                ],
              ),
            ]);
          }),
        ),
      )),
    );
  }

  void _sendLink(AuthController authController) async {
    String _email = _emailController.text.trim();

    if (_email.isEmpty) {
      showCustomSnackBar('Enter email');
    } else {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
        print('Password reset email sent successfully');
        showCustomSnackBar("Password reset email sent successfully!",
            isError: false);
        _emailController.text = '';
      } catch (error) {
        showCustomSnackBar("$error");
      }
    }
  }
}

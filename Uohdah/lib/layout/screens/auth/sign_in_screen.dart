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

class SignInScreen extends StatefulWidget {
  SignInScreen();

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _emailController.text = Get.find<AuthController>().getUserEmail();
    _passwordController.text = Get.find<AuthController>().getUserPassword();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        child: Container(
          // width: context.width > 700 ? 700 : context.width,
          // padding: context.width > 700
          //     ? const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT)
          //     : null,
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
                  'Login',
                  style: TextStyle(
                      fontSize: 30.0,
                      letterSpacing: 3.0,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.mainColor,
                      fontFamily: 'Cairo'),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              const Center(
                child: Text(
                  'Login and Enjoy!',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
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
                    nextFocus: _passwordFocus,
                    inputType: TextInputType.emailAddress,
                  ),
                  const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_LARGE),
                      child: Divider(height: 1)),
                  CustomTextField(
                    hintText: 'Password',
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    inputAction: TextInputAction.done,
                    inputType: TextInputType.visiblePassword,
                    isPassword: true,
                    onSubmit: (text) => _login(authController),
                  ),
                ]),
              ),
              const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              !authController.isLoading
                  ? CustomButton(
                      buttonText: 'Login',
                      onPressed: () => _login(authController))
                  : const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 15),
               Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Forget Password?',
                        style: TextStyle(
                            color: Color.fromARGB(255, 136, 136, 136),
                            fontSize: 17.0),
                      ),
                      TextButton(
                          onPressed: () {
                            Get.toNamed(
                                RouteHelper.getForgetPassRoute());
                          },
                          child: Text(
                            "Reset",
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

  void _login(AuthController authController) async {
    String _email = _emailController.text.trim();
    String _password = _passwordController.text.trim();

    if (_email.isEmpty) {
      showCustomSnackBar('Enter email ');
    } else if (_password.isEmpty) {
      showCustomSnackBar('Enter password');
    } else if (_password.length < 6) {
      showCustomSnackBar('Password should be larger than 6 characters');
    } else {

      authController.signIn(_email, _password).then((response) async {
        if (response['status']) {
          print(response['status']);
          print(response['accountType']);
          if (response['accountType'] == 'driver') {
            Get.offAllNamed(RouteHelper.getDriverHomeRoute());
          } else if (response['accountType'] == 'parent') {
            Get.offAllNamed(RouteHelper.getParentHomeRoute());
          } else if (response['accountType'] == 'admin') {
            Get.offAllNamed(RouteHelper.getAdminHomeRoute());
          } else {
            Get.offAllNamed(RouteHelper.getSignInRoute());
          } 
          showCustomSnackBar("Login successfully!", isError: false);
        } else {
          showCustomSnackBar("This account not exist to login");
        }
      });
    }
  }
}

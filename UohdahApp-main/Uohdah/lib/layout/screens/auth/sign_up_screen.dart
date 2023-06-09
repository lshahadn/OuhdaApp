import 'dart:convert';

import 'package:bustracking/controllers/auth_controller.dart';
import 'package:bustracking/controllers/splash_controller.dart';
import 'package:bustracking/data/models/body/user_model.dart';
import 'package:bustracking/helper/route_helper.dart';
import 'package:bustracking/layout/widgets/custom_button.dart';
import 'package:bustracking/layout/widgets/custom_snackbar.dart';
import 'package:bustracking/layout/widgets/custom_text_field.dart';
import 'package:bustracking/util/app_constants.dart';
import 'package:bustracking/util/dimensions.dart';
import 'package:bustracking/util/images.dart';
import 'package:bustracking/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FocusNode _fullNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: Container(
              width: context.width > 700 ? 700 : context.width,
              padding: context.width > 700
                  ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT)
                  : null,
              decoration: context.width > 700
                  ? BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius:
                          BorderRadius.circular(Dimensions.RADIUS_SMALL),
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
                  Image.asset(
                    Images.bus_logo_image,
                    width: 200,
                    height: 80,
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Center(
                    child: Text(
                      'Sign Up',
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
                      'Sign Up and Enjoy!',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      color: Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade200,
                            spreadRadius: 1,
                            blurRadius: 8)
                      ],
                    ),
                    child: Column(children: [
                      CustomTextField(
                        hintText: 'Full Name',
                        controller: _fullNameController,
                        focusNode: _fullNameFocus,
                        nextFocus: _fullNameFocus,
                        inputType: TextInputType.name,
                        capitalization: TextCapitalization.words,
                        // prefixIcon: Images.user,
                        divider: true,
                      ),
                      CustomTextField(
                        hintText: 'email',
                        controller: _emailController,
                        focusNode: _emailFocus,
                        nextFocus: _phoneFocus,
                        inputType: TextInputType.emailAddress,
                        divider: true,
                      ),
                      CustomTextField(
                        hintText: 'phone',
                        controller: _phoneController,
                        focusNode: _phoneFocus,
                        nextFocus: _passwordFocus,
                        inputType: TextInputType.phone,
                        divider: false,
                      ),
                      const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_LARGE),
                          child: Divider(height: 1)),
                      CustomTextField(
                        hintText: 'password',
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        nextFocus: _confirmPasswordFocus,
                        inputType: TextInputType.visiblePassword,
                        isPassword: true,
                        divider: true,
                      ),
                      CustomTextField(
                        hintText: 'confirm password',
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocus,
                        inputType: TextInputType.visiblePassword,
                        isPassword: true,
                        divider: false,
                        onSubmit: (text) => _register(authController),
                      ),
                    ]),
                  ),
                  Row(children: [
                    Expanded(
                        child: authController.accountType != []
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.PADDING_SIZE_SMALL),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.RADIUS_SMALL),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade200,
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 5))
                                  ],
                                ),
                                child: DropdownButton(
                                  value: authController.selectedAccountType ??
                                      authController.accountType[0],
                                  items:
                                      authController.accountType.map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    authController.selectAccountType(value);
                                  },
                                  isExpanded: true,
                                  underline: SizedBox(),
                                ),
                              )
                            : const Center(child: CircularProgressIndicator())),
                  ]),
                  if (authController.selectedAccountType == 'driver' &&
                      authController.buss.isNotEmpty)
                    Row(children: [
                      Expanded(
                          child: authController.buss != []
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal:
                                          Dimensions.PADDING_SIZE_SMALL),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.RADIUS_SMALL),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.shade200,
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 5))
                                    ],
                                  ),
                                  child: DropdownButton(
                                    value: authController.selectedBus ??
                                        authController.buss[0],
                                    items: authController.buss.map((value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(value.bus_number ?? ''),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      authController.selectBus(value);
                                    },
                                    isExpanded: true,
                                    underline: SizedBox(),
                                  ),
                                )
                              : const Center(
                                  child: CircularProgressIndicator())),
                    ]),
                  const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                  !authController.isLoading
                      ? Row(children: [
                          Expanded(
                              child: CustomButton(
                            buttonText: 'Sign Up',
                            onPressed: () => _register(authController),
                          )),
                        ])
                      : Center(child: CircularProgressIndicator()),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Have Already an account?',
                        style: TextStyle(
                            color: Color.fromARGB(255, 136, 136, 136),
                            fontSize: 17.0),
                      ),
                      TextButton(
                          onPressed: () {
                            Get.toNamed(
                                RouteHelper.getSignInRoute());
                          },
                          child: Text(
                            "Sign In",
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
          ),
        ),
      )),
    );
  }

  void _register(AuthController authController) async {
    String _fullName = _fullNameController.text.trim();
    String _email = _emailController.text.trim();
    String _number = _phoneController.text.trim();
    String _password = _passwordController.text.trim();
    String _confirmPassword = _confirmPasswordController.text.trim();

    if (_fullName.isEmpty) {
      showCustomSnackBar('Enter your first name');
    } else if (_email.isEmpty) {
      showCustomSnackBar('Enter email address');
    } else if (!GetUtils.isEmail(_email)) {
      showCustomSnackBar('Enter a valid email address');
    } else if (_number.isEmpty) {
      showCustomSnackBar('Enterphonenumber');
    } else if (_password.isEmpty) {
      showCustomSnackBar('Enter password');
    } else if (_password.length < 6) {
      showCustomSnackBar('Password should be larger than 6 characters');
    } else if (_password != _confirmPassword) {
      showCustomSnackBar('Confirm password does not matched');
    } else if (authController.selectedAccountType ==
        authController.accountType[0]) {
      showCustomSnackBar('Select account type');
    } else if (authController.selectedBus == authController.buss[0]) {
      showCustomSnackBar('Select bus');
    } else {
      UserModel signUpBody = UserModel(
        fullName: _fullName,
        email: _email,
        phone: _number,
        password: _password,
      );
      authController.signUp(signUpBody).then((response) async {
        if (response['status']) {
          if (authController.selectedAccountType == 'driver') {
            Get.offAndToNamed(RouteHelper.getDriverHomeRoute());
          } else if (authController.selectedAccountType == 'parent') {
            Get.offAndToNamed(RouteHelper.getParentHomeRoute());
          } else {
            Get.offAndToNamed(RouteHelper.getSignUpRoute());
          } 

          showCustomSnackBar("Sign up successfully!", isError: false);
        } else {
          showCustomSnackBar(response['error']);
        }
      });
    }
  }
}

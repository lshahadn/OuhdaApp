import 'package:bustracking/controllers/auth_controller.dart';
import 'package:bustracking/helper/route_helper.dart';
import 'package:bustracking/layout/screens/profile/widget/profile_bg_widget.dart';
import 'package:bustracking/layout/screens/profile/widget/profile_button.dart';
import 'package:bustracking/layout/widgets/custom_image.dart';
import 'package:bustracking/util/dimensions.dart';
import 'package:bustracking/util/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: GetBuilder<AuthController>(builder: (userController) {
        return ProfileBgWidget(
          name: userController.getUsername(),
          backButton: true,
          circularImage: ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_LARGE),
            child: Container(
              width: MediaQuery.of(context).size.width / 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(width: 2, color: Theme.of(context).cardColor),
                shape: BoxShape.rectangle,
              ),
              alignment: Alignment.center,
              child: CustomImage(
                image: Images.placeholder,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
          ),
          mainWidget: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Center(
                  child: Container(
                color: Theme.of(context).backgroundColor,
                width: Dimensions.WEB_MAX_WIDTH,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: ProfileButton(
                            icon: Icons.edit,
                            title: 'Edit Profile',
                            onTap: () {
                              userController.getUserData().then((value) async {
                                if (value != null) {
                                  Get.toNamed(
                                      RouteHelper.getUpdateProfileRoute(value));
                                }
                              });
                            }),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GetBuilder<AuthController>(builder: (auth) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: ProfileButton(
                              icon: Icons.logout,
                              title: 'Logout',
                              onTap: () {
                                auth.signOut();
                              }),
                        );
                      }),
                    ]),
              ))),
        );
      }),
    );
  }
}

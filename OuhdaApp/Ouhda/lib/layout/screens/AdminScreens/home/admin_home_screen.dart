import 'package:bustracking/controllers/auth_controller.dart';
import 'package:bustracking/controllers/parent/parent_controller.dart';
import 'package:bustracking/data/app_data.dart';
import 'package:bustracking/data/models/body/child_info.dart';
import 'package:bustracking/data/models/body/user_model.dart';
import 'package:bustracking/helper/route_helper.dart';
import 'package:bustracking/layout/widgets/custom_btn.dart';
import 'package:bustracking/layout/widgets/custom_button.dart';
import 'package:bustracking/layout/widgets/custom_empty_box.dart';
import 'package:bustracking/util/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:lottie/lottie.dart';

class HomeAdminScreen extends StatefulWidget {
  const HomeAdminScreen({Key? key}) : super(key: key);

  @override
  State<HomeAdminScreen> createState() => _HomeAdminScreenState();
}

class _HomeAdminScreenState extends State<HomeAdminScreen> {
  UserModel? user;
  @override
  void initState() {
    super.initState();
    // user = AppCubit.get(context).userData;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParentController>(builder: (parentController) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              _topBar(parentController),
              const SizedBox(
                height: 20,
              ),
              StaggeredGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: [
                  _buildCard(Icons.bus_alert, "Bus", AppConstants.mainColor, () {
                    Get.toNamed(RouteHelper.getBusRoute());
                  }),
                  _buildCard(Icons.home_filled, "Schools", AppConstants.mainColor, () {
                    Get.toNamed(RouteHelper.getSchoolsRoute());
                  }),
                  _buildCard(Icons.route, "Routes", AppConstants.mainColor, () {
                    Get.toNamed(RouteHelper.getRoutesRoute());
                  }),
                   _buildCard(Icons.supervised_user_circle_sharp, "Parents", AppConstants.mainColor, () {
                    Get.toNamed(RouteHelper.getAdminParentRoute());
                  }),
                   _buildCard(Icons.drive_eta_rounded, "Drivers", AppConstants.mainColor, () {
                    Get.toNamed(RouteHelper.getDriverAdminRoute());
                  }),
                  _buildCard(Icons.history, "History", AppConstants.mainColor, () {
                    Get.toNamed(RouteHelper.getBusHistoryRoute());
                  }),

                ],
              ),
           
            ],
          ),
        ),
      );
    });
  }

  // Top bar
  Widget _topBar(ParentController parentController) {
    return Container(
      color: AppConstants.mainColor,
      padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
      child: Row(
        children: [
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(3.5),
              height: 50,
              width: 50,
              child: const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://gravatar.com/avatar/cab04dccc1b4ddeedd2d51d133e31a6f?s=400&d=robohash&r=x')),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hi,',
                    style: TextStyle(
                      color: Colors.black87,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '@${parentController.getUsername()}',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: 15,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
          
          GetBuilder<AuthController>(builder: (auth) {
            return IconButton(
                onPressed: () {
                  auth.signOut();
                },
                icon: Icon(Icons.logout));
          }),
        ],
      ),
    );
  }

  Widget _buildCard(IconData icon, String title, Color color, onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0.4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10.0),
            Icon(
              icon,
              size: 50.0,
              color: color,
            ),
            SizedBox(height: 10.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

}

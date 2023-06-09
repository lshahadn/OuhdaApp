import 'package:bustracking/controllers/driver/driver_controller.dart';
import 'package:bustracking/data/models/body/notification_model.dart';
import 'package:bustracking/layout/widgets/custom_empty_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RefreshController _refreshController =
        RefreshController(initialRefresh: false);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.4,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
        title: Text(
          'Notifications',
          style: GoogleFonts.cairo(
            textStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SmartRefresher(
        onRefresh: () {
          // appCubit.getNotifications().then((value) {
          //   _refreshController.refreshCompleted();
          // });
        },
        controller: _refreshController,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            GetBuilder<DriverController>(builder: (driverController) {
              Query query = FirebaseFirestore.instance
                  .collection("users")
                  .doc(driverController.getCurrentUserID())
                  .collection('notifications');
              return Container(
                padding: const EdgeInsetsDirectional.only(
                  top: 20,
                  bottom: 20,
                  start: 10,
                  end: 10,
                ),
                child: _notificationsList(query, driverController),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget notificationBuilder(
      context, NotificationModel model, DriverController driverController) {
    var mediaQ = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () async {
        // AppCubit.get(context).getNotifications();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsetsDirectional.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadiusDirectional.circular(20),
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 0),
                color: Color.fromARGB(106, 206, 206, 206),
                blurRadius: 7.0,
              ),
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.title!,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    style: GoogleFonts.cairo(
                      textStyle: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                  Text(
                    model.body!,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    style: GoogleFonts.cairo(
                      textStyle: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: Colors.black38,
                          fontSize: 16),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        FontAwesomeIcons.clock,
                        color: Colors.grey,
                        size: 14,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        timeago.format(DateTime.parse(model.created_at!)),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: GoogleFonts.cairo(
                          textStyle: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Colors.grey,
                              fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notificationsList(Query query, DriverController driverController) {
    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: const CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Center(child: EmptyBoxWidget());
        }

        return ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;

            return notificationBuilder(
                context, NotificationModel.fromJson(data), driverController);
          }).toList(),
        );
      },
    );
  }
}

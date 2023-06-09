import 'package:bustracking/controllers/auth_controller.dart';
import 'package:bustracking/controllers/driver/driver_controller.dart';
import 'package:bustracking/controllers/parent/parent_controller.dart';
import 'package:bustracking/data/app_data.dart';
import 'package:bustracking/data/models/body/child_info.dart';
import 'package:bustracking/data/models/body/user_model.dart';
import 'package:bustracking/helper/route_helper.dart';
import 'package:bustracking/layout/widgets/custom_btn.dart';
import 'package:bustracking/layout/widgets/custom_button.dart';
import 'package:bustracking/layout/widgets/custom_empty_box.dart';
import 'package:bustracking/layout/widgets/custom_snackbar.dart';
import 'package:bustracking/util/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeDriverScreen extends StatefulWidget {
  const HomeDriverScreen({Key? key}) : super(key: key);

  @override
  State<HomeDriverScreen> createState() => _HomeDriverScreenState();
}

class _HomeDriverScreenState extends State<HomeDriverScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<Tab> _tabs = [
    Tab(
      text: 'All',
    ),
    Tab(
      text: 'Picked',
    ),
    Tab(
      text: 'Dropped',
    ),
    Tab(
      text: 'Absent',
    ),
  ];
  @override
  void initState() {
    super.initState();
    final driverController = Get.find<DriverController>();
    driverController.getDataOf('all').then((value) {
      // Update the 'All' tab with the new data
      _tabs[0] = Tab(
        text: 'All (${driverController.allLength})',
      );
      // Update the tab controller to reflect the new number of tabs
      _tabController = TabController(length: _tabs.length, vsync: this);
      // Call setState to trigger a rebuild of the widget tree
      setState(() {});
    });
    driverController.getDataOf('picked').then((value) {
      // Update the 'Picked' tab with the new data
      _tabs[1] = Tab(
        text: 'Picked (${driverController.pickedLength})',
      );
      _tabController = TabController(length: _tabs.length, vsync: this);
      setState(() {});
    });
    driverController.getDataOf('drop').then((value) {
      // Update the 'Absent' tab with the new data
      _tabs[2] = Tab(
        text: 'Dropped (${driverController.droppedLength})',
      );
      // Update the tab controller to reflect the new number of tabs
      _tabController = TabController(length: _tabs.length, vsync: this);
      // Call setState to trigger a rebuild of the widget tree
      setState(() {});
    });
    driverController.getDataOf('absent').then((value) {
      // Update the 'Absent' tab with the new data
      _tabs[3] = Tab(
        text: 'Absent (${driverController.absentLength})',
      );
      // Update the tab controller to reflect the new number of tabs
      _tabController = TabController(length: _tabs.length, vsync: this);
      // Call setState to trigger a rebuild of the widget tree
      setState(() {});
    });

    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  bool _isTimerRunning = false;
  Stopwatch _stopwatch = Stopwatch();

  @override
  void dispose() {
    _tabController.dispose();
    _stopwatch.stop();
    super.dispose();
  }

  void _startStopwatch() {
    setState(() {
      _isTimerRunning = true;
    });
    _stopwatch.start();
  }

  void _stopStopwatch() {
    setState(() {
      _isTimerRunning = false;
    });
    _stopwatch.stop();
  }

  @override
  Widget build(BuildContext context) {
    Duration duration = _stopwatch.elapsed;
    String timerText =
        '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}.${(duration.inMilliseconds % 1000).toString().padLeft(3, '0')}';
    return GetBuilder<DriverController>(builder: (driverController) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          // leading: Container(),
          title: Text('Driver Home'),
          actions: [
            IconButton(
              onPressed: () {
                Get.toNamed(RouteHelper.getAttendanceScannerRoute());
              },
              icon: Icon(Icons.scanner),
            ),
            IconButton(
                onPressed: () {
                  Get.toNamed(RouteHelper.getNotificationRoute());
                },
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: Icon(Icons.notifications_none)),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(driverController.getCurrentUserID())
                          .collection('notifications')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: const CircularProgressIndicator());
                        }

                        if (snapshot.data!.docs.isEmpty) {
                          return Container();
                        }

                        return Positioned(
                          right: 5.0,
                          top: 10,
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                )),
            IconButton(
                onPressed: () {
                  Get.toNamed(RouteHelper.getProfileRoute());
                },
                icon: Icon(Icons.person_outline_sharp)),
            GetBuilder<AuthController>(builder: (auth) {
              return IconButton(
                  onPressed: () async {
                    await auth.signOut();
                  },
                  icon: Icon(Icons.logout));
            }),
          ],
        ),
        body: Column(
          children: [
            Container(
              color: Colors.white, // Set the background color here
              child: TabBar(
                indicatorColor: AppConstants.mainColor,
                unselectedLabelColor: Colors.black,
                labelColor: AppConstants.mainColor,
                controller: _tabController,
                tabs: _tabs,
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _childrenWidget(driverController, 'all'),
                  _childrenWidget(driverController, 'picked'),
                  _childrenWidget(driverController, 'drop'),
                  _childrenWidget(driverController, 'absent'),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(8.0),
          height: 90,
          child: !_isTimerRunning
              ? CustomButton(
                  buttonText: 'Start Trip',
                  onPressed: () {
                    _startStopwatch();
                    driverController.startTrip();
                  },
                )
              : Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        color: Colors.red,
                        buttonText: 'End Trip',
                        onPressed: () {
                          _stopStopwatch();
                          driverController
                              .endTrip(_stopwatch.elapsedMilliseconds ~/ 1000);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomButton(
                        color: Colors.amber,
                        buttonText: 'Trip in progress...',
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
        ),
      );
    });
  }

  // Children information
  // Widget _childrenWidget() {
  //   return ListView.separated(
  //     shrinkWrap: true,
  //     // physics: const NeverScrollableScrollPhysics(),
  //     itemCount: children.length,
  //     itemBuilder: ((context, index) {
  //       print(index);
  //       return Column(
  //         children: [
  //           childInfoBuilder(children[index]),
  //           SizedBox(
  //             height: children.length == index + 1 ? 30 : 1,
  //           ),
  //         ],
  //       );
  //     }),
  //     separatorBuilder: ((context, index) {
  //       print(children.length);
  //       return SizedBox(
  //         height: 1,
  //       );
  //     }),
  //   );
  // }

  // Child information
  Widget childInfoBuilder(ChildModel model, DriverController driverController) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: () async {
            await Get.find<ParentController>()
                .getParent(model.parentId!)
                .then((value) {
              // print(Get.find<ParentController>().parent!.phone!);
              _makePhoneCall("+${Get.find<ParentController>().parent!.phone!}");
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                offset: Offset(0, 3),
                color: Color.fromARGB(155, 214, 212, 212),
                blurRadius: 5.0,
              ),
            ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                      image: NetworkImage(model.image!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name!,
                      style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    if (model.parentPhone != null)
                      Text(
                        model.parentPhone!,
                        style: GoogleFonts.lato(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 150,
                      child: Text(
                        "${model.address}",
                        style:
                            GoogleFonts.lato(fontSize: 15, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.send,
                          size: 16,
                          color: AppConstants.mainColor,
                        ),
                        const SizedBox(width: 7),
                        Text(
                            "${model.status!.replaceAll("_", " ").toUpperCase()} (${model.goOrReturn!.replaceAll("_", " ")})",
                            style: GoogleFonts.lato(
                                fontSize: 12, color: Colors.grey)),
                        // Spacer(),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (model.goOrReturn != 'return_to_parent')
          Positioned(
            bottom: -2,
            right: 10,
            child: CustomBtn(
              title: statusStd(model),
              onPressed: () {
                if (model.status == 'at_home' && model.status != 'absent') {
                  driverController.markAs(
                      "picked", model.id, model.name, model.parentId, 'to_bus');
                  driverController.getDataOf('all').then((value) {
                    // Update the 'All' tab with the new data
                    _tabs[0] = Tab(
                      text: 'All (${driverController.allLength})',
                    );
                    // Update the tab controller to reflect the new number of tabs
                    _tabController =
                        TabController(length: _tabs.length, vsync: this);
                    // Call setState to trigger a rebuild of the widget tree
                    setState(() {});
                  });
                  driverController.getDataOf('picked').then((value) {
                    // Update the 'Picked' tab with the new data
                    _tabs[1] = Tab(
                      text: 'Picked (${driverController.pickedLength})',
                    );
                    _tabController =
                        TabController(length: _tabs.length, vsync: this);
                    print(driverController.pickedLength);
                    setState(() {});
                  });
                  driverController.getDataOf('drop').then((value) {
                    // Update the 'Absent' tab with the new data
                    _tabs[2] = Tab(
                      text: 'Dropped (${driverController.droppedLength})',
                    );
                    // Update the tab controller to reflect the new number of tabs
                    _tabController =
                        TabController(length: _tabs.length, vsync: this);
                    // Call setState to trigger a rebuild of the widget tree
                    setState(() {});
                  });
                  driverController.getDataOf('absent').then((value) {
                    // Update the 'Absent' tab with the new data
                    _tabs[3] = Tab(
                      text: 'Absent (${driverController.absentLength})',
                    );
                    // Update the tab controller to reflect the new number of tabs
                    _tabController =
                        TabController(length: _tabs.length, vsync: this);
                    // Call setState to trigger a rebuild of the widget tree
                    setState(() {});
                  });
                } else if (model.status == 'picked' &&
                    model.status != 'absent' &&
                    model.goOrReturn == 'to_bus') {
                  driverController.markAs("at_school", model.id, model.name,
                      model.parentId, 'at_school');
                  driverController.getDataOf('all').then((value) {
                    // Update the 'All' tab with the new data
                    _tabs[0] = Tab(
                      text: 'All (${driverController.allLength})',
                    );
                    // Update the tab controller to reflect the new number of tabs
                    _tabController =
                        TabController(length: _tabs.length, vsync: this);
                    // Call setState to trigger a rebuild of the widget tree
                    setState(() {});
                  });
                  driverController.getDataOf('picked').then((value) {
                    // Update the 'Picked' tab with the new data
                    _tabs[1] = Tab(
                      text: 'Picked (${driverController.pickedLength})',
                    );
                    _tabController =
                        TabController(length: _tabs.length, vsync: this);
                    print(driverController.pickedLength);
                    setState(() {});
                  });
                  driverController.getDataOf('drop').then((value) {
                    // Update the 'Absent' tab with the new data
                    _tabs[2] = Tab(
                      text: 'Dropped (${driverController.droppedLength})',
                    );
                    // Update the tab controller to reflect the new number of tabs
                    _tabController =
                        TabController(length: _tabs.length, vsync: this);
                    // Call setState to trigger a rebuild of the widget tree
                    setState(() {});
                  });
                  driverController.getDataOf('absent').then((value) {
                    // Update the 'Absent' tab with the new data
                    _tabs[3] = Tab(
                      text: 'Absent (${driverController.absentLength})',
                    );
                    // Update the tab controller to reflect the new number of tabs
                    _tabController =
                        TabController(length: _tabs.length, vsync: this);
                    // Call setState to trigger a rebuild of the widget tree
                    setState(() {});
                  });
                } else if (model.status == 'at_school' &&
                    model.status != 'absent') {
                  driverController.markAs("picked", model.id, model.name,
                      model.parentId, 'return_to_bus');
                  driverController.getDataOf('all').then((value) {
                    // Update the 'All' tab with the new data
                    _tabs[0] = Tab(
                      text: 'All (${driverController.allLength})',
                    );
                    // Update the tab controller to reflect the new number of tabs
                    _tabController =
                        TabController(length: _tabs.length, vsync: this);
                    // Call setState to trigger a rebuild of the widget tree
                    setState(() {});
                  });
                  driverController.getDataOf('picked').then((value) {
                    // Update the 'Picked' tab with the new data
                    _tabs[1] = Tab(
                      text: 'Picked (${driverController.pickedLength})',
                    );
                    _tabController =
                        TabController(length: _tabs.length, vsync: this);
                    print(driverController.pickedLength);
                    setState(() {});
                  });
                  driverController.getDataOf('drop').then((value) {
                    // Update the 'Absent' tab with the new data
                    _tabs[2] = Tab(
                      text: 'Dropped (${driverController.droppedLength})',
                    );
                    // Update the tab controller to reflect the new number of tabs
                    _tabController =
                        TabController(length: _tabs.length, vsync: this);
                    // Call setState to trigger a rebuild of the widget tree
                    setState(() {});
                  });
                  driverController.getDataOf('absent').then((value) {
                    // Update the 'Absent' tab with the new data
                    _tabs[3] = Tab(
                      text: 'Absent (${driverController.absentLength})',
                    );
                    // Update the tab controller to reflect the new number of tabs
                    _tabController =
                        TabController(length: _tabs.length, vsync: this);
                    // Call setState to trigger a rebuild of the widget tree
                    setState(() {});
                  });
                } else if (model.status == 'picked' &&
                    model.goOrReturn == 'return_to_bus' &&
                    model.status != 'absent') {
                  driverController.markAs("drop", model.id, model.name,
                      model.parentId, 'return_to_parent');
                  driverController.getDataOf('all').then((value) {
                    // Update the 'All' tab with the new data
                    _tabs[0] = Tab(
                      text: 'All (${driverController.allLength})',
                    );
                    // Update the tab controller to reflect the new number of tabs
                    _tabController =
                        TabController(length: _tabs.length, vsync: this);
                    // Call setState to trigger a rebuild of the widget tree
                    setState(() {});
                  });
                  driverController.getDataOf('picked').then((value) {
                    // Update the 'Picked' tab with the new data
                    _tabs[1] = Tab(
                      text: 'Picked (${driverController.pickedLength})',
                    );
                    _tabController =
                        TabController(length: _tabs.length, vsync: this);
                    print(driverController.pickedLength);
                    setState(() {});
                  });
                  driverController.getDataOf('drop').then((value) {
                    // Update the 'Absent' tab with the new data
                    _tabs[2] = Tab(
                      text: 'Dropped (${driverController.droppedLength})',
                    );
                    // Update the tab controller to reflect the new number of tabs
                    _tabController =
                        TabController(length: _tabs.length, vsync: this);
                    // Call setState to trigger a rebuild of the widget tree
                    setState(() {});
                  });
                  driverController.getDataOf('absent').then((value) {
                    // Update the 'Absent' tab with the new data
                    _tabs[3] = Tab(
                      text: 'Absent (${driverController.absentLength})',
                    );
                    // Update the tab controller to reflect the new number of tabs
                    _tabController =
                        TabController(length: _tabs.length, vsync: this);
                    // Call setState to trigger a rebuild of the widget tree
                    setState(() {});
                  });
                }
              },
              fullWidth: false,
              height: 37,
              bg: statusColor(model),
              radius: 30.0,
              fontSize: 17,
            ),
          ),
      ],
    );
  }

  void updateTabs(DriverController driverController) {
    driverController.getDataOf('all').then((value) {
      // Update the 'All' tab with the new data
      _tabs[0] = Tab(
        text: 'All (${driverController.allLength})',
      );
      // Update the tab controller to reflect the new number of tabs
      _tabController = TabController(length: _tabs.length, vsync: this);
      // Call setState to trigger a rebuild of the widget tree
      setState(() {});
    });
    driverController.getDataOf('picked').then((value) {
      // Update the 'Picked' tab with the new data
      _tabs[1] = Tab(
        text: 'Picked (${driverController.pickedLength})',
      );
      _tabController = TabController(length: _tabs.length, vsync: this);
      print(driverController.pickedLength);
      setState(() {});
    });
    driverController.getDataOf('drop').then((value) {
      // Update the 'Absent' tab with the new data
      _tabs[2] = Tab(
        text: 'Dropped (${driverController.droppedLength})',
      );
      // Update the tab controller to reflect the new number of tabs
      _tabController = TabController(length: _tabs.length, vsync: this);
      // Call setState to trigger a rebuild of the widget tree
      setState(() {});
    });
    driverController.getDataOf('absent').then((value) {
      // Update the 'Absent' tab with the new data
      _tabs[3] = Tab(
        text: 'Absent (${driverController.absentLength})',
      );
      // Update the tab controller to reflect the new number of tabs
      _tabController = TabController(length: _tabs.length, vsync: this);
      // Call setState to trigger a rebuild of the widget tree
      setState(() {});
    });
  }

  Widget _childrenWidget(DriverController driverController, type) {
    Query query =
        _buildChildrenQuery(driverController.getCurrentUserID(), type);

    return ListView(
      children: [
        _buildChildrenList(query, driverController),
        const SizedBox(height: 50),
      ],
    );
  }

  Query _buildChildrenQuery(String driverId, String type) {
    Query query = FirebaseFirestore.instance.collection("children");
    query = query.where('driverId', isEqualTo: driverId);

    if (type == "picked") {
      query = query.where('status', isEqualTo: 'picked');
    } else if (type == 'drop') {
      query = query.where('status', whereIn: ['drop', 'at_school']);
    } else if (type == 'absent') {
      query = query.where('status', isEqualTo: 'absent');
    }

    return query;
  }

  Widget _buildChildrenList(Query query, DriverController driverController) {
    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Center(child: EmptyBoxWidget());
        }

        return ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            final today = DateTime.now();
            final dateOnly = DateTime(today.year, today.month, today.day);
            var dateAsString =
                '${dateOnly.day}/${dateOnly.month}/${dateOnly.year}';
// update status if next day is came!
            if ((data['status'] != 'at_home' &&
                    data['dateDrop'] != dateAsString &&
                    data['dateDrop'] != '') ||
                (data['dateAbsent'] != dateAsString &&
                    data['dateAbsent'] != '')) {
              final DocumentReference documentRef = FirebaseFirestore.instance
                  .collection('children')
                  .doc(document.id);
              documentRef.update({
                'status': 'at_home',
                'dateDrop': '',
                'dateAbsent': '',
                'datePicked': '',
                'goOrReturn': 'at_home',
              }).then((_) {
                print('Document updated successfully.');
              }).catchError((error) {
                print('Error updating document: $error');
              });
            }

            return childInfoBuilder(
                ChildModel.fromJson(data), driverController);
          }).toList(),
        );
      },
    );
  }

  _makePhoneCall(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String statusStd(ChildModel model) {
    if (model.status == 'at_home' || model.goOrReturn == 'at_school') {
      return 'Mark as Picked';
    } else if (model.status == 'picked') {
      return 'Drop';
    } else if (model.status == 'absent') {
      return 'Absent';
    } else if (model.status == 'drop') {
      return 'Mark as Picked';
    }

    return 'Unknown';
  }

  Color statusColor(ChildModel model) {
    if (model.status == 'at_home' || model.goOrReturn == 'at_school') {
      return AppConstants.mainColor;
    } else if (model.status == 'picked' || model.status == 'drop') {
      return Colors.green;
    } else if (model.status == 'absent') {
      return Colors.red;
    }

    return AppConstants.mainColor;
  }
}

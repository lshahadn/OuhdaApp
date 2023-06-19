import 'package:bustracking/controllers/parent/parent_controller.dart';

import 'package:bustracking/data/models/body/child_info.dart';
import 'package:bustracking/data/models/body/history_model.dart';
import 'package:bustracking/data/models/body/tracking_data.dart';
import 'package:bustracking/helper/route_helper.dart';
import 'package:bustracking/layout/widgets/custom_empty_box.dart';
import 'package:bustracking/util/app_constants.dart';
import 'package:bustracking/util/images.dart';
import 'package:bustracking/util/utiles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:timeline_tile/timeline_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class LiveStatusScreen extends StatefulWidget {
  ChildModel model;
  LiveStatusScreen({required this.model});
  @override
  _LiveStatusScreenState createState() => _LiveStatusScreenState();
}

class _LiveStatusScreenState extends State<LiveStatusScreen>
    with SingleTickerProviderStateMixin {
  final List<LatLng> _locations = [
    LatLng(28.4312607, 45.9823166),
  ];

  late GoogleMapController _mapController;
  late TabController _tabController;
  Position? _currentPosition;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Stack(
              children: [
                GoogleMap(
                  onMapCreated: (controller) => _mapController = controller,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(28.4312607, 45.9823166),
                    zoom: 13.0,
                  ),
                  markers: _locations
                      .map((location) => Marker(
                            markerId: MarkerId(location.toString()),
                            position: location,
                          ))
                      .toSet(),
                ),
                Positioned(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(218, 237, 236, 236),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(Icons.arrow_back_ios),
                    ),
                  ),
                ),
                Positioned(
                    bottom: 0,
                    left: 90,
                    child: Container(
                      color: Colors.black12.withOpacity(0.1),
                      padding: EdgeInsets.all(5),
                      child: Text(
                        widget.model.name!,
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    )),
              ],
            ),
          ),
          Container(
            color: Color.fromARGB(255, 240, 240, 240),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -30,
                  left: 10,
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(widget.model.image!),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 80.0),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: AppConstants.mainColor,
                      unselectedLabelColor: Color.fromARGB(255, 30, 30, 30),
                      indicatorColor: AppConstants.mainColor,
                      indicatorPadding: EdgeInsets.all(1),
                      tabs: [
                        Tab(text: 'Status'),
                        Tab(text: 'History'),
                        Tab(text: 'Bus Info'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildStatusTab(),
                _buildHistoryTab(widget.model),
                _buildBusInfoTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTab() {
    return Container(
      child: Column(
        children: [
          lottie.LottieBuilder.asset(Images.status,
              height: MediaQuery.of(context).size.height * 0.3),
          Text(widget.model.status!.replaceAll("_", " ").toUpperCase(),
              style: GoogleFonts.lato(color: Colors.grey, fontSize: 20)),
          Text(widget.model.goOrReturn!.replaceAll("_", " "),
              style: GoogleFonts.lato(color: Colors.blueAccent, fontSize: 20)),
        ],
      ),
    );
  }

  Widget _buildHistoryTab(ChildModel model) {
    var days = Utiles.daysInMonth(selectedDate);
    return GetBuilder<ParentController>(builder: (parentController) {
      print(parentController.history);
      // selectedDate = days[selectedDate.day];
      return Column(
        children: [
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: days.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    parentController.getAllHistoryOfStudent(widget.model.id);
                    setState(() {
                      selectedDate = days[index];
                    });
                  },
                  child: Container(
                    width: 80,
                    color: selectedDate == days[index]
                        ? Colors.blue
                        : Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          days[index].day.toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          days[index].month.toString(),
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 250,
            child: ListView.builder(
              itemCount: parentController.history.length,
              itemBuilder: (BuildContext context, int index) {
                var history = parentController.history[index];
                print(parentController.history[index].date);
                DateFormat format = DateFormat('dd/MM/yyyy');
                DateTime date =
                    format.parse(parentController.history[index].date!);
                int day = date.day;
                if (day != selectedDate.day) {
                  return const SizedBox();
                }
                return Column(
                  children: [
                    if (history.to_bus_at != null)
                      TimelineTile(
                        alignment: TimelineAlign.manual,
                        lineXY: 0.25,
                        isFirst: true,
                        beforeLineStyle: LineStyle(
                          color: Colors.grey.shade400,
                          thickness: 2,
                        ),
                        afterLineStyle: LineStyle(
                          color: Colors.grey.shade400,
                          thickness: 2,
                        ),
                        indicatorStyle: IndicatorStyle(
                          color: Colors.green.shade400,
                          iconStyle: IconStyle(
                            color: Colors.white,
                            iconData: Icons.location_on,
                          ),
                        ),
                        startChild: Container(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'To Bus At',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        endChild: Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                history.to_bus_at.toString(),
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Your child picked to bus!",
                                style: GoogleFonts.lato(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (history.at_school != null)
                      TimelineTile(
                        alignment: TimelineAlign.manual,
                        lineXY: 0.25,
                        isLast: true,
                        beforeLineStyle: LineStyle(
                          color: Colors.grey.shade400,
                          thickness: 2,
                        ),
                        afterLineStyle: LineStyle(
                          color: Colors.grey.shade400,
                          thickness: 2,
                        ),
                        indicatorStyle: IndicatorStyle(
                          color: Colors.green.shade400,
                          iconStyle: IconStyle(
                            color: Colors.white,
                            iconData: Icons.location_on,
                          ),
                        ),
                        startChild: Container(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'Dropped At',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        endChild: Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                history.at_school.toString(),
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Your child dropped to school!",
                                style: GoogleFonts.lato(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (history.return_to_bus_at != null)
                      TimelineTile(
                        alignment: TimelineAlign.manual,
                        lineXY: 0.25,
                        isLast: true,
                        beforeLineStyle: LineStyle(
                          color: Colors.grey.shade400,
                          thickness: 2,
                        ),
                        afterLineStyle: LineStyle(
                          color: Colors.grey.shade400,
                          thickness: 2,
                        ),
                        indicatorStyle: IndicatorStyle(
                          color: Colors.green.shade400,
                          iconStyle: IconStyle(
                            color: Colors.white,
                            iconData: Icons.location_on,
                          ),
                        ),
                        startChild: Container(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'Return to bus at',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        endChild: Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                history.return_to_bus_at.toString(),
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Your child return to bus!",
                                style: GoogleFonts.lato(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (history.return_to_parent_at != null)
                      TimelineTile(
                        alignment: TimelineAlign.manual,
                        lineXY: 0.25,
                        isLast: true,
                        beforeLineStyle: LineStyle(
                          color: Colors.grey.shade400,
                          thickness: 2,
                        ),
                        afterLineStyle: LineStyle(
                          color: Colors.grey.shade400,
                          thickness: 2,
                        ),
                        indicatorStyle: IndicatorStyle(
                          color: Colors.green.shade400,
                          iconStyle: IconStyle(
                            color: Colors.white,
                            iconData: Icons.location_on,
                          ),
                        ),
                        startChild: Container(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'Dropped At',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        endChild: Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                history.return_to_parent_at.toString(),
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Your child dropped to parent!",
                                style: GoogleFonts.lato(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildBusInfoTab() {
    return GetBuilder<ParentController>(builder: (parentController) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30.0),
            Icon(
              FontAwesomeIcons.bus,
              size: 48.0,
              color: AppConstants.mainColor,
            ),
            const SizedBox(height: 50.0),
            if (parentController.driver != null)
              _infoBuilder(
                  prefixIcon: FontAwesomeIcons.motorcycle,
                  title: 'Driver Name',
                  value: parentController.driver!.fullName,
                  suffixIcon: FontAwesomeIcons.phone,
                  onTapSuffix: () async {
                    String url = 'tel:${parentController.driver!.phone}';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  }),
            const SizedBox(height: 20.0),
            if (widget.model.bus != null)
              _infoBuilder(
                  prefixIcon: FontAwesomeIcons.idCard,
                  title: 'Bus Number',
                  value: widget.model.bus!.bus_number),
            const SizedBox(height: 20.0),
          ],
        ),
      );
    });
  }
}

Widget _infoBuilder({prefixIcon, title, value, suffixIcon, onTapSuffix}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(
        prefixIcon,
        size: 21.0,
        color: AppConstants.mainColor,
      ),
      const SizedBox(
        width: 60,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.lato(color: Colors.grey, fontSize: 14)),
          if (suffixIcon == null)
            const SizedBox(
              height: 8,
            ),
          Row(
            children: [
              Text(value,
                  style: GoogleFonts.lato(
                      fontSize: 17, fontWeight: FontWeight.bold)),
              if (suffixIcon != null)
                const SizedBox(
                  width: 30,
                ),
              if (suffixIcon != null)
                InkWell(
                  onTap: onTapSuffix,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 215, 214, 214)
                              .withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      suffixIcon,
                      size: 17.0,
                      color: AppConstants.mainColor,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    ],
  );
}

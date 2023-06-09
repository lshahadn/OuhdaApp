import 'dart:collection';

import 'package:bustracking/controllers/auth_controller.dart';
import 'package:bustracking/controllers/splash_controller.dart';
import 'package:bustracking/layout/widgets/custom_button.dart';
import 'package:bustracking/layout/widgets/custom_text_field.dart';
import 'package:bustracking/util/dimensions.dart';
import 'package:bustracking/util/images.dart';
import 'package:bustracking/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectLocationView extends StatefulWidget {
  final bool fromView;
  final GoogleMapController? mapController;
  const SelectLocationView({required this.fromView, this.mapController});

  @override
  State<SelectLocationView> createState() => _SelectLocationViewState();
}

class _SelectLocationViewState extends State<SelectLocationView> {
  CameraPosition? _cameraPosition;
  Set<Polygon> _polygons = HashSet<Polygon>();
  GoogleMapController? _mapController;
  GoogleMapController? _screenMapController;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      List<int> _zoneIndexList = [];
     
     
      

      return Card(
        elevation: 0,
        child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: Padding(
          padding: EdgeInsets.all(widget.fromView ? 0 : Dimensions.PADDING_SIZE_SMALL),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Text(
              'zone'.tr,
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

            InkWell(
              onTap: () async {
                // var _p = await Get.dialog(LocationSearchDialog(mapController: widget.fromView ? _mapController! : _screenMapController!));
                // Position _position = _p;
                // if(_position != null) {
                //   _cameraPosition = CameraPosition(target: LatLng(_position.latitude, _position.longitude), zoom: 16);
                //   if(!widget.fromView) {
                //     widget.mapController!.moveCamera(CameraUpdate.newCameraPosition(_cameraPosition!));
                //     // authController.setLocation(_cameraPosition.target);
                //   }
                // }
              },
              child: Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
                child: Row(children: [
                  Icon(Icons.location_on, size: 25, color: Theme.of(context).primaryColor),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  // Expanded(
                  //   child: GetBuilder<LocationController>(builder: (locationController) {
                  //     return Text(
                  //       locationController.pickAddress.isEmpty ? 'search'.tr : locationController.pickAddress,
                  //       style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge), maxLines: 1, overflow: TextOverflow.ellipsis,
                  //     );
                  //   }),
                  // ),
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                  Icon(Icons.search, size: 25, color: Theme.of(context).textTheme.bodyLarge!.color),
                ]),
              ),
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


            
            !widget.fromView ? CustomButton(
              buttonText: 'set_location'.tr,
              onPressed: () {
                widget.mapController!.moveCamera(CameraUpdate.newCameraPosition(_cameraPosition!));
                Get.back();
              },
            ) : SizedBox()

          ]),
        )),
      );
    });
  }
}

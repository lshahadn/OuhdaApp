import 'package:bustracking/controllers/admin/admin_controller.dart';
import 'package:bustracking/data/models/body/bus_model.dart';
import 'package:bustracking/data/models/body/route_model.dart';
import 'package:bustracking/data/models/body/school_model.dart';
import 'package:bustracking/layout/widgets/custom_button.dart';
import 'package:bustracking/layout/widgets/custom_snackbar.dart';
import 'package:bustracking/layout/widgets/custom_text_field.dart';
import 'package:bustracking/util/app_constants.dart';
import 'package:bustracking/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditRouteModal extends StatefulWidget {
  RouteModel model;
  EditRouteModal({Key? key, required this.model}) : super(key: key);

  @override
  State<EditRouteModal> createState() => _EditRouteModalState();
}

class _EditRouteModalState extends State<EditRouteModal> {
  final FocusNode _routeFocus = FocusNode();
  final FocusNode _latFocus = FocusNode();
  final FocusNode _lngFocus = FocusNode();
  TextEditingController _routeController = TextEditingController();
  TextEditingController _latController = TextEditingController();
  TextEditingController _lngController = TextEditingController();

  @override
  void initState() {
    _routeController.text = widget.model.route!;
    _latController.text = widget.model.lat!;
    _lngController.text = widget.model.lng!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminController>(builder: (adminController) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsetsDirectional.only(top: 17.0),
                  height: 4,
                  width: 80,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Text(
                  'Edit Route',
                  style: TextStyle(
                      fontSize: 30.0,
                      letterSpacing: 3.0,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.mainColor,
                      fontFamily: 'Cairo'),
                ),
              ),
              const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
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
                    hintText: 'Route',
                    controller: _routeController,
                    focusNode: _routeFocus,
                    nextFocus: _routeFocus,
                    inputType: TextInputType.text,
                    divider: true,
                  ),

                  CustomTextField(
                    hintText: 'Latitude',
                    controller: _latController,
                    focusNode: _latFocus,
                    nextFocus: _latFocus,
                    inputType: TextInputType.text,
                    divider: true,
                  ),

                  CustomTextField(
                    hintText: 'Longitude',
                    controller: _lngController,
                    focusNode: _lngFocus,
                    nextFocus: _lngFocus,
                    inputType: TextInputType.text,
                    divider: true,
                  ),
                ]),
              ),
              const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              !adminController.isLoading
                  ? Row(children: [
                      Expanded(
                          child: CustomButton(
                        buttonText: 'Update',
                        onPressed: () => _update(adminController),
                      )),
                    ])
                  : Center(child: CircularProgressIndicator()),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    });
  }

  void _update(AdminController adminController) async {
    String _route = _routeController.text.trim();
    String _lng = _lngController.text.trim();
    String _lat = _latController.text.trim();

   if (_route.isEmpty) {
      showCustomSnackBar('Enter Route');
    } else if (_lat.isEmpty) {
      showCustomSnackBar('Enter Latitude');
    } else if (_lng.isEmpty) {
      showCustomSnackBar('Enter Langitude');
    } else {
      adminController
          .updateNewRoute(_route, _lat, _lng, widget.model.id)
          .then((response) async {
        if (response) {
          Navigator.pop(context);
          showCustomSnackBar("Route Updated Successfully!", isError: false);
        } else {
          print(response);
          showCustomSnackBar("Failed to Update Route!", isError: true);
        }
      });
    }
  }
}

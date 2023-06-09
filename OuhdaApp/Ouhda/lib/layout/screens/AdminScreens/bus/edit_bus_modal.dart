import 'package:bustracking/controllers/admin/admin_controller.dart';
import 'package:bustracking/data/models/body/bus_model.dart';
import 'package:bustracking/data/models/body/school_model.dart';
import 'package:bustracking/layout/widgets/custom_button.dart';
import 'package:bustracking/layout/widgets/custom_snackbar.dart';
import 'package:bustracking/layout/widgets/custom_text_field.dart';
import 'package:bustracking/util/app_constants.dart';
import 'package:bustracking/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditBusModal extends StatefulWidget {
  BusModel model;
  EditBusModal({Key? key, required this.model}) : super(key: key);

  @override
  State<EditBusModal> createState() => _EditBusModalState();
}

class _EditBusModalState extends State<EditBusModal> {
  final FocusNode _busNumFocus = FocusNode();
  final FocusNode _routeFocus = FocusNode();
  TextEditingController _busNumController = TextEditingController();

  @override
  void initState() {
    _busNumController.text = widget.model.bus_number!;
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
                  'Edit Bus',
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
                    hintText: 'Bus Number',
                    controller: _busNumController,
                    focusNode: _busNumFocus,
                    nextFocus: _busNumFocus,
                    inputType: TextInputType.emailAddress,
                    capitalization: TextCapitalization.words,
                    // prefixIcon: Images.user,
                    divider: true,
                  ),
                  Row(children: [
                    Expanded(
                        child: adminController.routes.length > 1
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
                                  value: adminController.selectedRoute ??
                                      adminController.routes[0],
                                  items: adminController.routes.map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value.route!),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    adminController.selectRoute(value);
                                  },
                                  isExpanded: true,
                                  underline: SizedBox(),
                                ),
                              )
                            : const Center(child: CircularProgressIndicator())),
                  ]),
                  // CustomTextField(
                  //   hintText: 'Route',
                  //   controller: _routeController,
                  //   focusNode: _routeFocus,
                  //   nextFocus: _routeFocus,
                  //   inputType: TextInputType.text,
                  //   divider: true,
                  // ),
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
    String _busNum = _busNumController.text.trim();

    if (_busNum.isEmpty) {
      showCustomSnackBar('Enter Bus Number');
    } else {
      adminController
          .updateNewBus(_busNum, adminController.selectedRoute, widget.model.id)
          .then((response) async {
        if (response) {
          Navigator.pop(context);
          showCustomSnackBar("Bus Updated Successfully!", isError: false);
        } else {
          print(response);
          showCustomSnackBar("Failed to Update Bus!", isError: true);
        }
      });
    }
  }
}

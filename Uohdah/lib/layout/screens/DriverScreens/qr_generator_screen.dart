import 'package:bustracking/controllers/parent/parent_controller.dart';
import 'package:bustracking/data/models/body/child_info.dart';
import 'package:bustracking/helper/route_helper.dart';
import 'package:bustracking/layout/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeGenerator extends StatelessWidget {
  final ChildModel model;
  final double size;

  const QRCodeGenerator({
    Key? key,
    required this.model,
    this.size = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: GetBuilder<ParentController>(builder: (homeParentController) {
          return ListView(
            children: [
              Center(
                child: QrImage(
                  data: model.id!,
                  version: QrVersions.auto,
                  size: size,
                  gapless: false,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: Text(
                  model.name!.toUpperCase(),
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                  child: CustomButton(
                buttonText: 'Ok',
                onPressed: () => Navigator.pop(context),
              )),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                  child: CustomButton(
                color: Colors.green,
                buttonText: 'Edit',
                onPressed: () async {
                  // print(model.id);
                  Navigator.pop(context);
                  Get.toNamed(RouteHelper.getUpdateChildRoute(model));
                },
              )),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                  child: CustomButton(
                color: Colors.red,
                buttonText: 'Delete',
                onPressed: () {
                  Navigator.pop(context);
                  homeParentController.deleteChild(model.id);
                },
              )),
            ],
          );
        }),
      ),
    );
  }
}

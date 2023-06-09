import 'package:bustracking/util/dimensions.dart';
import 'package:bustracking/util/images.dart';
import 'package:bustracking/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileBgWidget extends StatelessWidget {
  final Widget? circularImage;
  final Widget? mainWidget;
  final bool? backButton;
  final String? name;
  ProfileBgWidget({
    required this.mainWidget,
    required this.name,
    required this.circularImage,
    required this.backButton,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Stack(clipBehavior: Clip.none, children: [
        SizedBox(
          width: context.width,
          height: 240,
          child: Center(
              child: Image.asset(Images.bus_logo_image,
                  height: 260,
                  width: Dimensions.WEB_MAX_WIDTH,
                  fit: BoxFit.cover)),
        ),
        Positioned.directional(
          textDirection: TextDirection.ltr,
          top: 100,
          start: 0,
          end: 0,
          bottom: 0,
          child: Center(
            child: Container(
              width: Dimensions.WEB_MAX_WIDTH,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(Dimensions.RADIUS_EXTRA_LARGE)),
                color: Theme.of(context).cardColor,
              ),
            ),
          ),
        ),
        Positioned.directional(
          textDirection: TextDirection.ltr,
          top: MediaQuery.of(context).padding.top + 10,
          start: 0,
          end: 0,
          child: Text(
            'Profile',
            textAlign: TextAlign.center,
            style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeLarge,
                color: Theme.of(context).cardColor),
          ),
        ),
        Positioned.directional(
          textDirection: TextDirection.ltr,
          top: MediaQuery.of(context).padding.top,
          start: 10,
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: Theme.of(context).cardColor, size: 20),
            onPressed: () => Get.back(),
          ),
        ),
        Positioned.directional(
          textDirection: TextDirection.rtl,
          top: 140,
          start: 20,
          child: circularImage!,
        ),
        Positioned.directional(
            textDirection: TextDirection.ltr,
            top: 150,
            start: 130,
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: "Hello,".tr,
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 17)),
              TextSpan(
                  text: "\n$name",
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 17))
            ])))
      ]),
      Expanded(
        child: mainWidget!,
      ),
    ]);
  }
}

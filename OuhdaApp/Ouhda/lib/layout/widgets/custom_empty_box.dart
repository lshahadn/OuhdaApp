import 'package:bustracking/util/images.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyBoxWidget extends StatelessWidget {
  const EmptyBoxWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LottieBuilder.asset(Images.emptyBox,
                height: MediaQuery.of(context).size.height * 0.2),
            const SizedBox(height: 20),
            const Text("Sorry not found any records",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  fontFamily: "Cairo",
                )),
          ],
        ),
      ),
    );
  }
}

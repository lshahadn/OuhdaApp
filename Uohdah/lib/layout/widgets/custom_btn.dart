import 'package:bustracking/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBtn extends StatelessWidget {
  final Function()? onPressed;
  final bool fullWidth;
  final double radius;
  final double height;
  final double fontSize;
  
  final Color bg;
  final String title;
  const CustomBtn({super.key, required this.radius,required this.height, required this.fontSize, required this.bg, required this.title, required this.onPressed, required this.fullWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth ? double.infinity : null,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: bg,
      ),
      child: MaterialButton(
        // padding: const EdgeInsets.all(9),
        onPressed: onPressed,
        child: Text(
          title,
          style: GoogleFonts.lato(
            color: Colors.white,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
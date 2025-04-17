import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';
import 'package:mindful_mate/utils/extension/auto_resize.dart';
import 'package:mindful_mate/utils/extension/widget_extension.dart';


final Color textColor = injector.palette.textColor;


TextStyle kTextStyleCustom({
  required BuildContext context,
  double fontSize = 14,
  FontStyle fontStyle = FontStyle.normal,
  FontWeight fontWeight = FontWeight.w400,
  overflow = TextOverflow.visible,
 required Color? color,
}) {
  return GoogleFonts.urbanist(
    fontSize: fontSize.ww(context),
    fontWeight: fontWeight,
    fontStyle: fontStyle,
    color: color ??
       textColor
  );
}

TextStyle kTextStyleFont100({
  required double size,
  required BuildContext context,
  FontStyle fontStyle = FontStyle.normal,
}) {
  return TextStyle(
    fontSize: size.ww(context),
    fontWeight: FontWeight.w100,
    fontStyle: fontStyle,
    fontFamily: 'Poppins',
    color: textColor,
  );
}

TextStyle kTextStyleFont200({
  required BuildContext context,
  double size = 14,
  FontStyle fontStyle = FontStyle.normal,
}) {
  return TextStyle(
    fontSize: size.ww(context),
    fontWeight: FontWeight.w200,
    fontStyle: fontStyle,
    fontFamily: 'Poppins',
    color: textColor,
  );
}

TextStyle kTextStyleFont300({
  required BuildContext context,
  double size = 14,
  FontStyle fontStyle = FontStyle.normal,
}) {
  return TextStyle(
    fontSize: size.ww(context),
    fontWeight: FontWeight.w300,
    fontStyle: fontStyle,
    fontFamily: 'Poppins',
    color: textColor,
  );
}

TextStyle kTextStyleFont400({
  required BuildContext context,
  double size = 14,
  FontStyle fontStyle = FontStyle.normal,
}) {
  return TextStyle(
    fontSize: size.ww(context),
    fontWeight: FontWeight.w400,
    fontStyle: fontStyle,
    fontFamily: 'Poppins',
    color: textColor,
  );
}

TextStyle kTextStyleFont500({
  required BuildContext context,
  double size = 14,
  FontStyle fontStyle = FontStyle.normal,
}) {
  return TextStyle(
    fontSize: size.ww(context),
    fontWeight: FontWeight.w500,
    fontStyle: fontStyle,
    fontFamily: 'Poppins',
    color: textColor,
  );
}

TextStyle kTextStyleFont600({
  required BuildContext context,
  double size = 14,
  FontStyle fontStyle = FontStyle.normal,
}) {
  return TextStyle(
    fontSize: size.ww(context),
    fontWeight: FontWeight.w600,
    fontStyle: fontStyle,
    fontFamily: 'Poppins',
    color: textColor,
  );
}

TextStyle kTextStyleFont700({
  required BuildContext context,
  double size = 14,
  FontStyle fontStyle = FontStyle.normal,
}) {
  return TextStyle(
    fontSize: size.ww(context),
    fontWeight: FontWeight.w700,
    fontStyle: fontStyle,
    fontFamily: 'Poppins',
    color: textColor,
  );
}

TextStyle kTextStyleFont800({
  required BuildContext context,
  double size = 14,
  FontStyle fontStyle = FontStyle.normal,
}) {
  return TextStyle(
    fontSize: size.ww(context),
    fontWeight: FontWeight.w800,
    fontStyle: fontStyle,
    fontFamily: 'Poppins',
    color: textColor,
  );
}

TextStyle kTextStyleFont900({
  required BuildContext context,
  double size = 14,
  FontStyle fontStyle = FontStyle.normal,
}) {
  return TextStyle(
    fontSize: size.ww(context),
    fontWeight: FontWeight.w900,
    fontStyle: fontStyle,
    fontFamily: 'Poppins',
    color: textColor,
  );
}

kToastMsgPopUp({
  required String msg,
  ToastGravity toastStyle = ToastGravity.CENTER,
}) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: toastStyle,
    timeInSecForIosWeb: 1,
    backgroundColor: injector.palette.primaryColor,
    textColor: Colors.white,
    fontSize: 16,
  );
}




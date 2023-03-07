import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:meettime/common/constant.dart';
import 'package:meettime/common/http.dart';
import 'package:shimmer/shimmer.dart';
import 'package:image_picker/image_picker.dart';

notFound() {
  return Center(
      child: Opacity(
          opacity: 0.5, child: Image.asset("assets/imgs/not_found.png")));
}

singleRow(String title, String value, {double fontIncrese = 0}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    child: Row(
      children: [
        Text(title,
            style: fontStyle(
                12 + fontIncrese, AppColor.colorDark, FontWeight.w900)),
        Text(value,
            style: fontStyle(
                12 + fontIncrese, AppColor.colorGray, FontWeight.w500)),
      ],
    ),
  );
}

singleRowIcon(IconData title, String value,
    {double fontIncrese = 0, double spc = 10}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: spc),
    alignment: Alignment.centerLeft,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Icon(title, size: 20, color: AppColor.colorGray),
        SizedBox(width: 10),
        Flexible(
            child: Text(value,
                style: fontStyle(
                    14 + fontIncrese, AppColor.colorDark, FontWeight.w500))),
      ],
    ),
  );
}

fontStyle(double fontsize_, Color color_, FontWeight fontweight_,
    {double letterspacing}) {
  return TextStyle(
    color: color_,
    fontSize: fontsize_,
    fontWeight: fontweight_,
    letterSpacing: letterspacing,
  );
}

buttonCustom(String text, Function function,
    {Color color,
    MainAxisAlignment align: MainAxisAlignment.center,
    double fontsize = 18}) {
  return FadeInUp(
    child: Row(
      mainAxisAlignment: align,
      children: [
        TextButton(
          onPressed: function,
          child: Text(
            text,
            style: fontStyle(fontsize, AppColor.colorLight, FontWeight.w900),
          ),
          style: ButtonStyle(
            padding: MaterialStatePropertyAll(
                EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
            backgroundColor: MaterialStatePropertyAll(color),
          ),
        ),
      ],
    ),
  );
}

textareaBox(TextEditingController ctrl, String title,
    {String hint,
    TextInputType type,
    EdgeInsets margin: const EdgeInsets.symmetric(vertical: 5),
    IconData icons,
    int maxLine: 2,
    int delay = 0}) {
  return FadeInUp(
      animate: (delay > 0),
      duration: Duration(milliseconds: 500 + (delay * 200)),
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColor.colorLight,
        ),
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: TextFormField(
                  controller: ctrl,
                  maxLines: maxLine,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    labelStyle: TextStyle(
                      letterSpacing: 1,
                      fontSize: 14,
                      color: AppColor.colorDark,
                      fontWeight: FontWeight.bold,
                    ),
                    label: Text("${title}"),
                    contentPadding: EdgeInsets.all(10),
                    hintText: hint ?? "Enter ${title}",
                    hintStyle: TextStyle(
                      color: AppColor.colorDark,
                      fontSize: 13,
                      letterSpacing: 1,
                    ),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  )),
            ),
            Icon(
              icons ?? Icons.info_outline,
              size: 25,
              color: AppColor.colorGray,
            ),
          ],
        ),
      ));
}

inputBox(TextEditingController ctrl, String title,
    {String hint,
    TextInputType type,
    EdgeInsets margin: const EdgeInsets.symmetric(vertical: 5),
    IconData icons,
    int maxChar,
    String prefix = "",
    int delay = 0}) {
  return FadeInUp(
      // animate: (delay>0),
      // duration:  Duration(milliseconds: 500+(delay*100)),
      child: Container(
    margin: margin,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: AppColor.colorLight,
    ),
    padding: EdgeInsets.all(10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: TextFormField(
            controller: ctrl,
            keyboardType: type ?? TextInputType.text,
            // maxLength: maxChar,
            buildCounter: null,
            decoration: InputDecoration(
              // suffixIcon: ctrl.text != "" ? Icon(Icons.close_outlined) : null,
              prefix: Text("${prefix}",
                  style: fontStyle(14, AppColor.colorBlack, FontWeight.bold)),
              alignLabelWithHint: true,
              labelStyle: TextStyle(
                letterSpacing: 1,
                fontSize: 14,
                color: AppColor.colorDark,
                fontWeight: FontWeight.bold,
              ),
              label: Text("${title}"),
              contentPadding: EdgeInsets.all(10),
              hintText: hint ?? "Enter ${title}",
              hintStyle: TextStyle(
                color: AppColor.colorDark,
                fontSize: 13,
                letterSpacing: 1,
              ),
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
        ),
        Icon(
          icons ?? Icons.info_outline,
          size: 25,
          color: AppColor.colorGray,
        ),
      ],
    ),
  ));
}

scaffoldCustom(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: AppColor.colorDark,
      elevation: 0,
    ),
    body: SingleChildScrollView(
      child: Column(
        children: [1, 2, 3, 4, 5, 5, 5, 6, 6, 6, 6]
            .map((e) =>
                Text("okay chandan tiwari", style: TextStyle(fontSize: 50)))
            .toList(),
      ),
    ),
  );
}

fullButton(BuildContext context, String title, Function function) {
  return GestureDetector(
    onTap: function,
    child: Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColor.colorDark,
            blurRadius: 3,
            spreadRadius: -1,
          )
        ],
        color: AppColor.colorOrange,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: fontStyle(18, AppColor.colorDark, FontWeight.bold),
          ),
          SizedBox(width: 10),
          Icon(
            Icons.arrow_circle_right_outlined,
            color: AppColor.colorDark,
          ),
        ],
      ),
    ),
  );
}

Widget skeleton(double height, double width,
    {double radius = 10,
    EdgeInsets margin =
        const EdgeInsets.symmetric(horizontal: 12, vertical: 5)}) {
  return Shimmer.fromColors(
    baseColor: Color.fromARGB(255, 230, 235, 232),
    highlightColor: AppColor.colorWhite,
    child: Container(
      margin: margin,
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColor.colorGray,
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

takeAndUploadImage(BuildContext context, HTTP http) async {
  final ImagePicker _picker = ImagePicker();
  final XFile image = await _picker.pickImage(source: ImageSource.camera);
  // File file = File(image.path);
  context.loaderOverlay.show();
  // var tmp = base64Encode(file.readAsBytesSync());
  http.uploadImage(File(image.path));
}

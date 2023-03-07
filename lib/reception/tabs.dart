import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:meettime/common/basic.dart';
import 'package:meettime/common/constant.dart';
import 'package:meettime/common/customWidget.dart';
import 'package:meettime/common/profile.dart';
import 'package:meettime/reception/booking.dart';
import 'package:meettime/reception/dashboard.dart';

class Receptions extends StatefulWidget {
  Receptions({Key key}) : super(key: key);
  @override
  State<Receptions> createState() => _ReceptionsState();
}

class _ReceptionsState extends State<Receptions> {
  int current = 1;
  @override
  Widget build(BuildContext context) {
    var menuList = [
      {"icon": Icons.home_outlined, "title": "Home"},
      {"icon": Icons.scoreboard_outlined, "title": "Schedule"},
      {"icon": Icons.person_outline_outlined, "title": "Profile"},
    ];
    return WillPopScope(
      onWillPop: () async {
        alert_(
          context,
          desc: "Do you want to close Meet Time ?",
          onYes: () => {SystemNavigator.pop()},
          onNo: () => {Navigator.of(context).pop()},
          yesText: "Close",
        );
        return false;
      },
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          // backgroundColor: AppColor.colorBlack,
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: AppColor.colorDark,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  color: AppColor.colorMedium,
                  spreadRadius: 2,
                )
              ],
            ),
            alignment: Alignment.center,
            height: 50,
            padding: EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: menuList
                  .map((e) => GestureDetector(
                        onTap: () => {
                          setState(() => {current = menuList.indexOf(e)}),
                        },
                        child: Column(
                          children: [
                            Icon(
                              e['icon'],
                              color: current != menuList.indexOf(e)
                                  ? AppColor.colorMedium
                                  : AppColor.colorLight,
                            ),
                            Text(
                              e['title'],
                              style: fontStyle(
                                  14,
                                  current != menuList.indexOf(e)
                                      ? AppColor.colorMedium
                                      : AppColor.colorLight,
                                  current != menuList.indexOf(e)
                                      ? FontWeight.w400
                                      : FontWeight.bold),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
          body: current == 2
              ? Profiles()
              : current == 1
                  ? Bookings()
                  : Dashboard(),
        ),
      ),
    );
  }
}

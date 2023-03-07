import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:meettime/common/constant.dart';
import 'package:meettime/common/customWidget.dart';
import 'package:meettime/common/http.dart';
import 'package:meettime/getx.dart';

class LogIn extends StatefulWidget {
  const LogIn();
  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  final DataController get = Get.put(DataController());
  HTTP http = HTTP();
  loginNow() {
    if (username.text == null || password.text == null) {
      return;
    }
    context.loaderOverlay.show();

    http
        .postData("manage_data.php?login_user", {
          "username": username.text,
          "password": password.text,
        })
        .then((value) => {
              print(value),
              context.loaderOverlay.hide(),

              if (value['status'] && value['data'].length > 0)
                {
                  get.userDetail = value['data'][0],
                  get.storage.write( 
                      key: "userDetail", value: json.encode(value['data'][0])),
                  if (get.userDetail != null && get.userDetail['cat_id'] == "1")
                    {Get.toNamed("/doctor")}
                  else if (get.userDetail != null &&
                      get.userDetail['cat_id'] == "3")
                    {Get.toNamed("/reception")}
                }
            })
        .catchError((e) => {
              context.loaderOverlay.hide(),
              print(e),
            });
    // final DataController GetX = Get.put(DataController());
    // GetX.userDetail = {'name': 'chandan tiwari'};
  }

  @override
  void initState() {
    super.initState();
    username.text = "1234567890";
    password.text = "1235";
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/imgs/splash.jpeg"), fit: BoxFit.cover),
        ),
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: 450, minWidth: 330),
                margin: EdgeInsets.all(20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColor.colorWhite,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[300],
                        blurRadius: 4,
                      )
                    ]),
                child: Column(
                  children: [
                    FadeInDown(
                      child: Image.asset(
                        "assets/imgs/icon.png",
                        width: 100,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Meet Time",
                      style:
                          fontStyle(25, AppColor.colorBlack, FontWeight.bold),
                    ),
                    Text(
                      "Login to continue",
                      style:
                          fontStyle(14, AppColor.colorMedium, FontWeight.w300)
                              .merge(TextStyle(letterSpacing: 5)),
                    ),
                    const SizedBox(height: 30),
                    inputBox(username, "Email Address",
                        icons: Icons.email_outlined),
                    inputBox(password, "Password",
                        type: TextInputType.visiblePassword,
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        icons: Icons.lock_outline_rounded),
                    const SizedBox(height: 10),
                    buttonCustom(
                      "   Login   ",
                      loginNow,
                      color: AppColor.colorRed,
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      ),
      onWillPop:()async=> false
    );
  }
}

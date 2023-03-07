import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meettime/common/customWidget.dart';
import 'package:meettime/common/http.dart';
import 'package:meettime/getx.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen();
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final DataController get = Get.put(DataController());

  @override
  void initState() {
    super.initState();
    get.initAppFirst();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 230, 227, 220),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/imgs/splash.jpeg"), fit: BoxFit.cover),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 400),
                width: MediaQuery.of(context).size.width / 1.4,
                child: const Image(
                  alignment: Alignment.center,
                  image: AssetImage("assets/imgs/splash.gif"),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                "Meet Time",
                style: TextStyle(
                  fontFamily: "MainluxLight",
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 7,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                "Appointment management system",
                style: TextStyle(
                  fontFamily: "MainluxLight",
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 5,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

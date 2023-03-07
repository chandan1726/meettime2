import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:meettime/auth/logIn.dart';
import 'package:meettime/auth/signIn.dart';
import 'package:meettime/common/constant.dart';
import 'package:meettime/common/patientDetail.dart';
import 'package:meettime/doctor/tabs.dart';
import 'package:meettime/getx.dart';
import 'package:meettime/reception/AllAppointments.dart';
import 'package:meettime/reception/AllPatient.dart';
import 'package:meettime/reception/NewAppointment.dart';
import 'package:meettime/reception/NewPatient.dart';
import 'package:meettime/reception/dashboard.dart';
import 'package:meettime/reception/tabs.dart';
import 'package:meettime/start/splash.dart';
import 'package:meettime/test.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DataController GetX = Get.put(DataController());
    return GlobalLoaderOverlay(
        closeOnBackButton: true,
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Meet Time',
          theme: ThemeData(
            fontFamily: "MainluxLight",
            primaryTextTheme: TextTheme(),
            textButtonTheme: TextButtonThemeData(),
            primaryColorDark: Colors.red,
            primaryColor: Colors.amberAccent,
            primaryColorLight: Colors.orange,
            backgroundColor: Colors.amberAccent,
            bottomAppBarColor: Colors.amber,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              color: Colors.amber,
            ),
            textTheme: TextTheme(),
          ),
          initialRoute: '/',
          navigatorKey: Get.key,
          routes: {
            '/': (context) => SplashScreen(),
            '/login': (context) => LogIn(),
            '/signin': (context) => SignIn(),
            '/reception': (context) => Receptions(),
            '/newAppointment': (context) => NewAppointment(),
            '/NewPatient': (context) => NewPatient(),
            '/AllAppointments': (context) => AllAppointments(),
            '/AllPatient': (context) => AllPatient(),
            '/PatientDetail': (context) => PatientDetail(),
            '/doctor': (context) => Doctor(),
          },
        ));
  }
}

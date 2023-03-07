import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:meettime/common/http.dart';

class DataController extends GetxController {
  Map<String, dynamic> userDetail = {};
  Map<String, dynamic> appSetting = {};
  final storage = const FlutterSecureStorage();
  var info_appointment = [];
  var recentAppointments = [];
  var profile_appointment = {
    'total':0,
    'pending':0, 
    'cancel':0
  };

  initAppFirst() async {
    var tmp = await storage.read(key: "userDetail");
    print(tmp);
    if (tmp != null) {
      userDetail = json.decode(tmp);
    }
    HTTP http = HTTP();
    http.getData("manage_data.php?get_settings").then((r) {
      if (r['status']) {
        for (var i in r['data']) {
          appSetting[i['s_key']] = i['s_val'];
        }
      } else {}
    }).catchError((e) => {
          print(e),
        });
    Timer(Duration(seconds: 3),
        () => {Get.offAllNamed(tmp == null ? "/login" : "/reception")});
  }
}

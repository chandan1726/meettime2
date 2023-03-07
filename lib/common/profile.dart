import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:meettime/common/basic.dart';
import 'package:meettime/common/constant.dart';
import 'package:meettime/common/customWidget.dart';
import 'package:meettime/common/http.dart';
import 'package:meettime/getx.dart';

class Profiles extends StatefulWidget {
  Profiles({Key key}) : super(key: key);
  @override
  State<Profiles> createState() => _ProfilesState();
}

class _ProfilesState extends State<Profiles> {
  HTTP http = HTTP();
  final DataController get = Get.put(DataController());
  bool loader = true;

  @override
  void initState() {
    super.initState();
    loader = true;
    http
        .getData(
            "manage_data.php?info_appointment_profile=${get.userDetail['u_id']}")
        .then((value) => {
              if (value['status']){
                get.profile_appointment = value['data'],
                setState(() {
                  loader = false;
                })
              }
            })
        .catchError((e) => {
              setState(() {
                loader = false;
              }),
              print(e),
            });
  }

  // {"u_id":"1","u_name":"admin","u_contact_primary":"1234567890","u_email":"meettime@gmail.",
  //"cat_id":"7","h_id":"0","u_note":"admin of meet-time system","u_photo":"","is_enable":"1",
  //"u_pass":"1235","u_address":"","u_pincode":"0","u_contact_secondary":"","h_name":null,
  //"h_address":null,"h_pincode":null,"h_contact_primary":null,"h_contact_secondary":null,
  //"h_email_address":null,"h_note":null,"h_services":null,"cat_name":null}

  @override
  Widget build(BuildContext context) {
    print(get.profile_appointment);
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 300,
            decoration: BoxDecoration(
              color: AppColor.colorDark,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ZoomIn(
                  child: 
                  GestureDetector(child:
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.colorLight,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Icon(
                      Icons.person_outline_outlined,
                      size: 60,
                      color: AppColor.colorMedium,
                    ),
                  ),
                  onTap:()=>{
                      takeAndUploadImage(context,http)
                    }
                  ),
                ),
                SizedBox(height: 40),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      {
                        "title": "Total\nAppointment",
                        "score": get.profile_appointment['total']
                      },
                      {
                        "title": "Active\nAppointment",
                        "score": get.profile_appointment['pending']
                      },
                      {
                        "title": "Cancelled\nAppointment",
                        "score": get.profile_appointment['cancel']
                      },
                    ]
                        .map((e) => Flexible(
                              child: Column(
                                children: [
                                  Text(
                                    e['title'],
                                    style: fontStyle(12, AppColor.colorLight,
                                        FontWeight.w900),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "${e['score']}",
                                    style: fontStyle(25, AppColor.colorWhite,
                                        FontWeight.w900),
                                  )
                                ],
                              ),
                            ))
                        .toList())
              ],
            ),
          ),
          FadeInUp(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColor.colorLight,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    color: AppColor.colorDark,
                    spreadRadius: -3,
                  )
                ],
              ),
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: AppColor.colorGray, width: 1))),
                  child: Text(" Hospital detail",
                      style: fontStyle(16, AppColor.colorBlack, FontWeight.bold)),
                ),
                listItem("Name", get.userDetail['h_name'],
                    Icons.local_hospital_outlined),
                listItem("Contact", get.userDetail['h_contact_primary'],
                    Icons.phone_outlined),
                listItem(
                    "Address",
                    "${get.userDetail['h_address']} ${get.userDetail['h_pincode']}",
                    Icons.home_outlined),
                listItem("Email address", get.userDetail['h_email_address'],
                    Icons.email_outlined),
                listItem("Services", get.userDetail['h_services'],
                    Icons.medical_services_outlined),
              ]),
            )
          ),
          FadeInUp(
            delay: Duration(milliseconds:300),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColor.colorLight,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    color: AppColor.colorDark,
                    spreadRadius: -3,
                  )
                ],
              ),
              child: Column(children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: AppColor.colorGray, width: 1))),
                  child: Text(" User detail",
                      style: fontStyle(16, AppColor.colorBlack, FontWeight.bold)),
                ),
                listItem("Name", get.userDetail['u_name'], Icons.person_outline),
                listItem(
                    "Contact no",
                    "+91 ${get.userDetail['u_contact_primary']}",
                    Icons.phone_outlined),
                listItem("Email address", get.userDetail['u_email'],
                    Icons.email_outlined),
                listItem(
                    "Note",
                    get.userDetail['u_note'] != ""
                        ? get.userDetail['u_note']
                        : "No note for you",
                    Icons.note_alt_outlined),
              ]),
            ),
          ),
          SizedBox(height: 5),
          FadeInUp(
            delay: Duration(milliseconds:500),
            child: GestureDetector(
              onTap: () async {
                alert_(context,
                    title: "Confirm",
                    desc: "Are you sure you want to log out ?",
                    onYes: () {
                      final storage = const FlutterSecureStorage();
                      storage.deleteAll();
                      Get.offAndToNamed("/login");
                    },
                    yesText: "Logout",
                    noText: "Cancel",
                    onNo: () => {Get.back()});
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.colorLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      color: AppColor.colorMedium,
                      size: 25,
                    ),
                    Text(
                      "  Log Out",
                      style: fontStyle(
                          16, Color.fromARGB(255, 174, 43, 33), FontWeight.bold),
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 18,
                      color: AppColor.colorMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  listItem(String title, String subtitle, IconData icon) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        children: [
          Icon(
            icon,
            size: 30,
            color: AppColor.colorDark,
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: fontStyle(13, AppColor.colorDark, FontWeight.w800),
              ),
              Text(
                subtitle,
                style: fontStyle(12, AppColor.colorDark, FontWeight.w400),
              )
            ],
          ),
        ],
      ),
    );
  }
}

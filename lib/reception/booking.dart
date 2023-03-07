import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:meettime/common/basic.dart';
import 'package:meettime/common/constant.dart';
import 'package:meettime/common/customWidget.dart';
import 'package:meettime/common/http.dart';
import 'package:meettime/getx.dart';
import 'package:shimmer/shimmer.dart';

class Bookings extends StatefulWidget {
  const Bookings({Key key}) : super(key: key);
  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  TextEditingController searchCtrl = TextEditingController();
  HTTP http = HTTP();
  final DataController get = Get.put(DataController());
  bool loader = true;

  @override
  void initState() {
    super.initState();
    loader = true;
    http.getData("manage_data.php?recent_appointment=${get.userDetail['u_id']}")
    .then((value) => {
      if (value['status'])
        setState(() {
          loader = false;
          get.recentAppointments = value['data'];
        })
    })
    .catchError((e) => {
      setState(() {
        loader = false;
      }),
      print(e),
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        fit: StackFit.loose,
        children: [
          Container(
            height: 150,
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              color: AppColor.colorDark,
            ),
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 90, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${get.userDetail['u_name']}",
                      style:
                          fontStyle(12, AppColor.colorWhite, FontWeight.w500),
                    ),
                    Text(
                      "Welcome back",
                      style:
                          fontStyle(18, AppColor.colorWhite, FontWeight.w900),
                    ),
                  ],
                ),
                GestureDetector(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.person_outline_sharp,
                        size: 35,
                      ),
                    ),
                  ),
                  onTap: () => {
                    print("Okay dear"),
                  },
                ),
              ],
            ),
          ),
          
          Container(
              margin: EdgeInsets.only(top: 150),
              height: MediaQuery.of(context).size.height - 150,
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(children: [
                  SizedBox(height: 70),
                  Row(
                    children: [
                      SizedBox(width: 10),
                      Icon(
                        Icons.api_rounded,
                        size: 22,
                        color: AppColor.colorDark,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Recent Appointments",
                        style: fontStyle(18, AppColor.colorDark, FontWeight.w600),
                      ),
                      Spacer(),
                      TextButton(
                        child: Text(
                          "View All",
                          // style:fontStyle(12, AppColor.colorDark, FontWeight.bold),
                        ),
                        onPressed: () => {Get.toNamed("/AllAppointments")},
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              // side: BorderSide(color: Colors.red),
                            ),
                          ),
                          foregroundColor:
                              MaterialStatePropertyAll(AppColor.colorDark),
                          backgroundColor:
                              MaterialStatePropertyAll(AppColor.colorLight),
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    decoration: BoxDecoration(
                      color: AppColor.colorDark,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(flex:1,child:
                        Text("No",
                            style: fontStyle(
                                16, AppColor.colorLight, FontWeight.bold)),),
                                Expanded(flex:3,child:
                        Text("Contact no",
                            style: fontStyle(
                                16, AppColor.colorLight, FontWeight.bold)),),
                                Expanded(flex:3,child:
                        Text("Patient name",
                            style: fontStyle(
                                16, AppColor.colorLight, FontWeight.bold)),),
                      ],
                    ),
                  ),
                  (loader && get.recentAppointments.length==0)?
                  Column(children: [1,2,3,3,2,3,3].map((ee)=>skeleton(40, MediaQuery.of(context).size.width)).toList()):
                  get.recentAppointments.length == 0
                  ? Container(child: notFound(),margin: EdgeInsets.symmetric(vertical: 70))
                  : Container(),
                  ...get.recentAppointments.map((e) => 
                      FadeInUp(
                        animate: true,
                        duration:  Duration(milliseconds: 500+(get.recentAppointments.indexOf(e)*200)),
                        child: Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColor.colorLight,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(flex:1,child:Text(e['a_serial'])),
                                    Expanded(flex:3,child:Text("+91 ${e['p_contact_primary']}")),
                                    Expanded(flex:3,child:Text("${e['p_name']}")),
                                  ],
                                ),
                              )
                      )
                    ).toList(),
                  FadeInUp(
                    animate: true,
                    duration:  Duration(seconds: 1),
                    child: fullButton(context, "View All Appointment",() => {Get.toNamed("/AllAppointments")})
                  )
                ]),
              ),
            ),

          
          Positioned(
              top: 80,
              left: 20,
              right: 20,
              child: 
              FadeInDown(
                animate: true,
                duration: const Duration(milliseconds: 500),
                child:Container(
                alignment: Alignment.centerRight,
                height: 120,
                padding: EdgeInsets.only(right: 60),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.colorMedium,
                      blurRadius: 3,
                      spreadRadius: 0,
                    )
                  ],
                  color: AppColor.colorLight,
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    alignment: Alignment.center,
                    fit: BoxFit.cover,
                    image: AssetImage("assets/imgs/recept_booking.jpg"),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      "Book Appointment",
                      style:
                          fontStyle(13, AppColor.colorWhite, FontWeight.w400),
                    ),
                    Text(
                      "With Doctor",
                      style:
                          fontStyle(14, AppColor.colorLight, FontWeight.w800),
                    ),
                    SizedBox(height: 5),
                    GestureDetector(
                      onTap: () async {
                        String tmp = await FlutterBarcodeScanner.scanBarcode(
                            "#ff6666", "Cancel", false, ScanMode.DEFAULT);
                        if (tmp != "-1") {
                          context.loaderOverlay.show();
                          http
                              .getData(
                                  "manage_data.php?get_patient_scan_receipt=${tmp}")
                              .then((value) => {
                                context.loaderOverlay.hide(),
                                if (value['status']){
                                  Get.toNamed("/newAppointment",arguments: 
                                    {
                                      "p_id":value['data'][0]['p_id'],
                                      "d_id":value['data'][0]['d_id'],
                                      "p_name":value['data'][0]['p_name'],
                                      "p_contact_primary":value['data'][0]['p_contact_primary']
                                    }
                                  )
                                }else{
                                  toast_(context,
                                  icon_: Icons.error_outline,
                                  msg: "Failed",
                                  title: "Barcode Does not matched")
                                }
                              })
                              .catchError((e) => {
                                context.loaderOverlay.hide(),
                                toast_(context,
                                icon_: Icons.error_outline,
                                msg: "Server Failed",
                                title: "Server Failed Try Again Later")
                              });
                        }else{
                          
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: AppColor.colorMedium,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "BOOK NOW !",
                          style: fontStyle(
                              9, AppColor.colorLight, FontWeight.w900),
                        ),
                      ),
                    ),
                  ],
                ),
              )))
        ],
      ),
    );
  }
}

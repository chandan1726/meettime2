import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:meettime/common/basic.dart';
import 'package:meettime/common/constant.dart';
import 'package:meettime/common/customWidget.dart';
import 'package:meettime/common/http.dart';
import 'package:meettime/getx.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

class PatientDetail extends StatefulWidget {
  PatientDetail({Key key}) : super(key: key);
  @override
  State<PatientDetail> createState() => _PatientDetailState();
}

class _PatientDetailState extends State<PatientDetail> {
  HTTP http = HTTP();
  final DataController get = Get.put(DataController());
  Map<String, dynamic> allData = Get.arguments;
  var AppointmentList = [];
  bool loader = true;
  TextEditingController desc;

  loadData() {
    setState(() {
      loader = true;
    });
    http
        .getData("manage_data.php?patient_detail=${allData['p_id']}")
        .then((value) => {
              context.loaderOverlay.hide(),
              if (value['status'])
                setState(
                    () => {loader = false, AppointmentList = value['data']})
              else
                setState(() => {loader = false})
            })
        .catchError((e) => {
              setState(() {
                loader = false;
              }),
              context.loaderOverlay.hide(),
              print(e),
            });
  }

  @override
  void initState() {
    super.initState();
    loadData();
    desc = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 249, 251, 251),
      appBar: AppBar(
        backgroundColor: AppColor.colorDark,
        title: Text("Patients Detail"),
        actions: [],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.colorLight,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.person_outline_outlined,
                      size: 30,
                      color: AppColor.colorMedium,
                    ),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(allData['p_name'],
                          style: fontStyle(
                              18, AppColor.colorDark, FontWeight.w900)),
                      SizedBox(height: 2),
                      Text(allData['p_email_address'],
                          style: fontStyle(
                              16, AppColor.colorMedium, FontWeight.w400))
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30),
              singleRowIcon(Icons.home_outlined,
                  "${allData['p_address']} , ${allData['p_pincode']}"),
              singleRowIcon(
                  Icons.call_outlined, "+91 ${allData['p_contact_primary']}"),
              singleRowIcon(Icons.phone_android_outlined,
                  "+91 ${allData['p_contact_secondary']}"),
              singleRowIcon(
                  Icons.mail_outline, "${allData['p_email_address']}"),
              singleRowIcon(Icons.medical_information_outlined,
                  "${allData['p_disease']}"),
              singleRowIcon(Icons.note_alt_outlined, "${allData['p_desc']}"),
              singleRowIcon(
                  Icons.medical_services_rounded, "${allData['u_name']}"),
              SizedBox(height: 50),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  child: SfBarcodeGenerator(
                      value: allData['bar_code'], showValue: true)),
              SizedBox(height: 50),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: AppColor.colorLight, width: 1)),
                ),
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Appointments",
                        style: fontStyle(
                            16, AppColor.colorBlack, FontWeight.w900)),
                    TextButton(
                      onPressed: () => {
                        Get.toNamed("/newAppointment", arguments: {
                          "d_id": allData['d_id'],
                          "p_id": allData['p_id'],
                          "p_name": allData['p_name'],
                          "p_contact_primary": allData['p_contact_primary']
                        }).then((value) => {
                              loadData(),
                            })
                      },
                      child: Text("Book Now",
                          style: fontStyle(
                              12, AppColor.colorBlack, FontWeight.w900)),
                      style: ButtonStyle(
                        padding: MaterialStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 0, horizontal: 10)),
                        backgroundColor:
                            MaterialStatePropertyAll(AppColor.colorOrangeDark),
                      ),
                    ),
                  ],
                ),
              ),
              loader? 
      Column(children: [1].map((ee)=> 
        FadeInUp(
          animate: true,
          duration:  Duration(milliseconds: 500+(ee*300)),
          child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border:Border.all(color: Colors.grey[200], width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.colorLight,
                      borderRadius:
                          BorderRadius.circular(50),
                    ),
                    height: 35,
                    width: 35,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5),
                  ), 
                  Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      skeleton(10, 60,margin: EdgeInsets.symmetric(horizontal: 10,vertical: 3)),
                      skeleton(10, 100,margin: EdgeInsets.symmetric(horizontal: 10,vertical: 3)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              skeleton(10, 220,margin: EdgeInsets.symmetric(horizontal: 0,vertical: 5)),
              skeleton(10, 250,margin: EdgeInsets.symmetric(horizontal: 0,vertical: 5)),
              skeleton(10, 100,margin: EdgeInsets.symmetric(horizontal: 0,vertical: 5)),
              skeleton(10, 200,margin: EdgeInsets.symmetric(horizontal: 0,vertical: 5)),
              skeleton(10, 150,margin: EdgeInsets.symmetric(horizontal: 0,vertical: 5)),
            ]
          ),
        ))).toList())
                  // Container(
                  //     alignment: Alignment.center,
                  //     height: 200,
                  //     child: CircularProgressIndicator())


                  : AppointmentList.length == 0
                      ? notFound()
                      : Container(),
              ...AppointmentList.map((e) => Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[200], width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColor.colorLight,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                height: 35,
                                width: 35,
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(5),
                                child: Text("${e['a_serial']}",
                                    style: fontStyle(
                                        "${e['a_serial']}".length > 1 ? 12 : 18,
                                        AppColor.colorGray,
                                        FontWeight.w900,
                                        letterspacing: 1.2)),
                              ),
                              Flexible(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${e['doc_name']}",
                                      style: fontStyle(13, AppColor.colorMedium,
                                          FontWeight.w900,
                                          letterspacing: 1.2)),
                                  Text("+91 ${e['doc_contact']}",
                                      style: fontStyle(10, AppColor.colorGray,
                                          FontWeight.w900,
                                          letterspacing: 1.2)),
                                ],
                              )),
                              Spacer(),
                              Icon(
                                e['is_done'] == "1"
                                    ? Icons.done_all_rounded
                                    : e['is_cancel'] == "1"
                                        ? Icons.close
                                        : Icons.watch_later_outlined,
                                color: e['is_done'] == "1"
                                    ? AppColor.colorOrangeDark
                                    : e['is_cancel'] == "1"
                                        ? AppColor.colorRed
                                        : AppColor.colorMedium,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 7),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.grey[200], width: 0.5),
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(10)),
                          ),
                          width: MediaQuery.of(context).size.width,
                        ),
                        singleRowIcon(
                            Icons.date_range_outlined, "${e['at_date_format']}",
                            spc: 2, fontIncrese: -3),
                        singleRowIcon(Icons.money, "₹ ${e['amount']}",
                            spc: 2, fontIncrese: -3),
                        singleRowIcon(Icons.note_alt_outlined, "${e['a_desc']}",
                            spc: 2, fontIncrese: -3),
                        e['is_done'] == "1" || e['is_cancel'] == "1" ? Container()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () => {
                                  desc.text=e['a_desc'],
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Cancel Appointment",
                                              style: fontStyle(
                                                  16,
                                                  AppColor.colorGray,
                                                  FontWeight.bold)),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(
                                                          20.0))),
                                          content: Container(
                                            height: 130,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceAround,
                                              children: [
                                                textareaBox(
                                                    desc, "Description",
                                                    icons: Icons
                                                        .note_alt_outlined,
                                                    maxLine: 5,
                                                    hint:
                                                        "Add reason about the cancellation appointment"),
                                              ],
                                            ),
                                          ),
                                          actionsAlignment:
                                              MainAxisAlignment.end,
                                          actions: [
                                            TextButton(
                                                style: ButtonStyle(
                                                  padding:
                                                      MaterialStateProperty
                                                          .all(EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      20,
                                                                  vertical:
                                                                      10)),
                                                  foregroundColor:
                                                      MaterialStateProperty
                                                          .all(
                                                              Colors.white),
                                                  backgroundColor:
                                                      MaterialStateProperty
                                                          .all(
                                                              Colors.green),
                                                ),
                                                onPressed: () => {
                                                      Get.back(),
                                                    },
                                                child: Text(
                                                  'Cancel',
                                                  style: fontStyle(
                                                      15,
                                                      AppColor.colorLight,
                                                      FontWeight.w900),
                                                )),
                                            TextButton(
                                                style: ButtonStyle(
                                                  padding:
                                                      MaterialStateProperty
                                                          .all(EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      20,
                                                                  vertical:
                                                                      10)),
                                                  foregroundColor:
                                                      MaterialStateProperty
                                                          .all(
                                                              Colors.black),
                                                  backgroundColor:
                                                      MaterialStateProperty
                                                          .all(AppColor
                                                              .colorOrangeDark),
                                                ),
                                                onPressed: () {
                                                  var tmp = {
                                                    "a_id": e['a_id'],
                                                    "a_desc": desc.text,
                                                  };
                                                  context.loaderOverlay
                                                      .show();
                                                  http
                                                      .postData(
                                                          "manage_data.php?cancel_appointment",
                                                          tmp)
                                                      .then((value) => {
                                                            context
                                                                .loaderOverlay
                                                                .hide(),
                                                            if (value[
                                                                'status'])
                                                              {
                                                                toast_(
                                                                    context,
                                                                    icon_: Icons
                                                                        .done_all_outlined,
                                                                    msg:
                                                                        "Appointment Cancelled successfully",
                                                                    title:
                                                                        "Failed"),
                                                                loadData(),
                                                                Get.back(),
                                                              }
                                                            else
                                                              {
                                                                toast_(
                                                                    context,
                                                                    icon_: Icons
                                                                        .error_outline_rounded,
                                                                    msg:
                                                                        "Appointment Cancellation Failed",
                                                                    title:
                                                                        "Failed"),
                                                              },
                                                          })
                                                      .catchError((e) => {
                                                            context
                                                                .loaderOverlay
                                                                .hide(),
                                                            print(e),
                                                            toast_(context,
                                                                icon_: Icons
                                                                    .error_outline_rounded,
                                                                msg:
                                                                    "Server failed, please try again",
                                                                title:
                                                                    "Server Failed"),
                                                          });
                                                },
                                                child: Text(
                                                  'Submit',
                                                  style: fontStyle(
                                                      15,
                                                      AppColor.colorDark,
                                                      FontWeight.w900),
                                                )),
                                          ],
                                        );
                                      })
                                },
                                child: Container(
                                  child: Text("Cancel appointment",
                                      style: fontStyle(
                                          10,
                                          AppColor.colorRed,
                                          FontWeight.bold)),
                                ),
                              )
                            ],
                          )
                        // Text("",style: fontStyle(12, AppColor.colorDark, FontWeight.w900,letterspacing: 1.2)),
                        // singleRow("Conact :   ", "${e['doc_contact']}"),
                      ],
                    ),
                  )).toList()
            ],
          ),
        ),
      ),
    );
  }
}

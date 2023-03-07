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

class AllAppointments extends StatefulWidget {
  AllAppointments({Key key}) : super(key: key);
  @override
  State<AllAppointments> createState() => _AllAppointmentsState();
}

class _AllAppointmentsState extends State<AllAppointments> {
  HTTP http = HTTP();
  final DataController get = Get.put(DataController());
  Map<String, dynamic> allData = Get.arguments;
  var AppointmentList = [];
  bool loader = true;
  TextEditingController desc;

  loadData() {
    setState(() => {loader = true});
    http.getData("manage_data.php?get_appointments_reception=${get.userDetail['u_id']}").then((value) => {
      if (value['status'])
        setState(() => {AppointmentList = value['data'],loader = false})
    })
    .catchError((e) => {
      setState(() => {loader = false}),
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
        title: Text("Appointment List"),
        actions: [],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: 
        loader?
        Column(children: [1,2,3].map((ee)=> 
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
        ))).toList()):
        AppointmentList.length == 0
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [notFound()])
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...AppointmentList.map((e) => Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.grey[200], width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () => {
                                  Get.toNamed("/PatientDetail", arguments: e),
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                            child: Text("${e['a_serial']}",
                                                style: fontStyle(
                                                    "${e['a_serial']}".length >
                                                            1
                                                        ? 12
                                                        : 18,
                                                    AppColor.colorGray,
                                                    FontWeight.w900,
                                                    letterspacing: 1.2)),
                                          ),
                                          Flexible(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("${e['doc_name']}",
                                                  style: fontStyle(
                                                      13,
                                                      AppColor.colorMedium,
                                                      FontWeight.w900,
                                                      letterspacing: 1.2)),
                                              Text("+91 ${e['doc_contact']}",
                                                  style: fontStyle(
                                                      10,
                                                      AppColor.colorGray,
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
                                                    : Icons
                                                        .watch_later_outlined,
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
                                        border: Border.all(
                                            color: Colors.grey[200],
                                            width: 0.5),
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10)),
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                    singleRowIcon(Icons.person_outline_outlined,
                                        "${e['p_name']}",
                                        spc: 2, fontIncrese: -3),
                                    singleRowIcon(Icons.phone_outlined,
                                        "+91 ${e['p_contact_primary']}",
                                        spc: 2, fontIncrese: -3),
                                    singleRowIcon(Icons.date_range_outlined,
                                        "${e['at_date_format']}",
                                        spc: 2, fontIncrese: -3),
                                    singleRowIcon(
                                        Icons.money, "₹ ${e['amount']}",
                                        spc: 2, fontIncrese: -3),
                                    singleRowIcon(Icons.note_alt_outlined,
                                        "${e['a_desc']}",
                                        spc: 2, fontIncrese: -3),
                                  ],
                                ),
                              ),
                              e['is_done'] == "1" || e['is_cancel'] == "1"
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () => {
                                            desc.text = e['a_desc'],
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        "Cancel Appointment",
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
                                                          textareaBox(desc,
                                                              "Description",
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
                                                            padding: MaterialStateProperty
                                                                .all(EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            20,
                                                                        vertical:
                                                                            10)),
                                                            foregroundColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                        .white),
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                        .green),
                                                          ),
                                                          onPressed: () => {
                                                                Get.back(),
                                                              },
                                                          child: Text(
                                                            'Cancel',
                                                            style: fontStyle(
                                                                15,
                                                                AppColor
                                                                    .colorLight,
                                                                FontWeight
                                                                    .w900),
                                                          )),
                                                      TextButton(
                                                          style: ButtonStyle(
                                                            padding: MaterialStateProperty
                                                                .all(EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            20,
                                                                        vertical:
                                                                            10)),
                                                            foregroundColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                        .black),
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(AppColor
                                                                        .colorOrangeDark),
                                                          ),
                                                          onPressed: () {
                                                            var tmp = {
                                                              "a_id": e['a_id'],
                                                              "a_desc":
                                                                  desc.text,
                                                            };
                                                            context
                                                                .loaderOverlay
                                                                .show();
                                                            http
                                                                .postData(
                                                                    "manage_data.php?cancel_appointment",
                                                                    tmp)
                                                                .then(
                                                                    (value) => {
                                                                          context
                                                                              .loaderOverlay
                                                                              .hide(),
                                                                          if (value[
                                                                              'status'])
                                                                            {
                                                                              toast_(context, icon_: Icons.done_all_outlined, msg: "Appointment Cancelled successfully", title: "Failed"),
                                                                              loadData(),
                                                                              Get.back(),
                                                                            }
                                                                          else
                                                                            {
                                                                              toast_(context, icon_: Icons.error_outline_rounded, msg: "Appointment Cancellation Failed", title: "Failed"),
                                                                            },
                                                                        })
                                                                .catchError(
                                                                    (e) => {
                                                                          context
                                                                              .loaderOverlay
                                                                              .hide(),
                                                                          print(
                                                                              e),
                                                                          toast_(
                                                                              context,
                                                                              icon_: Icons.error_outline_rounded,
                                                                              msg: "Server failed, please try again",
                                                                              title: "Server Failed"),
                                                                        });
                                                          },
                                                          child: Text(
                                                            'Submit',
                                                            style: fontStyle(
                                                                15,
                                                                AppColor
                                                                    .colorDark,
                                                                FontWeight
                                                                    .w900),
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

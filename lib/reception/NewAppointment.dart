import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:meettime/common/basic.dart';
import 'package:meettime/common/constant.dart';
import 'package:meettime/common/customWidget.dart';
import 'package:meettime/common/http.dart';
import 'package:meettime/getx.dart';

class NewAppointment extends StatefulWidget {
  NewAppointment({Key key}) : super(key: key);
  @override
  State<NewAppointment> createState() => _NewAppointmentState();
}

class _NewAppointmentState extends State<NewAppointment> {
  TextEditingController amount, desc;
  HTTP http = HTTP();
  final DataController get = Get.put(DataController());
  Map<String, dynamic> allData = Get.arguments;
  String doctorSelected;
  var doctorList = [];

  @override
  void initState() {
    super.initState();
    amount = TextEditingController();
    desc = TextEditingController();
    context.loaderOverlay.show();
    doctorSelected = allData['d_id'];
    http.getData("get.php?users/cat_id=1/h_id=${get.userDetail['h_id']}").then((value) => {
      context.loaderOverlay.hide(),
      if (value['status']) setState(() => {doctorList = value['data']})
    })
    .catchError((e) => {
      context.loaderOverlay.hide(),
      print(e),
    });
  }

  bookAppointment() {
    context.loaderOverlay.show();
    var tmp = {
      "p_id": allData['p_id'],
      "is_paid": amount.text != null && amount.text != "" ? 1 : 0,
      "amount": amount.text,
      "a_desc": desc.text,
      "u_id": get.userDetail['u_id'],
      "d_id": doctorSelected
    };
    http.postData("manage_data.php?book_appointment", tmp).then((value) => {
      context.loaderOverlay.hide(),
      if (value['status']) {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0))),
                        content: Container(
                          height: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // Text("Token No",style:fontStyle(20, AppColor.colorDark, FontWeight.bold)),
                              Image.asset(
                                "assets/imgs/done.png",
                                height: 150,
                              ),
                              // Text("${value['data']['lst']}",style:fontStyle(60, AppColor.colorOrangeDark, FontWeight.bold)),
                              Text("Appointment Booked \nSuccessfully",
                                  textAlign: TextAlign.center,
                                  style:fontStyle(16, AppColor.colorGray, FontWeight.w400)),
                            ],
                          ),
                        ),
                        actionsAlignment: MainAxisAlignment.center,
                        actions: [
                          TextButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                                foregroundColor: MaterialStateProperty.all(Colors.white),
                                backgroundColor: MaterialStateProperty.all(Colors.green),
                              ),
                              onPressed: () => {Get.back(), Get.back()},
                              child: Text(
                                '     Ok      ',
                                style: fontStyle(15, AppColor.colorLight, FontWeight.w900),
                              )),
                        ],
                      );
                    })
        }
      else {
          toast_(context,
              icon_: Icons.error_outline_rounded,
              msg: "Appointment Booking Failed",
              title: "Error"),
        },
    }).catchError((e) => {
      context.loaderOverlay.hide(),
      print(e),
      toast_(context,
          icon_: Icons.error_outline_rounded,
          msg: "Server failed please try again",
          title: "Server Failed"),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColor.colorDark,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                allData['p_name'],
                style: fontStyle(16, AppColor.colorWhite, FontWeight.bold)
                    .merge(TextStyle(letterSpacing: 1)),
              ),
              Text(
                "+91 ${allData['p_contact_primary']}",
                style: fontStyle(12, AppColor.colorMedium, FontWeight.w500)
                    .merge(TextStyle(letterSpacing: 1)),
              ),
            ],
          )
          //Text("Appointment"),
          ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              Image.asset("assets/imgs/appointment.png",
                  width: 170, height: 170),
              SizedBox(height: 30),
              Text(
                "New Appointment",
                style: fontStyle(25, AppColor.colorDark, FontWeight.w800),
              ),
              Text(
                "Fill Detail To Book Appointment ",
                style: fontStyle(12, AppColor.colorMedium, FontWeight.w500)
                    .merge(TextStyle(letterSpacing: 1)),
              ),
              SizedBox(height: 30),
              Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.colorLight,
                  ),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Doctor Name",
                          style: fontStyle(
                              14, AppColor.colorDark, FontWeight.bold)),
                      DropdownButton(
                          isExpanded: true,
                          iconSize: 40,
                          iconEnabledColor: AppColor.colorGray,
                          hint: Text("Select doctor"),
                          value: doctorSelected,
                          items: doctorList
                              .map(
                                (e) => DropdownMenuItem(
                                  child: Text(e['u_name']),
                                  value: e['u_id'],
                                ),
                              )
                              .toList(),
                          onChanged: (e) => {
                                setState(() {
                                  doctorSelected = e;
                                })
                              }),
                    ],
                  )),
              inputBox(amount, "Amount [ if paid ]",
                  hint: "Enter paid Amount (Optional)",
                  icons: Icons.money_rounded,
                  type: TextInputType.number),
              textareaBox(desc, "Note about the patient",
                  icons: Icons.note_alt_outlined, maxLine: 4),
              SizedBox(height: 20),
              buttonCustom(
                "Book Appointment",
                bookAppointment,
                color: AppColor.colorRed,
                align: MainAxisAlignment.end,
                fontsize: 14,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

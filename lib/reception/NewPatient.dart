import 'dart:convert';

import 'package:awesome_dropdown/awesome_dropdown.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
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
import 'package:barcode/barcode.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

class NewPatient extends StatefulWidget {
  NewPatient({Key key}) : super(key: key);
  @override
  State<NewPatient> createState() => _NewPatientState();
}

class _NewPatientState extends State<NewPatient> {
  TextEditingController p_name,
      p_address,
      p_pincode,
      p_contact_primary,
      p_contact_secondary,
      p_email,
      p_barcode,
      p_desease,
      p_desc;
  String doctorSelected;
  var doctorList = [];
  HTTP http = HTTP();
  final DataController get = Get.put(DataController());

  @override
  void initState() {
    super.initState();
    p_name = TextEditingController();
    p_address = TextEditingController();
    p_pincode = TextEditingController();
    p_contact_primary = TextEditingController();
    p_contact_secondary = TextEditingController();
    p_email = TextEditingController();
    p_barcode = TextEditingController(
        text:
            "${get.userDetail['u_id']}:${get.userDetail['h_id']}:${DateTime.now().millisecondsSinceEpoch}");
    p_desease = TextEditingController();
    p_desc = TextEditingController();
    // ${get.userDetail['h_id']}
    http
        .getData("get.php?users/cat_id=1/h_id=1")
        .then((value) => {
              if (value['status'])
                setState(() {
                  doctorList = value['data'];
                })
            })
        .catchError((e) => {
              print(e),
            });
  }

  NewPatient() {
    if (p_name.text == "" ||
        p_address.text == "" ||
        p_pincode.text == "" ||
        p_contact_primary.text == "" ||
        p_contact_secondary.text == "" ||
        p_email.text == "" ||
        p_barcode.text == "" ||
        p_desease.text == "" ||
        p_desc.text == "" ||
        doctorSelected == null) {
      toast_(context,
          icon_: Icons.error_outline,
          msg: "Please fill all detail properly",
          title: "Patient Registration");
    } else {
      context.loaderOverlay.show();
      var tmp = {
        "p_name": p_name.text,
        "p_address": p_address.text,
        "p_pincode": p_pincode.text,
        "p_contact_primary": p_contact_primary.text,
        "p_contact_secondary": p_contact_secondary.text,
        "p_email_address": p_email.text,
        "p_disease": p_desease.text,
        "p_desc": p_desc.text,
        "bar_code": p_barcode.text,
        "h_id": get.userDetail['h_id'],
        "u_id": get.userDetail['u_id'],
        "d_id": doctorSelected
      };
      http
          .postData("manage_data.php?add_patient", tmp)
          .then((value) => {
                context.loaderOverlay.hide(),
                if (value['status'])
                  {
                    showDialog(
                        context: context,
                        barrierDismissible: false, 
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                            content: Container(
                              height: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/imgs/done.png",
                                    height: 150,
                                  ),
                                  SizedBox(height: 10),
                                  Text(p_name.text,
                                      style: fontStyle(16, AppColor.colorDark,
                                          FontWeight.bold)),
                                  Text("Registration successfull",
                                      style: fontStyle(12, AppColor.colorGray,
                                          FontWeight.w400)),
                                ],
                              ),
                            ),
                            actionsAlignment: MainAxisAlignment.center,
                            actions: [
                              TextButton(
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10)),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.green),
                                  ),
                                  onPressed: () => {Get.back(), Get.back()},
                                  child: Text(
                                    '     Ok      ',
                                    style: fontStyle(15, AppColor.colorLight,
                                        FontWeight.w900),
                                  )),
                            ],
                          );
                        })
                  }
                else
                  {
                    toast_(context,
                        icon_: Icons.error_outline_rounded,
                        msg: "Registration failed",
                        title: "Error"),
                  },
              })
          .catchError((e) => {
                context.loaderOverlay.hide(),
                print(e),
                toast_(context,
                    icon_: Icons.error_outline_rounded,
                    msg: "Server failed please try again",
                    title: "Server Failed"),
              });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.colorDark,
        title: Text("Registeration"),
        actions: [
          TextButton.icon(
              style: ButtonStyle(
                foregroundColor: MaterialStatePropertyAll(AppColor.colorMedium),
              ),
              label: Text("Scan"),
              onPressed: () async {
                String tmp = await FlutterBarcodeScanner.scanBarcode(
                    "#ff6666", "Cancel", false, ScanMode.DEFAULT);
                p_barcode.text = tmp;
              },
              icon: Icon(Icons.document_scanner_outlined))
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                "New Patient",
                style: fontStyle(25, AppColor.colorDark, FontWeight.w800),
              ),
              Text(
                "Fill Patient detail For Registration ",
                style: fontStyle(12, AppColor.colorMedium, FontWeight.w500)
                    .merge(TextStyle(letterSpacing: 1)),
              ),
              SizedBox(height: 20),

inputBox(p_name, "Patient Name",icons: Icons.person_outline, maxChar: 30,delay: 1),
inputBox(p_address, "Full address", icons: Icons.home_outlined,delay: 2),
inputBox(p_pincode, "Pincode",icons: Icons.add_location_outlined,type: TextInputType.number,maxChar: 6,delay: 3),
inputBox(p_contact_primary, "Mobile Number",icons: Icons.call_outlined,type: TextInputType.phone,maxChar: 10,prefix: "+91 ",delay: 4),
inputBox(p_contact_secondary,"Whatsapp Contact (optional & if another)",icons: Icons.whatsapp_rounded,maxChar: 10,type: TextInputType.phone,prefix: "+91 ",delay: 5),
inputBox(p_email, "Email address",icons: Icons.email_outlined,type: TextInputType.emailAddress,delay: 6),
inputBox(p_barcode, "Barcode",icons: Icons.document_scanner_outlined,delay: 7),
textareaBox(p_desease, "Disease title",icons: Icons.medical_information_outlined,delay: 8),


Container(
width: MediaQuery.of(context).size.width,
margin: EdgeInsets.only(top: 5, bottom: 5),
decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(10),
  color: AppColor.colorLight,
),
padding: EdgeInsets.all(10),
child: DropdownButton(
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
        })),
textareaBox(p_desc, "Description",
maxLine: 5, icons: Icons.note_alt_outlined),
SizedBox(height: 20),
buttonCustom(
"      Submit     ",
NewPatient,
color: AppColor.colorRed,
align: MainAxisAlignment.center,
),
SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

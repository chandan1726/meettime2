import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:meettime/common/constant.dart';
import 'package:meettime/common/customWidget.dart';
import 'package:meettime/common/http.dart';
import 'package:meettime/getx.dart';

class AllPatient extends StatefulWidget {
  AllPatient({Key key}) : super(key: key);
  @override
  State<AllPatient> createState() => _AllPatientState();
}

class _AllPatientState extends State<AllPatient> {
  TextEditingController searchCtrl = TextEditingController();
  var doctorList = [];
  HTTP http = HTTP();
  final DataController get = Get.put(DataController());
  bool loader = true;

  @override
  void initState() {
    super.initState();
    loader = true;
    http.getData("manage_data.php?get_patient_list_receipt=${get.userDetail['u_id']}")
    .then((value) => {
      if (value['status'])
        setState(() {
          loader = false;
          doctorList = value['data'];
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
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 249, 251, 251),
      appBar: AppBar(
        backgroundColor: AppColor.colorDark,
        title: Text("Patient List"),
        actions: [
          TextButton.icon(
              style: ButtonStyle(
                foregroundColor: MaterialStatePropertyAll(AppColor.colorMedium),
              ),
              label: Text(""),
              onPressed: () async {
                String tmp = await FlutterBarcodeScanner.scanBarcode(
                    "#ff6666", "Cancel", false, ScanMode.DEFAULT);
                if (tmp != "-1") setState(() => {searchCtrl.text = tmp});
              },
              icon: Icon(Icons.document_scanner_outlined, size: 25))
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: loader? Column(children: [1,2,3,2].map((ee)=> 
            FadeInUp(
              animate: true,
              duration:  Duration(milliseconds: 500+(ee*300)),
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColor.colorWhite,
                  boxShadow: [BoxShadow(color: AppColor.colorLight,blurRadius: 1,spreadRadius: 1)]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(10)),color: AppColor.colorLight),
                      child: Row(
                        children: [
                          skeleton(30, 30,margin: EdgeInsets.symmetric(horizontal: 0,vertical: 3)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              skeleton(10, 100,margin: EdgeInsets.symmetric(horizontal: 10,vertical: 3)),
                              skeleton(10, 60,margin: EdgeInsets.symmetric(horizontal: 10,vertical: 3))
                            ],
                          ),
                        ],
                      )
                    ),
                    skeleton(10, 100,margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10)),
                    skeleton(10, 160,margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5)),
                    skeleton(10, 80,margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10)),
                  ],
                ),
              )
            )).toList())
            // Center(child: CircularProgressIndicator())
            : doctorList.length == 0
                ? notFound()
                : SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColor.colorWhite,
                                boxShadow: [
                                  BoxShadow(
                                      color: AppColor.colorLight,
                                      blurRadius: 1,
                                      spreadRadius: 1)
                                ]),
                            child: TextFormField(
                                controller: searchCtrl,
                                onChanged: (value) => {
                                      if (value == "") {setState(() => {})}
                                    },
                                onEditingComplete: () => {
                                      FocusScope.of(context).unfocus(),
                                      setState(() => {}),
                                    },
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      onPressed: () => {
                                            setState(() => {}),
                                          },
                                      icon: Icon(Icons.search_rounded)),
                                  alignLabelWithHint: true,
                                  labelStyle: TextStyle(
                                    letterSpacing: 1,
                                    fontSize: 14,
                                    color: AppColor.colorDark,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  contentPadding: EdgeInsets.all(10),
                                  hintText: "Search here",
                                  hintStyle: TextStyle(
                                    color: AppColor.colorDark,
                                    fontSize: 13,
                                    letterSpacing: 1,
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                )),
                          ),
                          ...doctorList.map(
                            (e) => Visibility(
                              visible: (searchCtrl.text == null ||
                                  searchCtrl.text == "" ||
                                  e['p_name'].contains(searchCtrl.text) ||
                                  e['p_contact_primary']
                                      .contains(searchCtrl.text) ||
                                  e['bar_code'].contains(searchCtrl.text)),
                              child: GestureDetector(
                                onTap: () => {
                                  Get.toNamed("/PatientDetail", arguments: e),
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColor.colorWhite,
                                      boxShadow: [
                                        BoxShadow(
                                            color: AppColor.colorLight,
                                            blurRadius: 1,
                                            spreadRadius: 1)
                                      ]),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(10)),
                                          color: AppColor.colorLight,
                                        ),
                                        child: Row(
                                          children: [
                                            Text("${e['p_id']} : ",
                                                style: fontStyle(
                                                    14,
                                                    AppColor.colorMedium,
                                                    FontWeight.w900,
                                                    letterspacing: 1.2)),
                                            Text("${e['p_name']}",
                                                style: fontStyle(
                                                    14,
                                                    AppColor.colorDark,
                                                    FontWeight.w900,
                                                    letterspacing: 1.2)),
                                          ],
                                        ),
                                      ),
                                      singleRow("Address : ",
                                          "${e['p_address']} , ${e['p_pincode']}"),
                                      singleRow("Contact : ",
                                          "${e['p_contact_primary']}"),
                                      singleRow("Doctor  : ", e['u_name']),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),
                  ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_charts/flutter_charts.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:meettime/common/basic.dart';
import 'package:meettime/common/constant.dart';
import 'package:meettime/common/customWidget.dart';
import 'package:flutter_charts/flutter_charts.dart';
import 'package:meettime/common/http.dart';
import 'package:meettime/getx.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key}) : super(key: key);
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  HTTP http = HTTP();
  final DataController get = Get.put(DataController());
  Map<String, dynamic> allData = Get.arguments;
  bool loader = true;
  TextEditingController desc;

  loadData() {
    setState(() {
      loader = true;
    });
    http
        .getData("manage_data.php?info_appointment=${get.userDetail['u_id']}")
        .then((value) => {
              context.loaderOverlay.hide(),
              if (value['status'])
                setState(()=>{loader = false, get.info_appointment = value['data']})
              else
                setState(() => {loader = false})
            })
        .catchError((e) => {
              setState(() => {loader = false}),
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
    return SingleChildScrollView(
      child: Column(
        children: [
          getChart(),
          SizedBox(height: 20),
          FadeIn(
            animate: true,
            duration: const Duration(milliseconds: 900),
            child:Container(
              margin: EdgeInsets.all(10),
              alignment: Alignment.centerRight,
              height: 120,
              padding: EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                color: AppColor.colorMedium,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/imgs/recept_dashboard.jpg"),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    color: AppColor.colorMedium,
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Add New Patient Detail",
                    style: fontStyle(13, AppColor.colorWhite, FontWeight.w300),
                  ),
                  Text(
                    "Register Patient",
                    style: fontStyle(14, AppColor.colorLight, FontWeight.w900),
                  ),
                  SizedBox(height: 5),
                  GestureDetector(
                    onTap: () => {Get.toNamed("/NewPatient")},
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: AppColor.colorMedium,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        "Register",
                        style: fontStyle(9, AppColor.colorLight, FontWeight.w900),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          menuItem(Icons.wheelchair_pickup_outlined, "  Patients",
              () => {Get.toNamed("/AllPatient")}
              ,delay: 600),
          menuItem(Icons.punch_clock_rounded, "  Appointments",
              () => {Get.toNamed("/AllAppointments")},delay: 1000),
          menuItem(Icons.document_scanner_outlined, "  Scan file", () async {
            String tmp = await FlutterBarcodeScanner.scanBarcode(
                "#ff6666", "Cancel", false, ScanMode.DEFAULT);
            if (tmp != "-1") {
              context.loaderOverlay.show();
              http
                  .getData("manage_data.php?get_patient_scan_receipt=${tmp}")
                  .then((value) => {
                        context.loaderOverlay.hide(),
                        if (value['status'])
                          {
                            Get.toNamed("/PatientDetail",
                                arguments: value['data'][0])
                          }
                        else
                          {
                            toast_(context,
                                icon_: Icons.error_outline,
                                msg: "Barcode Does not matched",
                                title: "Failed")
                          }
                      })
                  .catchError((e) => {
                        context.loaderOverlay.hide(),
                        toast_(context,
                            icon_: Icons.error_outline,
                            msg: "Server Failed",
                            title: "Server Failed Try Again Later")
                      });
            } else {}
          },delay: 1000),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  menuItem(IconData icon, String title, Function function,{int delay=500}) {
    return FadeInUp(
      animate: true,
      duration:  Duration(milliseconds: delay),
      child: GestureDetector(
      onTap: function,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color.fromARGB(92, 215, 223, 216),
              width: 1,
            ),
          ),
        ),
        padding: EdgeInsets.only(bottom: 15),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColor.colorMedium,
              size: 30,
            ),
            Text(
              title,
              style: fontStyle(17, Colors.grey, FontWeight.w500),
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
    ));
  }

  getChart() {
    var titleColor = [
      {"title": "Pending", "color": Colors.blue},
      {"title": "Completed", "color": Colors.green},
      {"title": "Cancel", "color": Colors.red},
    ];
    List<double> Pending = [];
    List<double> Completed = [];
    List<double> Cancel = [];
    List<String> Labels = [];

    if (get.info_appointment.length != 0) {
      get.info_appointment.forEach((ele) {
        Pending.add(double.parse(ele['total_pending']));
        Completed.add(double.parse(ele['total_completed']));
        Cancel.add(double.parse(ele['total_cancel']));
        Labels.add(ele['at_date']);
      });
    } else {
      Pending = [0.0,1.0];
      Completed = [0.0,1.0]; 
      Cancel = [0.0,1.0];
      Labels = [".","."];
    }

    LabelLayoutStrategy xContainerLabelLayoutStrategy;
    ChartData chartData;
    ChartOptions chartOptions = const ChartOptions();
    // chartOptions = const ChartOptions.noLabels();
    chartOptions = const ChartOptions(
        dataContainerOptions: DataContainerOptions(
          gridLinesColor: Colors.transparent,
        ),
        labelCommonOptions: LabelCommonOptions(),
        legendOptions: LegendOptions(
          legendContainerMarginLR: 5,
          legendContainerMarginTB: 20,
        ));
    chartData = ChartData(
        dataRows: [
          Pending,
          Completed,
          Cancel,
        ],
        xUserLabels: Labels,
        // List<String>.generate(7, (index) => (index + 1).toString()).toList(),
        dataRowsLegends: const [
          'Pending',
          'Complete',
          'Cancel',
        ],
        chartOptions: chartOptions,
        dataRowsColors: const [Colors.blue, Colors.green, Colors.red]);
    var lineChartContainer = LineChartTopContainer(
      chartData: chartData,
      xContainerLabelLayoutStrategy: xContainerLabelLayoutStrategy,
    );
    return FadeInDown(
      animate: true,
      duration: const Duration(milliseconds: 500),
      child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColor.colorLight,
            boxShadow: [
              BoxShadow(
                color: AppColor.colorLight,
                blurRadius: 3,
                spreadRadius: 0,
              )
            ],
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          width: MediaQuery.of(context).size.width,
          height: 300,
          child: LineChart(
            painter: LineChartPainter(
              lineChartContainer: lineChartContainer,
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Appointment Weekly Report",
          style:
              fontStyle(14, Color.fromARGB(162, 134, 151, 143), FontWeight.w600)
                  .merge(TextStyle(letterSpacing: 1)),
        ),
      ],
    ));
  }
}

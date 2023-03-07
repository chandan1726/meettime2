import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meettime/common/constant.dart';
import 'package:meettime/common/customWidget.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        // margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/imgs/splash.jpeg"), fit: BoxFit.cover),
        ),
        child: Center(
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                height: 150,
                width: MediaQuery.of(context).size.width,
                // margin: EdgeInsets.all(10),
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 1,
                        spreadRadius: 2,
                        color: AppColor.colorLight,
                      )
                    ],
                    color: AppColor.colorWhite,
                    image: DecorationImage(
                        alignment: Alignment.centerRight,
                        image: NetworkImage(
                            "https://drdixitclinic.com/wp-content/uploads/2022/06/Hospital-bed.gif"))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome",
                      style: fontStyle(20, AppColor.colorRed, FontWeight.w900),
                    ),
                    Text(
                      "Chandan tiwari",
                      style: fontStyle(14, AppColor.colorDark, FontWeight.w400)
                          .merge(TextStyle(letterSpacing: 1)),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                      decoration: BoxDecoration(
                        color: AppColor.colorLight,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: GestureDetector(
                        onTap: () => {},
                        child: Text(
                          "View Profile",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: AppColor.colorMedium),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  roundButton(Colors.amber, () => {},
                      Icons.record_voice_over_outlined, "Call"),
                  roundButton(Colors.blue[100], () => {},
                      Icons.info_outline_rounded, "Detail"),
                  roundButton(Colors.grey[400], () => {},
                      Icons.list_alt_rounded, "List"),
                ],
              ),
              SizedBox(height: 30),
              Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                    color: AppColor.colorWhite,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[300],
                        blurRadius: 4,
                      )
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "SHIVAM MAURYA",
                      style:
                          fontStyle(14, AppColor.colorMedium, FontWeight.w900)
                              .merge(TextStyle(letterSpacing: 2)),
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          "Last Appointment : ",
                          style: fontStyle(
                              10, AppColor.colorDark, FontWeight.bold),
                        ),
                        Text(
                          "12 / 03 / 2022",
                          style: fontStyle(
                              10, AppColor.colorDark, FontWeight.w400),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Diagnosis Patient",
                      style: fontStyle(12, AppColor.colorDark, FontWeight.w400),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Note about the patient will be rendered here, defenetly",
                      style: fontStyle(
                        14,
                        AppColor.colorDark,
                        FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: AppColor.colorRed,
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(10)),
                      ),
                      child: GestureDetector(
                        onTap: () => {},
                        child: Text(
                          "Skip & Next",
                          style: fontStyle(
                              14, AppColor.colorLight, FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 2,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: AppColor.colorDark,
                        borderRadius:
                            BorderRadius.only(bottomRight: Radius.circular(10)),
                      ),
                      child: GestureDetector(
                        onTap: () => {},
                        child: Text(
                          "Complete & Next",
                          style: fontStyle(
                              14, AppColor.colorWhite, FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  roundButton(Color color, Function function, IconData icon, String text) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(50),
          ),
          child: GestureDetector(
            onTap: function,
            child: Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(
          text,
          style: fontStyle(12, AppColor.colorDark, FontWeight.w900),
        ),
      ],
    );
  }
}

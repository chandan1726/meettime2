import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:meettime/common/constant.dart';
import 'package:meettime/common/customWidget.dart';

startLoading(BuildContext context) {
  context.loaderOverlay.show();
}

stopLoading(BuildContext context) {
  context.loaderOverlay.hide();
}

Widget alert_(BuildContext context,
    {String title = "MEET TIME",
    String desc = "Are you sure ?",
    Function onNo,
    Function onYes,
    String noText = "No",
    String yesText = "Yes"}) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(title),
          content: Wrap(
            children: [Text(desc)],
          ),
          actionsAlignment: MainAxisAlignment.end,
          actions: [
            (onNo != null)
                ? TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5)),
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 215, 219, 211))),
                    onPressed: onNo,
                    child: Text(
                      '   ${noText}    ',
                      style: fontStyle(16, AppColor.colorDark, FontWeight.bold),
                    ))
                : Container(),
            TextButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 5, vertical: 5)),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor: MaterialStateProperty.all(Colors.green)),
                onPressed: onYes,
                child: Text(
                  '   ${yesText}    ',
                  style: fontStyle(15, AppColor.colorLight, FontWeight.w900),
                )),
          ],
        );
      });
}

toast_(
  BuildContext context, {
  String title,
  String msg,
  IconData icon_,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: 1),
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.all(20),  
      behavior: SnackBarBehavior.floating,
      elevation: 5,
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Icon(
                icon_ ?? Icons.done_all_rounded,
                size: 30,
              ),
            ),
            Expanded(
              child: ListTile(
                title: Text(
                  title ?? "MEET TIME",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(msg ?? "Success"),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

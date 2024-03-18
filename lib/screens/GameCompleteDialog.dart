import 'dart:ui';
import 'package:share/share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mind_maze/common/Common.dart';
import 'package:mind_maze/constants.dart';
import 'package:mind_maze/screens/GameModel.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../CustomDialoge.dart';

class GameCompleteDialog extends StatefulWidget {
  final void Function(String)? onRestartclick;
  final ShareData? data;
  GameModel gameModel;

  GameCompleteDialog({this.data, this.onRestartclick, required this.gameModel});

  @override
  State<GameCompleteDialog> createState() => _GameCompleteDialogState();
}

class _GameCompleteDialogState extends State<GameCompleteDialog> {
  GlobalKey<FormState> previewController = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        height: 370.h,
        width: MediaQuery.of(context).size.width - 50.w,
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
          color: bgColor,
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(5)),
              Center(
                child: Text("share".toUpperCase(), style: TextStyle(fontSize: 16.sp, color: litetxtColor)),
              ),
              Center(
                child: Text("Share your score...!", style: TextStyle(fontSize: 14.sp, color: black)),
              ),
              Padding(padding: EdgeInsets.all(5)),
              Container(
                alignment: Alignment.center,
                color: Colors.white,
                width: (MediaQuery.of(context).size.width / 1) - 100.w,
                child: RepaintBoundary(
                  key: previewController,
                  child: Container(
                    width: (MediaQuery.of(context).size.width / 1) - 110.w,
                    padding: EdgeInsets.all(10.0),
                    color: Colors.grey[300],
                    child: Column(
                      children: [
                        Padding(padding: EdgeInsets.all(3.0)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Container(
                                child: Image.asset('assets/images/app_icon.png', height: 35.w, width: 35.w),
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(5.0)),
                            GradientText(AppName, textAlign: TextAlign.center, style: TextStyle(color: Colors.blue, fontSize: 16.sp),
                              colors: const [
                                Colors.blue,
                                Colors.indigo
                              ],
                              gradientType: GradientType.linear,
                              gradientDirection: GradientDirection.ttb,
                            ),
                          ],
                        ),
                        Card(
                          margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
                          color: Colors.grey[100],
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Image.asset(widget.gameModel.Training_icon, height: 40.h, width: 40.h),
                                  ),
                                  Text(widget.gameModel.gameTitle, style: TextStyle(color: black, fontSize: 12.sp)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text("Incorrect", style: TextStyle(color: txtColor, fontSize: 10.sp)),
                                      Text(widget.data!.incorrect.toString(), style: TextStyle(color: txtColor, fontSize: 12.sp)),
                                    ],
                                  ),
                                  Padding(padding: EdgeInsets.all(5)),
                                  CircularPercentIndicator(
                                    radius: 40.r,
                                    lineWidth: 10.w,
                                    backgroundColor: txtColor,
                                    percent: widget.data!.percent!/100,
                                    center: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("Accuracy", textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 10.sp)),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text((widget.data!.percent!).toStringAsFixed(2), textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 12.sp)),
                                            Text("%", style: TextStyle(color: Colors.black, fontSize: 10.sp), textAlign: TextAlign.center),
                                          ],
                                        ),
                                      ],
                                    ),
                                    circularStrokeCap: CircularStrokeCap.round,
                                    progressColor: litetxtColor,
                                  ),
                                  Padding(padding: EdgeInsets.all(5)),
                                  Column(
                                    children: [
                                      Text("Correct", style: TextStyle(color: litetxtColor, fontSize: 10.sp)),
                                      Text(widget.data!.correct.toString(), style: TextStyle(color: litetxtColor, fontSize: 12.sp)),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(" Mean Time ", style: TextStyle(color: black, fontSize: 10.sp)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(widget.data!.time!.toStringAsFixed(2), style: TextStyle(color: black, fontSize: 12.sp)),
                                      Text("Seconds", style: TextStyle(color: black, fontSize: 12.sp)),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(padding: EdgeInsets.all(5)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(2)),
              InkWell(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                  RenderRepaintBoundary boundary = previewController.currentContext!.findRenderObject() as RenderRepaintBoundary;
                  saveScreenShot(boundary, success: (savedImageFile) {
                    print('save ok');
                    print(savedImageFile);
                    String message = "$share_msg";
                    if(playStoreUrl.isNotEmpty) {
                      message += ' For PlayStore:$playStoreUrl';
                    }
                    if(appStoreUrl.isNotEmpty) {
                      message += ' For AppStore:$appStoreUrl';
                    }
                    Share.shareFiles([savedImageFile!.path], text: message);
                  }, fail: () {
                    print('save fail!');
                  });
                  widget.onRestartclick!("yes");
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 30.h,
                  width: (MediaQuery.of(context).size.width / 2) - 25.w,
                  margin: EdgeInsets.only(left: 5.w, top: 5.h, bottom: 0, right: 0),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5),
                    color: litetxtColor,
                  ),
                  child: Text("share".toUpperCase(), style: TextStyle(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              Padding(padding: EdgeInsets.all(5)),
            ],
          ),
        ),
      ),
    );
  }
}

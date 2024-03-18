import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mind_maze/CustomDialoge.dart';
import 'package:mind_maze/common/Common.dart';
import 'package:mind_maze/constants.dart';
import 'package:mind_maze/screens/Play%20with%20frd/SizeConfig.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class CompleteDialogFrd extends StatefulWidget {
  final void Function(String)? onRestartclick;
  final ShareDataFrd? dataFrd;
  Board data1;

  CompleteDialogFrd({this.onRestartclick, this.dataFrd, required this.data1});

  @override
  State<CompleteDialogFrd> createState() => _CompleteDialogFrdState();
}

class _CompleteDialogFrdState extends State<CompleteDialogFrd> {
  GlobalKey<FormState> previewController = GlobalKey<FormState>();
  List<Board> data = [];
  bool isnodata = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.containsKey("ScoreBoardJson")) {
        String? str = prefs.getString("ScoreBoardJson");
        if(str != "") {
          var convertedjson = json.decode(str!);
          ScoreBoardJson sjson = ScoreBoardJson.fromJson(convertedjson);
          data = sjson.board.toList().reversed.toList();
        } else {
          isnodata = true;
        }
      } else {
        isnodata = true;
      }
    } on Exception catch (e) {
      print(e.toString());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        height: 385.h,
        width: MediaQuery.of(context).size.width - 50.w,
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
          color: Colors.white,
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(5)),
              Center(
                child: Text("share".toUpperCase(), style: TextStyle(fontSize: 16.sp, color: litetxtColor)),
              ),
              Center(
                child: Text("Share your score...!", style: TextStyle(fontSize: 14.sp, color: Colors.black)),
              ),
              Padding(padding: EdgeInsets.all(5)),
              Container(
                alignment: Alignment.center,
                color: Colors.white,
                width: (MediaQuery.of(context).size.width / 1) - 100.w,
                child: RepaintBoundary(
                  key: previewController,
                  child: Container(
                    width: (MediaQuery.of(context).size.width / 1) - 60.w,
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
                          margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                          color: Colors.grey[100],
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 10.h, bottom: 0, right: 5.h, left: 5.h),
                                child: Column(
                                  children: [
                                    Text((widget.data1.mode == "0" ? "Easy" : widget.data1.mode == "1" ? "Medium"
                                        : widget.data1.mode == "2" ? "Hard" : "Complex") + " - " + widget.data1.noofquestion!
                                        + " Question", style: TextStyle(color: litetxtColor, fontSize: 14.r)),
                                    SizedBox(width: 5.w),
                                    Text(widget.data1.datetime!, style: TextStyle(color: litetxtColor.withOpacity(0.7), fontSize: 12.r)),
                                  ],
                                ),
                              ),
                              Container(
                                height: 1.h,
                                width: SizeConfig.screenWidth - 50.w,
                                color: Colors.black,
                                margin: EdgeInsets.only(left: 5.h, top: 5.h, bottom: 5.h, right: 5.h),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(left: 0, right: 5.w, bottom: 0, top: 0),
                                              child: Container(
                                                height: 25.h,
                                                width: 25.w,
                                                child: Image.asset(widget.data1.player1emoji!, height: 20.h, width: 20.w, fit: BoxFit.contain),
                                              ),
                                            ),
                                            Text(widget.data1.player1name!, style: TextStyle(color: litetxtColor, fontWeight: FontWeight.w900, fontSize: 14.sp)),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 10.h),
                                          child: Text("Score: " + widget.data1.player1score!, style: TextStyle(color: litetxtColor, fontWeight: FontWeight.w900, fontSize: 14.sp)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 10.h),
                                          child: Text(int.parse(widget.data1.player1score!) > int.parse(widget.data1.player2score!)
                                              ? "Winner".toUpperCase() : int.parse(widget.data1.player1score!) == int.parse(widget.data1.player2score!)
                                              ? "It's Tie".toUpperCase() : "Losser".toUpperCase(),
                                            style: TextStyle(color: int.parse(widget.data1.player1score!) > int.parse(widget.data1.player2score!)
                                                ? Colors.green : int.parse(widget.data1.player1score!) == int.parse(widget.data1.player2score!)
                                                ? Color(0xFF5B5B5B) : Colors.red, fontWeight: FontWeight.w900, fontSize: 16.sp)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 1,
                                    color: Colors.black,
                                    height: 80.h,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(left: 0, right: 5.w, bottom: 0, top: 0),
                                              child: Container(
                                                height: 25.h,
                                                width: 25.w,
                                                child: Image.asset(widget.data1.player2emoji!, height: 25.h, width: 25.w, fit: BoxFit.contain),
                                              ),
                                            ),
                                            Text(widget.data1.player2name!, style: TextStyle(color: litetxtColor, fontWeight: FontWeight.w900, fontSize: 14.sp)),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 10.h),
                                          child: Text("Score: " + widget.data1.player2score!, style: TextStyle(color: litetxtColor, fontWeight: FontWeight.w900, fontSize: 14.sp)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 10.h),
                                          child: Text(int.parse(widget.data1.player2score!) > int.parse(widget.data1.player1score!)
                                              ? "Winner".toUpperCase() : int.parse(widget.data1.player1score!) == int.parse(widget.data1.player2score!)
                                              ? "It's Tie".toUpperCase() : "Losser".toUpperCase(),
                                            style: TextStyle(color: int.parse(widget.data1.player2score!) > int.parse(widget.data1.player1score!)
                                                ? Colors.green : int.parse(widget.data1.player1score!) == int.parse(widget.data1.player2score!)
                                                ? Color(0xFF5B5B5B) : Colors.red, fontWeight: FontWeight.w900, fontSize: 14.sp)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(top: 10.w)),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(" Mean Time ", style: TextStyle(color: black, fontSize: 10.sp)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(widget.dataFrd!.time!.toStringAsFixed(2), style: TextStyle(color: black, fontSize: 12.sp)),
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

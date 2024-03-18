import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mind_maze/common/Common.dart';
import 'package:mind_maze/constants.dart';
import 'package:mind_maze/screens/Play%20with%20frd/EmojiDialog.dart';
import 'package:mind_maze/screens/Play%20with%20frd/LevelPage.dart';
import 'package:mind_maze/screens/Play%20with%20frd/PlayScreen.dart';
import 'package:mind_maze/screens/Play%20with%20frd/ScoreBoardFrd.dart';
import 'package:mind_maze/screens/Play%20with%20frd/SizeConfig.dart';
import '../../common/ClsSound.dart';

class PlayerSetting extends StatefulWidget {
  final GameInfo? gameInfo;

  const PlayerSetting({Key? key, this.gameInfo}) : super(key: key);

  @override
  State<PlayerSetting> createState() => _PlayerSettingState();
}

class _PlayerSettingState extends State<PlayerSetting> {
  String txtQue = "10";
  TextEditingController txtp1 = TextEditingController(text: "Player 1");
  TextEditingController txtp2 = TextEditingController(text: "Player 2");

  String p1emoji = "assets/e1.png", p2emoji = "assets/e2.png";

  String? emoji;
  List<String> emojiList = [
    "assets/e1.png",
    "assets/e2.png",
    "assets/e3.png",
    "assets/e4.png",
    "assets/e5.png",
    "assets/e6.png",
    "assets/e7.png",
    "assets/e8.png",
    "assets/e9.png",
    "assets/e10.png",
    "assets/e11.png",
    "assets/e12.png",
    "assets/e13.png",
    "assets/e14.png",
    "assets/e15.png"
  ];

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return backButton(context);
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Image.asset('assets/images/app_logo.png', height: 50.h, width: 50.w, fit: BoxFit.fill),
          leading: Container(
            margin: EdgeInsets.all(5.0),
            child: Bounce(
              duration: Duration(milliseconds: 200),
              onPressed: () {
                ClsSound.playSound(SOUNDTYPE.Tap);
                Navigator.push(context, MaterialPageRoute(builder: (context) => LevelPage()));
              },
              child: Icon(Icons.arrow_back_ios, size: 20.h, color: primaryColor),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                ClsSound.playSound(SOUNDTYPE.Tap);
                Navigator.push(context, MaterialPageRoute(builder: (context) => ScoreBoardFrd()));
              },
              child: Padding(
                padding: EdgeInsets.only(right: 10.r),
                child: Center(
                  child: Image.asset("assets/images/brain.png", fit: BoxFit.fill, height: 35.r, width: 35.r),
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Image.asset(commonBg, height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width, fit: BoxFit.fill),
            Center(
              child: Container(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 600.r,
                        width: 350.r,
                        padding: EdgeInsets.all(10.r),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 490.r,
                                padding: EdgeInsets.symmetric(horizontal: 20.r),
                                decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/Game/rect.png"), fit: BoxFit.fill)),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text("No Of Questions".toUpperCase(),
                                          style: TextStyle(fontSize: 20.sp, color: txtColor.withOpacity(0.8), fontWeight: FontWeight.bold)),
                                      ),
                                      Padding(padding: EdgeInsets.all(5.r)),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Bounce(
                                            duration: Duration(milliseconds: 200),
                                            onPressed: () {
                                              setState(() {
                                                ClsSound.playSound(SOUNDTYPE.Tap);
                                                txtQue = "10";
                                              });
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 15.w),
                                              width: 55.w,
                                              height: 60.h,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                color: txtQue == "10" ? Colors.greenAccent.shade200 : Colors.green.shade50.withOpacity(0.6),
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                              ),
                                              child: Center(
                                                child: Text("10", textAlign: TextAlign.center,
                                                    style: TextStyle(color: txtQue == "10" ? Colors.black : Colors.black.withOpacity(0.6),
                                                        fontSize: 18.sp, fontWeight: FontWeight.bold)),
                                              ),
                                            ),
                                          ),
                                          Bounce(
                                            duration: Duration(milliseconds: 200),
                                            onPressed: () {
                                              setState(() {
                                                ClsSound.playSound(SOUNDTYPE.Tap);
                                                txtQue = "20";
                                              });
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 15.w),
                                              width: 55.w,
                                              height: 60.h,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                color: txtQue == "20" ? Colors.red.shade300 : Colors.red.shade100.withOpacity(0.6),
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                              ),
                                              child: Center(
                                                child: Text("20", textAlign: TextAlign.center,
                                                    style: TextStyle(color: txtQue == "20" ? Colors.black : Colors.black.withOpacity(0.6),
                                                        fontSize: 18.sp, fontWeight: FontWeight.bold)),
                                              ),
                                            ),
                                          ),
                                          Bounce(
                                            duration: Duration(milliseconds: 200),
                                            onPressed: () {
                                              ClsSound.playSound(SOUNDTYPE.Tap);
                                              setState(() {
                                                txtQue = "40";
                                              });
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 15.w),
                                              width: 55.w,
                                              height: 60.h,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                color: txtQue == "40" ? Colors.blue.shade300 : Colors.blue.shade50.withOpacity(0.6),
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                              ),
                                              child: Center(
                                                child: Text("40", textAlign: TextAlign.center,
                                                    style: TextStyle(color: txtQue == "40" ? Colors.black : Colors.black.withOpacity(0.6),
                                                        fontSize: 18.sp, fontWeight: FontWeight.bold)),
                                              ),
                                            ),
                                          ),
                                          Bounce(
                                            duration: Duration(milliseconds: 200),
                                            onPressed: () {
                                              setState(() {
                                                ClsSound.playSound(SOUNDTYPE.Tap);
                                                txtQue = "80";
                                              });
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 15.w),
                                              width: 55.w,
                                              height: 60.h,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                color: txtQue == "80" ? Colors.deepPurpleAccent.shade100 : Colors.purple.shade100.withOpacity(0.6),
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                              ),
                                              child: Center(
                                                child: Text("80", textAlign: TextAlign.center,
                                                    style: TextStyle(color: txtQue == "80" ? Colors.black : Colors.black.withOpacity(0.6),
                                                        fontSize: 18.sp, fontWeight: FontWeight.bold)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 20.h, bottom: 0, left: 15.r, right: 0),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text("Player 1 Name".toUpperCase(), style: TextStyle(fontSize: 18.sp, color: Color(0xFFffffff), fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 5.w, top: 5, bottom: 0, right: 0),
                                            child: Bounce(
                                              duration: Duration(milliseconds: 200),
                                              onPressed: () {
                                                ClsSound.playSound(SOUNDTYPE.Tap);
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (_) => EmojiDialog(
                                                    selectedemoji: p1emoji,
                                                    onEmojiSelected: (value) {
                                                      setState(() {
                                                        if(value != null && value != "") {
                                                          p1emoji = value;
                                                        }
                                                      });
                                                    },
                                                  ),
                                                );
                                              },
                                              child: Image.asset(p1emoji, height: 50.h, width: 50.w, fit: BoxFit.contain),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(left: 10.w, top: 10, bottom: 0, right: 10.w),
                                            height: 60.h,
                                            width: SizeConfig.screenWidth - 190.w,
                                            decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/bg_set.png"), fit: BoxFit.fill)),
                                            child: TextField(
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 22.sp, color: Colors.white, fontWeight: FontWeight.bold),
                                              maxLines: 1,
                                              keyboardType: TextInputType.text,
                                              controller: txtp1,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                helperStyle: TextStyle(fontSize: 10.sp, color: Colors.transparent, fontWeight: FontWeight.bold),
                                                contentPadding: EdgeInsets.only(left: 10, top: 0.h, bottom: 0, right: 10),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 15.r, top: 20.h, bottom: 0, right: 0),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text("Player 2 Name".toUpperCase(), style: TextStyle(fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 5.w, top: 15.h, bottom: 0, right: 0),
                                            child: Bounce(
                                              duration: Duration(milliseconds: 200),
                                              onPressed: () {
                                                ClsSound.playSound(SOUNDTYPE.Tap);
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (_) => EmojiDialog(
                                                    selectedemoji: p2emoji,
                                                    onEmojiSelected: (value) {
                                                      setState(() {
                                                        if(value != null && value != "") {
                                                          p2emoji = value;
                                                        }
                                                      });
                                                    },
                                                  ),
                                                );
                                              },
                                              child: Image.asset(p2emoji, height: 50.h, width: 50.w, fit: BoxFit.contain),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(left: 10.w, top: 10.h, bottom: 0, right: 10.w),
                                            height: 70.h,
                                            width: SizeConfig.screenWidth - 190.w,
                                            decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/bg_set.png"), fit: BoxFit.fill)),
                                            child: TextField(
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 22.sp, color: Colors.white, fontWeight: FontWeight.bold),
                                              maxLines: 1,
                                              keyboardType: TextInputType.text,
                                              controller: txtp2,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                helperStyle: TextStyle(fontSize: 10.sp, color: Colors.transparent, fontWeight: FontWeight.bold),
                                                contentPadding: EdgeInsets.only(left: 10, top: 0.h, bottom: 0, right: 10),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 50.r),
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Image.asset("assets/Game/tip_icon.png", fit: BoxFit.fill, height: 90.r, width: 90.r),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Image.asset("assets/Game/tip_brain.png", fit: BoxFit.fill, height: 60.r, width: 80.r),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5.r),
                        child: InkWell(
                          onTap: () {
                            ClsSound.playSound(SOUNDTYPE.Tap);
                            if(txtQue.isEmpty) {
                              _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text("No of Questions is 0.")));
                            } else if(txtp1.text == "") {
                              _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text("Player 1 Name is Empty!")));
                            } else if(txtp2.text == "") {
                              _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text("Player 2 Name is Empty!")));
                            } else {
                              GameInfo gf = GameInfo(player1Name: txtp1.text.toString(), player2Name: txtp2.text.toString(), p1Emoji: p1emoji, p2Emoji: p2emoji, p1Score: "", p2Score: "", levelMode: widget.gameInfo!.levelMode, noofquestion: txtQue.toString(), operation: widget.gameInfo!.operation);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => PlayScreen(gameInfo: gf)));
                            }
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Text("TAP TO START !", style: TextStyle(fontSize: 25.r, color: txtColor.withOpacity(0.8))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

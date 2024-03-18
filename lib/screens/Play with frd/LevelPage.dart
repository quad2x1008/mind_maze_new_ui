import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mind_maze/common/Common.dart';
import 'package:mind_maze/constants.dart';
import '../../common/ClsSound.dart';
import '../HomePage.dart';
import 'PlayerSetting.dart';
import 'SizeConfig.dart';

class LevelPage extends StatefulWidget {
  final GameInfo? gameInfo;

  LevelPage({Key? key, this.gameInfo}) : super(key: key);

  @override
  State<LevelPage> createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> {
  int? selectedlevel = 0;
  bool add = true, divi = true, mult = true, sub = true;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.gameInfo != null) {
      selectedlevel = widget.gameInfo!.levelMode;
      if (widget.gameInfo!.operation!.contains("0"))
        add = true;
      else
        add = false;
      if (widget.gameInfo!.operation!.contains("1"))
        sub = true;
      else
        sub = false;
      if (widget.gameInfo!.operation!.contains("2"))
        mult = true;
      else
        mult = false;
      if (widget.gameInfo!.operation!.contains("3"))
        divi = true;
      else
        divi = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.screenHeight = MediaQuery.of(context).size.height;
    SizeConfig.screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        return backButton(context);
      },
      child: Scaffold(
        key: _scaffoldKey,
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: Icon(Icons.arrow_back_ios, size: 20.h, color: primaryColor),
            ),
          ),
        ),
        body: Stack(
          children: [
            Image.asset(commonBg, height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width, fit: BoxFit.fill),
            Center(
              child: Column(
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
                            // margin: EdgeInsets.only(top: 70.r),
                            decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/Game/rect.png"), fit: BoxFit.fill)),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 3.r),
                                  Bounce(
                                    duration: Duration(milliseconds: 200),
                                    onPressed: () {
                                      ClsSound.playSound(SOUNDTYPE.Tap);
                                      setState(() {
                                        selectedlevel = 0;
                                      });
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: Image.asset("assets/bgText.png",
                                            height: SizeConfig.screenHeight * 0.10,
                                            width: SizeConfig.screenWidth * 0.50,
                                            fit: BoxFit.fill,
                                            color: selectedlevel == 0 ? Colors.greenAccent.shade200 : Colors.green.shade50.withOpacity(0.6),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text("Easy".toUpperCase(),
                                            style: TextStyle(fontSize: 20.sp, color: selectedlevel == 0 ? Colors.black : Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 0, top: 10, bottom: 0, right: 0),
                                    child: Bounce(
                                      duration: Duration(milliseconds: 200),
                                      onPressed: () {
                                        ClsSound.playSound(SOUNDTYPE.Tap);
                                        setState(() {
                                          selectedlevel = 1;
                                        });
                                      },
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Align(
                                            alignment: Alignment.center,
                                            child: Image.asset("assets/bgText.png",
                                              color: selectedlevel == 1 ? Colors.red.shade300 : Colors.red.shade100.withOpacity(0.6),
                                              height: SizeConfig.screenHeight * 0.10,
                                              width: SizeConfig.screenWidth * 0.50,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Text("Medium".toUpperCase(),
                                              style: TextStyle(fontSize: 20.sp, color: selectedlevel == 1 ? Colors.black : Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 0, top: 10, bottom: 0, right: 0),
                                    child: Bounce(
                                      duration: Duration(milliseconds: 200),
                                      onPressed: () {
                                        ClsSound.playSound(SOUNDTYPE.Tap);
                                        setState(() {
                                          selectedlevel = 2;
                                        });
                                      },
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Align(
                                            alignment: Alignment.center,
                                            child: Image.asset("assets/bgText.png",
                                              color: selectedlevel == 2 ? Colors.blue.shade300 : Colors.blue.shade50.withOpacity(0.6),
                                              height: SizeConfig.screenHeight * 0.10,
                                              width: SizeConfig.screenWidth! * 0.50,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Text("Hard".toUpperCase(),
                                              style: TextStyle(fontSize: 20.sp, color: selectedlevel == 2 ? Colors.black : Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 0, top: 10, bottom: 10, right: 0),
                                    child: Bounce(
                                      duration: Duration(milliseconds: 200),
                                      onPressed: () {
                                        ClsSound.playSound(SOUNDTYPE.Tap);
                                        setState(() {
                                          selectedlevel = 3;
                                        });
                                      },
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Align(
                                            alignment: Alignment.center,
                                            child: Image.asset("assets/bgText.png",
                                              color: selectedlevel == 3 ? Colors.deepPurpleAccent.shade100 : Colors.purple.shade100.withOpacity(0.6),
                                              height: SizeConfig.screenHeight * 0.10,
                                              width: SizeConfig.screenWidth * 0.50,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Text("Complex".toUpperCase(),
                                              style: TextStyle(fontSize: 20.sp, color: selectedlevel == 3 ? Colors.black : Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Bounce(
                                        duration: Duration(milliseconds: 200),
                                        onPressed: () {
                                          ClsSound.playSound(SOUNDTYPE.Tap);
                                          setState(() {
                                            add = !add;
                                          });
                                        },
                                        child: Container(
                                          width: SizeConfig.screenWidth / 7,
                                          height: SizeConfig.screenWidth / 6.5,
                                          decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.fill, image: AssetImage(add ? "assets/sum.png" : "assets/sum_un.png"))),
                                        ),
                                      ),
                                      Bounce(
                                        duration: Duration(milliseconds: 200),
                                        onPressed: () {
                                          ClsSound.playSound(SOUNDTYPE.Tap);
                                          setState(() {
                                            sub = !sub;
                                          });
                                        },
                                        child: Container(
                                          width: SizeConfig.screenWidth / 7,
                                          height: SizeConfig.screenWidth / 6.5,
                                          margin: EdgeInsets.only(left: 5, top: 0, bottom: 0, right: 0),
                                          decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.fill, image: AssetImage(sub ? "assets/sub.png" : "assets/sub_un.png"))),
                                        ),
                                      ),
                                      Bounce(
                                        duration: Duration(milliseconds: 200),
                                        onPressed: () {
                                          ClsSound.playSound(SOUNDTYPE.Tap);
                                          setState(() {
                                            mult = !mult;
                                          });
                                        },
                                        child: Container(
                                          width: SizeConfig.screenWidth / 7,
                                          height: SizeConfig.screenWidth / 6.5,
                                          margin: EdgeInsets.only(left: 5, top: 0, bottom: 0, right: 0),
                                          decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.fill, image: AssetImage(mult ? "assets/mul.png" : "assets/mul_un.png"))),
                                        ),
                                      ),
                                      Bounce(
                                        duration: Duration(milliseconds: 200),
                                        onPressed: () {
                                          ClsSound.playSound(SOUNDTYPE.Tap);
                                          setState(() {
                                            divi = !divi;
                                          });
                                        },
                                        child: Container(
                                          width: SizeConfig.screenWidth / 7,
                                          height: SizeConfig.screenWidth / 6.5,
                                          margin: EdgeInsets.only(left: 5, top: 0, bottom: 0, right: 0),
                                          decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.fill, image: AssetImage(divi ? "assets/div.png" : "assets/div_un.png"))),
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
                        String op = "";
                        if (add) op = op + "0,";
                        if (sub) op = op + "1,";
                        if (mult) op = op + "2,";
                        if (divi) op = op + "3,";

                        if (op == "") {
                          _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text("Math Operation not Selected.")));
                        } else {
                          GameInfo gi = GameInfo(levelMode: selectedlevel, operation: op);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerSetting(gameInfo: gi))).then((_) {
                            setState(() {});
                          });
                        }
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Text("NEXT", style: TextStyle(fontSize: 25.r, color: txtColor.withOpacity(0.8))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

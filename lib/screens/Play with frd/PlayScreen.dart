import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:mind_maze/screens/HomePage.dart';
import 'package:mind_maze/screens/Play%20with%20frd/LevelPage.dart';
import 'package:quiver/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../../common/ClsSound.dart';
import '../../common/Common.dart';
import '../../constants.dart';
import 'package:intl/intl.dart';
import '../TimerTitle.dart';
import '../game_operations/LiveScorePoint.dart';
import 'ResultPageFrd.dart';
import 'SizeConfig.dart';

class PlayScreen extends StatefulWidget {
  GameInfo gameInfo;

  PlayScreen({Key? key, required this.gameInfo}) : super(key: key);

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class Question {
  String? question, answer;
  List<String>? options;
  bool? isDone;

  Question({this.question, this.answer, this.options, this.isDone});
}

class _PlayScreenState extends State<PlayScreen> with SingleTickerProviderStateMixin {
  List<Question> queList = [];
  int noOfQuestions = 10;
  int currentQuestionIndex = 0;
  int? complexity = 0;
  int p1Score = 0, p2Score = 0;
  bool isAnimation = false;

  bool isplay = true, isGameOver = false, isrestart = true;
  int winner = 0;
  bool isWrong = true;

  Color op1 = Colors.indigo.shade900, op2 = Colors.indigo.shade900, op3 = Colors.indigo.shade900, op4 = Colors.indigo.shade900, op5 = Colors.indigo.shade900, op6 = Colors.indigo.shade900;

  @override
  void initState() {
    super.initState();
    setQuestions();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationController.repeat(reverse: true);
  }

  CountdownTimer? countDownTimer;
  late AnimationController _animationController;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double ansboxH = ((SizeConfig.screenHeight - 80) / 2) * 0.20;
    double ansboxW = ((SizeConfig.screenWidth - 150) / 3);
    double quesHeight = ((SizeConfig.screenHeight - 100) / 2) * 0.60;
    double quesWidth = (SizeConfig.screenWidth - 30);

    return WillPopScope(
      onWillPop: () {
        ClsSound.playSound(SOUNDTYPE.Tap);
        countDownTimer?.cancel();
        ClsSound.stopTikTik();
        _animationController.stop();
        return backButton(context);
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: box_decoration,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            actions: [
              LiveScorePoint(correct1 + correct2, incorrect1 + incorrect2, _current, widget.gameInfo!.playTimeSec),
            ],
            title: TimerTitle(_current),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(
              child: InkWell(
                onTap: () {
                  ClsSound.playSound(SOUNDTYPE.Tap);
                  countDownTimer?.cancel();
                  ClsSound.stopTikTik();
                  _animationController.dispose();
                  backButton(context);
                },
                child: Icon(Icons.chevron_left, size: 30.r, color: primaryColor),
              ),
            ),
          ),
          body: queList.length > 0 ? Stack(
            children: [
              Visibility(
                visible: !isWrong,
                child: Stack(
                  children: [
                    Container(
                      width: 35.w,
                      alignment: Alignment.topLeft,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [red75, red60, red45, red30, red15, Colors.transparent],
                          begin: Alignment.topLeft,
                          end: Alignment.topRight,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 35.w,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [red75, red60, red45, red30, red15, Colors.transparent],
                            begin: Alignment.topRight,
                            end: Alignment.topLeft,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 35.h,
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [red75, red60, red45, red30, red15, Colors.transparent],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 35.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [red75, red60, red45, red30, red15, Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: isAnimation,
                child: FadeTransition(
                  opacity: _animationController,
                  child: Container(
                    height: 80.0,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [red75, red60, red45, red30, red15, Colors.transparent],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter
                      ),
                    ),
                  ),
                ),
              ),
              isrestart ? Column(
                children: [
                  RotatedBox(
                    quarterTurns: 2,
                    child: Container(
                      height: (SizeConfig.screenHeight / 2) - 100,
                      width: SizeConfig.screenWidth,
                      alignment: Alignment.center,
                      child: DefaultTextStyle(
                        style: TextStyle(fontSize: 70.sp, color: Colors.white),
                        child: AnimatedTextKit(
                          isRepeatingAnimation: false,
                          onFinished: () {
                            setState(() {
                              isrestart = false;
                              startTime();
                            });
                          },
                          animatedTexts: [
                            ScaleAnimatedText('3'),
                            ScaleAnimatedText('2'),
                            ScaleAnimatedText('1'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: SizeConfig.screenWidth,
                    height: 40,
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset("assets/centerline.png", height: 5, width: SizeConfig.screenWidth, fit: BoxFit.fitWidth),
                        Bounce(
                          duration: Duration(milliseconds: 200),
                          onPressed: () {
                            ClsSound.playSound(SOUNDTYPE.Tap);
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            child: Image.asset("assets/ic_play.png", height: 40, width: 40, fit: BoxFit.contain),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: (SizeConfig.screenHeight / 2) - 100,
                    width: SizeConfig.screenWidth,
                    alignment: Alignment.center,
                    child: DefaultTextStyle(
                      style: TextStyle(fontSize: 70.0.sp, color: Colors.white),
                      child: AnimatedTextKit(
                        isRepeatingAnimation: false,
                        onFinished: () {
                          setState(() {
                            isrestart = false;
                            startTime();
                          });
                        },
                        animatedTexts: [
                          ScaleAnimatedText('3'),
                          ScaleAnimatedText('2'),
                          ScaleAnimatedText('1'),
                        ],
                      ),
                    ),
                  ),
                ],
              )
                  : Column(
                children: [
                  Container(
                    width: SizeConfig.screenWidth.w,
                    height: (SizeConfig.screenHeight - 140.h) / 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Bounce(
                                duration: Duration(milliseconds: 200),
                                onPressed: () {
                                  if (queList[currentQuestionIndex].options![0] != queList[currentQuestionIndex].answer) {
                                    setState(() {
                                      op1 = Colors.red;
                                      ClsSound.playSound(SOUNDTYPE.Wrong);
                                      print("==> correct ${incorrect1++}");
                                      isWrong = false;
                                      Vibration.vibrate(duration: 300);
                                      if (p1Score - 1 >= 0) {
                                        p1Score--;
                                      }
                                    });
                                    Future.delayed(200.ms, () {
                                      isWrong = !isWrong;
                                      setState(() {});
                                    });

                                    Timer _timer2 = Timer.periodic(Duration(milliseconds: 200), (value) {
                                      print("...timer");
                                      setState(() {
                                        op1 = Colors.indigo.shade900;
                                      });
                                      value.cancel();
                                    });
                                  } else {
                                    setState(() {
                                      ClsSound.playSound(SOUNDTYPE.Correct);
                                      print("==> correct ${correct1++}");
                                      op1 = Colors.green;
                                      p1Score++;
                                    });

                                    Timer _timer2 = Timer.periodic(Duration(milliseconds: 200), (value) {
                                      print("...timer");
                                      setState(() {
                                        op1 = Colors.indigo.shade900;
                                      });
                                      value.cancel();
                                      onOptionSelected(queList[currentQuestionIndex].options![0]);
                                    });
                                  }
                                },
                                child: Container(
                                  width: ansboxW,
                                  height: ansboxH,
                                  margin: EdgeInsets.only(left: 0, right: 0, bottom: 5, top: 10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: Colors.greenAccent.shade200,
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  alignment: Alignment.center,
                                  child: RotatedBox(
                                    quarterTurns: 2,
                                    child: Text((winner == 1 || winner == 2 || winner == 3) ? "" : queList[currentQuestionIndex].options![0],
                                      style: TextStyle(color: op1, fontWeight: FontWeight.w900, fontSize: 28.sp),
                                    ),
                                  ),
                                ),
                              ),
                              Bounce(
                                duration: Duration(milliseconds: 200),
                                onPressed: () {
                                  if (queList[currentQuestionIndex].options![1] != queList[currentQuestionIndex].answer) {
                                    setState(() {
                                      ClsSound.playSound(SOUNDTYPE.Wrong);
                                      print("==> correct ${incorrect1++}");
                                      isWrong = false;
                                      Vibration.vibrate(duration: 300);
                                      op2 = Colors.red;
                                      if (p1Score - 1 >= 0) {
                                        p1Score--;
                                      }
                                    });
                                    Future.delayed(200.ms, () {
                                      isWrong = !isWrong;
                                      setState(() {});
                                    });

                                    Timer _timer2 = Timer.periodic(Duration(milliseconds: 200), (value) {
                                      print("...timer");
                                      setState(() {
                                        op2 = Colors.indigo.shade900;
                                      });
                                      value.cancel();
                                    });
                                  } else {
                                    setState(() {
                                      ClsSound.playSound(SOUNDTYPE.Correct);
                                      print("==> correct ${correct1++}");
                                      op2 = Colors.green;
                                      p1Score++;
                                    });

                                    Timer _timer2 = Timer.periodic(Duration(milliseconds: 200), (value) {
                                      print("...timer");
                                      setState(() {
                                        op2 = Colors.indigo.shade900;
                                      });
                                      value.cancel();
                                      onOptionSelected(queList[currentQuestionIndex].options![1]);
                                    });
                                  }
                                },
                                child: Container(
                                  width: ansboxW,
                                  height: ansboxH,
                                  margin: EdgeInsets.only(left: 0, right: 0, bottom: 5, top: 5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: Colors.red.shade300,
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  alignment: Alignment.center,
                                  child: RotatedBox(
                                    quarterTurns: 2,
                                    child: Text((winner == 1 || winner == 2 || winner == 3) ? "" : queList[currentQuestionIndex].options![1],
                                      style: TextStyle(color: op2, fontWeight: FontWeight.w900, fontSize: 28.sp),
                                    ),
                                  ),
                                ),
                              ),
                              Bounce(
                                duration: Duration(milliseconds: 200),
                                onPressed: () {
                                  if (queList[currentQuestionIndex].options![2] != queList[currentQuestionIndex].answer) {
                                    setState(() {
                                      ClsSound.playSound(SOUNDTYPE.Wrong);
                                      print("==> correct ${incorrect1++}");
                                      isWrong = false;
                                      Vibration.vibrate(duration: 300);
                                      op3 = Colors.red;
                                      if (p1Score - 1 >= 0) {
                                        p1Score--;
                                      }
                                    });
                                    Future.delayed(200.ms, () {
                                      isWrong = !isWrong;
                                      setState(() {});
                                    });

                                    Timer _timer2 = Timer.periodic(Duration(milliseconds: 200), (value) {
                                      print("...timer");
                                      setState(() {
                                        op3 = Colors.indigo.shade900;
                                      });
                                      value.cancel();
                                    });
                                  } else {
                                    setState(() {
                                      ClsSound.playSound(SOUNDTYPE.Correct);
                                      print("==> correct ${correct1++}");
                                      op3 = Colors.green;
                                      p1Score++;
                                    });

                                    Timer _timer2 = Timer.periodic(Duration(milliseconds: 200), (value) {
                                      print("...timer");
                                      setState(() {
                                        op3 = Colors.indigo.shade900;
                                      });
                                      value.cancel();
                                      onOptionSelected(queList[currentQuestionIndex].options![2]);
                                    });
                                  }
                                },
                                child: Container(
                                  width: ansboxW,
                                  height: ansboxH,
                                  margin: EdgeInsets.only(left: 0, right: 0, bottom: 5, top: 5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: Colors.yellow.shade400,
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  alignment: Alignment.center,
                                  child: RotatedBox(
                                    quarterTurns: 2,
                                    child: Text((winner == 1 || winner == 2 || winner == 3) ? "" : queList[currentQuestionIndex].options![2],
                                      style: TextStyle(color: op3, fontWeight: FontWeight.w900, fontSize: 28.sp),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 0, top: 0),
                          child: Container(
                            width: quesWidth,
                            height: (quesHeight - 65.h),
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 0, top: 5.h),
                            decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.fill, image: AssetImage("assets/que_board.png"))),
                            child: RotatedBox(
                              quarterTurns: 2,
                              child: Text((winner == 1) ? "Winner" : (winner == 2) ? "Losser" : (winner == 3) ? "It's Tie" : queList[currentQuestionIndex].question!,
                                style: TextStyle(color: (winner == 1) ? Colors.green : (winner == 2) ? Colors.red : (winner == 3) ? Color(0xFF5B5B5B) : Colors.white,
                                    fontWeight: FontWeight.w900, fontSize: 30.sp),
                              ),
                            ),
                          ),
                        ),
                        RotatedBox(
                          quarterTurns: 2,
                          child: Container(
                            margin: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 0, top: 15.h),
                            child: Stack(
                              children: [
                                Container(
                                  height: 50.h,
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(left: 40.w, right: 0, bottom: 0, top: 0),
                                  child: Text(widget.gameInfo!.player1Name!, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16.sp)),
                                ),
                                Positioned(
                                  left: 0,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 0),
                                    child: Container(
                                      height: 50.h,
                                      width: 30.w,
                                      child: Image.asset(widget.gameInfo!.p1Emoji!, height: 30.h, width: 30.w, fit: BoxFit.contain),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  child: Container(
                                    width: (SizeConfig.screenWidth / 2),
                                    height: 40.h,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 5.h),
                                    decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.fill, image: AssetImage("assets/playbtn.png"))),
                                    child: Text("Score : $p1Score",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16.sp),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: SizeConfig.screenWidth,
                    height: 40.h,
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset("assets/centerline.png", height: 5.h, width: SizeConfig.screenWidth, fit: BoxFit.fitWidth),
                        Bounce(
                          duration: Duration(milliseconds: 200),
                          onPressed: () {
                            ClsSound.playSound(SOUNDTYPE.Tap);
                            setState(() {
                              isplay = false;
                            });
                          },
                          child: Container(
                            height: 40.h,
                            width: 40.w,
                            child: Image.asset("assets/ic_pause.png", height: 40.h, width: 40.w, fit: BoxFit.contain),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          bottom: 0,
                          child: Container(
                            width: 120.w,
                            height: 35.h,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 20.w, right: 0, bottom: 0, top: 0),
                            decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.fill, image: AssetImage("assets/playbtn.png"))),
                            child: RotatedBox(
                              quarterTurns: 2,
                              child: Text("Q : " + (currentQuestionIndex + 1).toString() + " / " + noOfQuestions.toString(),
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15.sp),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 120.w,
                            height: 35.h,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 0, right: 20.w, bottom: 0, top: 5.h),
                            decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.fill, image: AssetImage("assets/playbtn.png"))),
                            child: Text("Q : " + (currentQuestionIndex + 1).toString() + " / " + noOfQuestions.toString(),
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15.sp),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: SizeConfig.screenWidth,
                    height: (SizeConfig.screenHeight - 140.h) / 2,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 0, top: 15.h),
                          child: Stack(
                            children: [
                              Container(
                                height: 50.h,
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(left: 40.w, right: 0, bottom: 0, top: 0),
                                child: Text(widget.gameInfo!.player2Name!, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16.sp)),
                              ),
                              Positioned(
                                left: 0,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 0),
                                  child: Container(
                                    height: 50.h,
                                    width: 30.w,
                                    child: Image.asset(widget.gameInfo!.p2Emoji!, height: 30.h, width: 30.w, fit: BoxFit.contain),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: Container(
                                  width: (SizeConfig.screenWidth / 2),
                                  height: 40.h,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 5.h),
                                  decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.fill, image: AssetImage("assets/playbtn.png"))),
                                  child: Text("Score : " + p2Score.toString(),
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16.sp),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 0, top: 0),
                          child: Container(
                            width: quesWidth,
                            height: (quesHeight - 65.h),
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 0, top: 5.h),
                            decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.fill, image: AssetImage("assets/que_board.png"))),
                            child: Text((winner == 1) ? " Losser" : (winner == 2) ? " Winner" : (winner == 3) ? " It's Tie" : queList[currentQuestionIndex].question!,
                                style: TextStyle(color: (winner == 1) ? Colors.red : (winner == 2) ? Colors.green : (winner == 3) ? Color(0xFF5B5B5B) : Colors.white,
                                    fontWeight: FontWeight.w900, fontSize: 30.sp),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.0.h, left: 20.w, right: 20.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Bounce(
                                duration: Duration(milliseconds: 200),
                                onPressed: () {
                                  if (queList[currentQuestionIndex].options![0] != queList[currentQuestionIndex].answer) {
                                    setState(() {
                                      op4 = Colors.red;
                                      ClsSound.playSound(SOUNDTYPE.Wrong);
                                      print("==> correct ${incorrect2++}");
                                      isWrong = false;
                                      Vibration.vibrate(duration: 300);
                                      if (p2Score - 1 >= 0) {
                                        p2Score--;
                                      }
                                    });
                                    Future.delayed(200.ms, () {
                                      isWrong = !isWrong;
                                      setState(() {});
                                    });

                                    Timer _timer2 = Timer.periodic(Duration(milliseconds: 200), (value) {
                                      print("...timer");
                                      setState(() {
                                        op4 = Colors.indigo.shade900;
                                      });
                                      value.cancel();
                                    });
                                  } else {
                                    setState(() {
                                      ClsSound.playSound(SOUNDTYPE.Correct);
                                      print("==> correct ${correct2++}");
                                      op4 = Colors.green;
                                      p2Score++;
                                    });

                                    Timer _timer2 = Timer.periodic(Duration(milliseconds: 200), (value) {
                                      print("...timer");
                                      setState(() {
                                        op4 = Colors.indigo.shade900;
                                      });
                                      value.cancel();
                                      onOptionSelected(queList[currentQuestionIndex].options![0]);
                                    });
                                  }
                                },
                                child: Container(
                                  width: ansboxW,
                                  height: ansboxH,
                                  margin: EdgeInsets.only(left: 0, right: 0, bottom: 5.h, top: 5.h),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: Colors.yellow.shade400,
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text((winner == 1 || winner == 2 || winner == 3) ? "" : queList[currentQuestionIndex].options![0],
                                    style: TextStyle(color: op4, fontWeight: FontWeight.w900, fontSize: 28.sp),
                                  ),
                                ),
                              ),
                              Bounce(
                                duration: Duration(milliseconds: 200),
                                onPressed: () {
                                  if (queList[currentQuestionIndex].options![2] != queList[currentQuestionIndex].answer) {
                                    setState(() {
                                      ClsSound.playSound(SOUNDTYPE.Wrong);
                                      print("==> correct ${incorrect2++}");
                                      isWrong = false;
                                      Vibration.vibrate(duration: 300);
                                      op5 = Colors.red;
                                      if (p2Score - 1 >= 0) {
                                        p2Score--;
                                      }
                                    });
                                    Future.delayed(200.ms, () {
                                      isWrong = !isWrong;
                                      setState(() {});
                                    });

                                    Timer _timer2 = Timer.periodic(Duration(milliseconds: 200), (value) {
                                      print("...timer");
                                      setState(() {
                                        op5 = Colors.indigo.shade900;
                                      });
                                      value.cancel();
                                    });
                                  } else {
                                    ClsSound.playSound(SOUNDTYPE.Correct);
                                    print("==> correct ${correct2++}");
                                    setState(() {
                                      op5 = Colors.green;
                                      p2Score++;
                                    });

                                    Timer _timer2 = Timer.periodic(Duration(milliseconds: 200), (value) {
                                      print("...timer");
                                      setState(() {
                                        op5 = Colors.indigo.shade900;
                                      });
                                      value.cancel();
                                      onOptionSelected(queList[currentQuestionIndex].options![2]);
                                    });
                                  }
                                },
                                child: Container(
                                  width: ansboxW,
                                  height: ansboxH,
                                  margin: EdgeInsets.only(left: 0, right: 0, bottom: 5, top: 5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: Colors.red.shade300,
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text((winner == 1 || winner == 2 || winner == 3) ? "" : queList[currentQuestionIndex].options![2],
                                    style: TextStyle(color: op5, fontWeight: FontWeight.w900, fontSize: 28.sp),
                                  ),
                                ),
                              ),
                              Bounce(
                                duration: Duration(milliseconds: 200),
                                onPressed: () {
                                  if (queList[currentQuestionIndex].options![1] != queList[currentQuestionIndex].answer) {
                                    setState(() {
                                      ClsSound.playSound(SOUNDTYPE.Wrong);
                                      print("==> correct ${incorrect2++}");
                                      isWrong = false;
                                      Vibration.vibrate(duration: 300);
                                      op6 = Colors.red;
                                      if (p2Score - 1 >= 0) {
                                        p2Score--;
                                      }
                                    });
                                    Future.delayed(200.ms, () {
                                      isWrong = !isWrong;
                                      setState(() {});
                                    });

                                    Timer _timer2 = Timer.periodic(Duration(milliseconds: 200), (value) {
                                      print("...timer");
                                      setState(() {
                                        op6 = Colors.indigo.shade900;
                                      });
                                      value.cancel();
                                    });
                                  } else {
                                    setState(() {
                                      ClsSound.playSound(SOUNDTYPE.Correct);
                                      print("==> correct ${correct2++}");
                                      op6 = Colors.green;
                                      p2Score++;
                                    });

                                    Timer _timer2 = Timer.periodic(Duration(milliseconds: 200), (value) {
                                      print("...timer");
                                      setState(() {
                                        op6 = Colors.indigo.shade900;
                                      });
                                      value.cancel();
                                      onOptionSelected(queList[currentQuestionIndex].options![1]);
                                    });
                                  }
                                },
                                child: Container(
                                  width: ansboxW,
                                  height: ansboxH,
                                  margin: EdgeInsets.only(left: 0, right: 0, bottom: 5.h, top: 5.h),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: Colors.greenAccent.shade200,
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text((winner == 1 || winner == 2 || winner == 3) ? "" : queList[currentQuestionIndex].options![1],
                                    style: TextStyle(color: op6, fontWeight: FontWeight.w900, fontSize: 28.sp),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              isplay == false ? Container(
                alignment: Alignment.center,
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight,
                color: Colors.black.withOpacity(0.5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Bounce(
                      duration: Duration(milliseconds: 200),
                      onPressed: () {
                        ClsSound.playSound(SOUNDTYPE.Tap);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LevelPage()));
                      },
                      child: RotatedBox(
                        quarterTurns: 2,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Image.asset("assets/bgText.png", height: 78.h, width: SizeConfig.screenWidth * 0.65, fit: BoxFit.contain, color: Colors.red.shade300),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text("Go to Home".toUpperCase(),
                                style: TextStyle(fontSize: 20.sp, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 0, top: 5.h, bottom: 5.h, right: 0),
                      child: Bounce(
                        duration: Duration(milliseconds: 200),
                        onPressed: () {
                          ClsSound.playSound(SOUNDTYPE.Tap);
                          setState(() {
                            isplay = true;
                            isrestart = true;
                            queList = [];
                            setQuestions();
                          });
                        },
                        child: RotatedBox(
                          quarterTurns: 2,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Image.asset("assets/bgText1.png", height: 78.h, width: SizeConfig.screenWidth * 0.65, fit: BoxFit.contain),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text("Restart".toUpperCase(),
                                  style: TextStyle(fontSize: 20.sp, color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Bounce(
                      duration: Duration(milliseconds: 200),
                      onPressed: () {
                        ClsSound.playSound(SOUNDTYPE.Tap);
                        setState(() {
                          isplay = true;
                        });
                      },
                      child: RotatedBox(
                        quarterTurns: 2,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Image.asset("assets/bgText.png", height: 78.h, width: SizeConfig.screenWidth * 0.65, fit: BoxFit.contain),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text("Continue".toUpperCase(),
                                style: TextStyle(fontSize: 20.sp, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    Bounce(
                      duration: Duration(milliseconds: 200),
                      onPressed: () {
                        ClsSound.playSound(SOUNDTYPE.Tap);
                        setState(() {
                          isplay = true;
                        });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Image.asset("assets/bgText.png", height: 78.h, width: SizeConfig.screenWidth * 0.65, fit: BoxFit.contain),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text("Continue".toUpperCase(),
                              style: TextStyle(fontSize: 20.sp, color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 0, top: 5.h, bottom: 5.h, right: 0),
                      child: Bounce(
                        duration: Duration(milliseconds: 200),
                        onPressed: () {
                          ClsSound.playSound(SOUNDTYPE.Tap);
                          setState(() {
                            isplay = true;
                            isrestart = true;
                            queList = [];
                            setQuestions();
                          });
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Image.asset("assets/bgText1.png", height: 78.h, width: SizeConfig.screenWidth * 0.65, fit: BoxFit.contain),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text("Restart".toUpperCase(),
                                style: TextStyle(fontSize: 20.sp, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 0, top: 0, bottom: 10.h, right: 0),
                      child: Bounce(
                        duration: Duration(milliseconds: 200),
                        onPressed: () {
                          ClsSound.playSound(SOUNDTYPE.Tap);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Image.asset("assets/bgText.png", height: 78.h, width: SizeConfig.screenWidth * 0.65, fit: BoxFit.contain, color: Colors.red.shade300),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text("Go to Home".toUpperCase(),
                                style: TextStyle(fontSize: 20.sp, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ) : Container(),
            ],
          ) : const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  Widget VerticalText(String txt) {
    return Wrap(
      direction: Axis.vertical,
      children: [
        RotatedBox(
          quarterTurns: 2,
          child: Text(txt, style: TextStyle(color: Colors.black54, fontSize: 20.sp)),
        ),
      ],
    );
  }

  onOptionSelected(String selectedoption) async {
    if(currentQuestionIndex + 1 < queList.length) {
      currentQuestionIndex++;
      setState(() {});
    } else {
      isGameOver = true;
      if(p1Score > p2Score) {
        winner = 1;
      } else if(p1Score == p2Score) {
        winner = 3;
      } else {
        winner = 2;
      }

      Board gf = Board(
        player1name: widget.gameInfo!.player1Name.toString(),
        player2name: widget.gameInfo!.player2Name.toString(),
        player1emoji: widget.gameInfo!.p1Emoji,
        player2emoji: widget.gameInfo!.p2Emoji,
        player1score: p1Score.toString(),
        player2score: p2Score.toString(),
        mode: widget.gameInfo!.levelMode.toString(),
        noofquestion: widget.gameInfo!.noofquestion,
        operation: widget.gameInfo!.operation,
        winner: winner.toString(),
        datetime: DateFormat("dd/MM/yyyy hh:mm:ss").format(DateTime.now()),
      );

      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        ScoreBoardJson? sjson;
        if(prefs.containsKey("ScoreBoardJson")) {
          String? str = prefs.getString("ScoreBoardJson");
          if(str != "") {
            var convertedjson = json.decode(str!);
            sjson = ScoreBoardJson.fromJson(convertedjson);
          }
        }
        if(sjson == null) {
          List<Board> b = [];
          b.add(gf);
          sjson =ScoreBoardJson(board: b);
          Map<String, dynamic> data = Map<String, dynamic>();
          data = sjson.toJson();
          String newResult = json.encode(data);
          print(newResult);
          prefs.setString("ScoreBoardJson", newResult);
          prefs.commit();
        } else {
          sjson.board.add(gf);
          Map<String, dynamic> data = Map<String, dynamic>();
          data = sjson.toJson();
          String newResult = json.encode(data);
          print(newResult);
          prefs.setString("ScoreBoardJson", newResult);
          prefs.commit();
        }
      } on Exception catch (e) {
        print(e.toString());
      }

      setState(() {});

      ResultInfoFrd resultInfofrd = ResultInfoFrd(no_of_que: correct1 + incorrect1 + correct2 + incorrect2, correct1: correct1, incorrect1: incorrect1, correct2: correct2, incorrect2: incorrect2);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
          ResultPageFrd(data: gf, resultInfofrd: resultInfofrd, gameInfo: widget.gameInfo)));
    }
  }

  int correct1 = 0;
  int incorrect1 = 0;
  int correct2 = 0;
  int incorrect2 = 0;
  int _current = 30;
  int count = 0;

  startTime() async {
    countDownTimer = CountdownTimer(
      Duration(seconds: widget.gameInfo!.playTimeSec),
      Duration(seconds: 1),
    );

    var sub = countDownTimer!.listen((null));
    sub.onData((duration) {
      setState(() {
        _current = widget.gameInfo!.playTimeSec - duration.elapsed.inSeconds;

        if (_current == 6) {
          ClsSound.playTikTik();
        }
        if (_current < 6) {
          isAnimation = true;
        }
      });
    });

    Board gf = Board(
      player1name: widget.gameInfo!.player1Name.toString(),
      player2name: widget.gameInfo!.player2Name.toString(),
      player1emoji: widget.gameInfo!.p1Emoji,
      player2emoji: widget.gameInfo!.p2Emoji,
      player1score: p1Score.toString(),
      player2score: p2Score.toString(),
      mode: widget.gameInfo!.levelMode.toString(),
      noofquestion: widget.gameInfo!.noofquestion,
      operation: widget.gameInfo!.operation,
      winner: winner.toString(),
      datetime: DateFormat("dd/MM/yyyy hh:mm:ss").format(DateTime.now()),
    );

    sub.onDone(() {
      ResultInfoFrd resultInfofrd = ResultInfoFrd(
          no_of_que: correct1 + incorrect1 + correct2 + incorrect2,
          correct1: correct1,
          incorrect1: incorrect1,
          correct2: correct2,
          incorrect2: incorrect2);
      sub.cancel();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
          ResultPageFrd(resultInfofrd: resultInfofrd,
              gameInfo: widget.gameInfo,
              data: gf)));
    });
  }

  int nextIntRange(int min, int max) => min + Random().nextInt((max + 1) - min);

  setQuestions() {
    noOfQuestions = int.parse(widget.gameInfo!.noofquestion!);
    complexity = widget.gameInfo!.levelMode;
    winner = 0;
    currentQuestionIndex = 0;
    p1Score = 0;
    p2Score = 0;

    List<String> operator = [];

    if(widget.gameInfo!.operation!.contains("0")) {
      operator.add("+");
    }
    if(widget.gameInfo!.operation!.contains("1")) {
      operator.add("-");
    }
    if(widget.gameInfo!.operation!.contains("2")) {
      operator.add("x");
    }
    if(widget.gameInfo!.operation!.contains("3")) {
      operator.add("/");
    }

    for(int i = 0; i < noOfQuestions; i++) {
      String rOperator = operator[Random().nextInt(operator.length)];
      if(rOperator == "+") {
        queList.add(getAdditionQuestions());
      } else if(rOperator == "-") {
        queList.add(getSubtractionQuestion());
      } else if(rOperator == "x") {
        queList.add(getMultiplicationQuestion());
      } else if(rOperator == "/") {
        queList.add(getDivisionQuestion());
      }
    }
    setState(() {});
  }

  Question getAdditionQuestions() {
    int digitRange = 10;

    if(complexity == 0) {
      digitRange = 10;
    } else if(complexity == 1) {
      digitRange = 50;
    } else if(complexity == 2) {
      digitRange = 100;
    } else if(complexity == 3) {
      digitRange = 1000;
    }

    int operand1 = Random().nextInt(digitRange);
    int operand2 = Random().nextInt(digitRange);

    if(operand1 == 0 && operand2 == 0) {
      do {
        operand1 = Random().nextInt(digitRange);
        operand2 = Random().nextInt(digitRange);
      } while(operand1 == 0 && operand2 == 0);
    }

    int ans = operand1 + operand2;
    int op1 = nextIntRange(ans - 10, ans + 10);

    if(op1 == ans) {
      do {
        op1 = nextIntRange(ans - 10, ans + 10);
      } while(op1 == ans);
    }

    int op2 = nextIntRange(ans - 10, ans + 10);
    if(op2 == ans || op2 == op1) {
      do {
        op2 = nextIntRange(ans - 10, ans + 10);
        if(op2 == op1) {
          op2 = ans;
        }
      } while(op2 == ans);
    }

    String que = operand1.toString() + " + " + operand2.toString();
    List<String> opt = [];
    opt.add(op1.toString());
    opt.add(op2.toString());
    opt.add(ans.toString());
    opt.shuffle();

    Question Q = Question(question: que, answer: ans.toString(), options: opt, isDone: false);
    return Q;
  }

  Question getSubtractionQuestion() {
    int digitRange = 10;
    if (complexity == 0) {
      digitRange = 10;
    } else if (complexity == 1) {
      digitRange = 50;
    } else if (complexity == 2) {
      digitRange = 100;
    } else if (complexity == 3) {
      digitRange = 1000;
    }

    int operand1 = Random().nextInt(digitRange);
    int operand2 = Random().nextInt(digitRange);

    if (operand1 == 0 && operand2 == 0) {
      do {
        operand1 = Random().nextInt(digitRange);
        operand2 = Random().nextInt(digitRange);
      } while (operand1 == 0 && operand2 == 0);
    }

    do {
      operand2 = Random().nextInt(digitRange);
    } while (operand2 > operand1);

    int ans = operand1 - operand2;
    int op1 = nextIntRange(ans - 10, ans + 10);

    if (op1 == ans) {
      do {
        op1 = nextIntRange(ans - 10, ans + 10);
      } while (op1 == ans);
    }

    int op2 = nextIntRange(ans - 10, ans + 10);
    if (op2 == ans || op2 == op1) {
      do {
        op2 = nextIntRange(ans - 10, ans + 10);
        if (op2 == op1) {
          op2 = ans;
        }
      } while (op2 == ans);
    }

    String que = operand1.toString() + " - " + operand2.toString();

    List<String> opt = [];
    opt.add(op1.toString());
    opt.add(op2.toString());
    opt.add(ans.toString());
    opt.shuffle();

    Question Q = Question(question: que, answer: ans.toString(), options: opt, isDone: false);

    return Q;
  }

  Question getMultiplicationQuestion() {
    int digitRange = 10;
    if (complexity == 0) {
      digitRange = 10;
    } else if (complexity == 1) {
      digitRange = 20;
    } else if (complexity == 2) {
      digitRange = 40;
    } else if (complexity == 3) {
      digitRange = 100;
    }

    int operand1 = Random().nextInt(digitRange);
    int operand2 = Random().nextInt(digitRange);

    if (operand1 == 0 && operand2 == 0) {
      do {
        operand1 = Random().nextInt(digitRange);
        operand2 = Random().nextInt(digitRange);
      } while (operand1 == 0 && operand2 == 0);
    }

    int ans = operand1 * operand2;
    int op1 = nextIntRange(ans - 10, ans + 10);

    if (op1 == ans) {
      do {
        op1 = nextIntRange(ans - 10, ans + 10);
      } while (op1 == ans);
    }

    int op2 = nextIntRange(ans - 10, ans + 10);
    if (op2 == ans || op2 == op1) {
      do {
        op2 = nextIntRange(ans - 10, ans + 10);
        if (op2 == op1) {
          op2 = ans;
        }
      } while (op2 == ans);
    }

    String que = operand1.toString() + " x " + operand2.toString();
    List<String> opt = [];
    opt.add(op1.toString());
    opt.add(op2.toString());
    opt.add(ans.toString());
    opt.shuffle();

    Question Q = Question(question: que, answer: ans.toString(), options: opt, isDone: false);
    return Q;
  }

  Question getDivisionQuestion() {
    int digitRange = 10;
    if (complexity == 0) {
      digitRange = 10;
    } else if (complexity == 1) {
      digitRange = 20;
    } else if (complexity == 2) {
      digitRange = 40;
    } else if (complexity == 3) {
      digitRange = 100;
    }

    int operand1 = Random().nextInt(digitRange);
    int operand2 = Random().nextInt(digitRange);

    if (operand1 == 0) {
      do {
        operand1 = Random().nextInt(digitRange);
      } while (operand1 == 0);
    }

    do {
      operand2 = Random().nextInt(digitRange);
    } while (operand2 == 0);

    if ((operand1 % operand2) != 0) {
      do {
        operand2 = Random().nextInt(digitRange);
        if (operand2 != 0 && (operand1 % operand2) != 0) {
          operand2 = 0;
        }
      } while (operand2 == 0);
    }

    int ans = (operand1 / operand2).toInt();
    int op1 = nextIntRange(ans - 10, ans + 10);

    if (op1 == ans) {
      do {
        op1 = nextIntRange(ans - 10, ans + 10);
      } while (op1 == ans);
    }

    int op2 = nextIntRange(ans - 10, ans + 10);
    if (op2 == ans || op2 == op1) {
      do {
        op2 = nextIntRange(ans - 10, ans + 10);
        if (op2 == op1) {
          op2 = ans;
        }
      } while (op2 == ans);
    }

    String que = operand1.toString() + " / " + operand2.toString();

    List<String> opt = [];
    opt.add(op1.toString());
    opt.add(op2.toString());
    opt.add(ans.toString());
    opt.shuffle();

    Question Q = Question(question: que, answer: ans.toString(), options: opt, isDone: false);

    return Q;
  }

  @override
  void dispose() {
    countDownTimer?.cancel();
    ClsSound.stopTikTik();
    _animationController.stop();
    super.dispose();
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
}


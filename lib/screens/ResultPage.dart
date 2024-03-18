import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:confetti/confetti.dart';
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:games_services/games_services.dart';
import 'package:lottie/lottie.dart';
import 'package:mind_maze/constants.dart';
import 'package:mind_maze/main.dart';
import 'package:mind_maze/screens/GameCompleteDialog.dart';
import 'package:mind_maze/screens/GameModel.dart';
import 'package:mind_maze/screens/GiftPage.dart';
import 'package:mind_maze/screens/HomePage.dart';
import 'package:mind_maze/screens/ScoreBoard.dart';
import 'package:mind_maze/screens/TipsScreen.dart';
import 'package:mind_maze/screens/game_operations/LiveScorePoint.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:share_extend/share_extend.dart';
import '../common/ClsSound.dart';
import '../common/Common.dart';
import '../common/Key.dart';

class ResultPage extends StatefulWidget {
  final ResultInfo? resultInfo;
  GameModel gameModel;
  Function nextLevelTap;
  bool nextView;

  ResultPage({this.resultInfo, required this.gameModel, required this.nextLevelTap, this.nextView = true});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> with TickerProviderStateMixin {
  bool isrestart = false;
  double percent = 0, avg_accuracy = 0;
  int highest = 0;
  int lowest = 0;
  double mean_time = 0;
  late ShareData gf;
  int points = 0;
  int preTotal1 = 0;
  int preTotal = 0;
  late ConfettiController controllerTopCenter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controllerTopCenter = ConfettiController(duration: Duration(seconds: 10));
    oldPoint = 0;
    initScoreValue();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        callRetry();
        return Future.value(false);
      },
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: box_decoration,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              title: Text("ScoreCard", textAlign: TextAlign.center, style: TextStyle(color: txtColor, fontSize: 20.sp)),
              backgroundColor: Colors.transparent,
              leading: Container(
                child: InkWell(
                  onTap: () {
                    ClsSound.playSound(SOUNDTYPE.Tap);
                    callRetry();
                  },
                  child: Icon(Icons.chevron_left, size: 30.r, color: txtColor),
                ),
              ),
              actions: [
                InkWell(
                  onTap: () {
                    ClsSound.playSound(SOUNDTYPE.Tap);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ScoreBoard()));
                  },
                  child: Row(
                    children: [
                      Center(
                        child: Image.asset("assets/images/brain.png", height: 30.h, width: 30.h),
                      ),
                      SizedBox(width: 5.0),
                      Center(
                        child: Countup(
                          begin: preTotal.toDouble(),
                          end: (session.read(KEY.KEY_Point) ?? 0).toDouble(),
                          duration: Duration(seconds: 3),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: litetxtColor, fontSize: 20.sp),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 5.0),
              ],
            ),
            body: isrestart ? Container(
              alignment: Alignment.center,
              child: DefaultTextStyle(
                style: TextStyle(fontSize: 60.0.sp, color: white),
                child: AnimatedTextKit(
                  isRepeatingAnimation: false,
                  onFinished: () {
                    setState(() {
                      isrestart = false;
                    });
                  },
                  animatedTexts: [ScaleAnimatedText("Time's \n Up", textAlign: TextAlign.center)],
                ),
              ),
            ) : Container(
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Padding(padding: EdgeInsets.all(5)),
                        Row(
                          children: [
                            Padding(padding: EdgeInsets.all(5)),
                            Image.asset(widget.gameModel.Training_icon, height: 70.w, width: 70.w),
                            Padding(padding: EdgeInsets.all(5)),
                            Text(widget.gameModel.gameTitle, style: TextStyle(color: white, fontSize: 18.sp)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text("Incorrect", style: TextStyle(color: txtColor, fontSize: 16.sp)),
                                Text(widget.resultInfo!.incorrect.toString(), style: TextStyle(color: txtColor, fontSize: 20.sp))
                              ],
                            ),
                            Padding(padding: EdgeInsets.all(10)),
                            CircularPercentIndicator(
                              animation: true,
                              animationDuration: 1000,
                              radius: 65.r,
                              lineWidth: 18.w,
                              backgroundColor: txtColor,
                              percent: percent / 100,
                              center: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Accuracy", textAlign: TextAlign.center, style: TextStyle(color: white, fontSize: 12.sp)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text((percent).toStringAsFixed(2), textAlign: TextAlign.center,
                                        style: TextStyle(color: white, fontSize: 18.sp),
                                      ),
                                      Text("%", textAlign: TextAlign.center, style: TextStyle(color: white, fontSize: 12.sp)),
                                    ],
                                  )
                                ],
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: litetxtColor,
                            ),
                            Padding(padding: EdgeInsets.all(10)),
                            Column(
                              children: [
                                Text("Correct", style: TextStyle(color: litetxtColor, fontSize: 16.sp)),
                                Text(widget.resultInfo!.correct.toString(), style: TextStyle(color: litetxtColor, fontSize: 20.sp)),
                              ],
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/clock.png", color: white, height: 25.w, width: 25.w),
                            Text(" Mean Time ", style: TextStyle(color: white, fontSize: 16.sp)),
                            Text(mean_time.toStringAsFixed(2), style: TextStyle(color: white, fontSize: 25.sp)),
                            Text(" s ", style: TextStyle(color: white, fontSize: 20.sp)),
                          ],
                        ),
                        Padding(padding: EdgeInsets.all(5)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 50.w,
                              child: Lottie.asset('assets/lotti/67203-3d-coin.json'),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Container(
                                child: Countup(
                                  begin: 0,
                                  end: points.toDouble(),
                                  duration: Duration(seconds: 3),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: white, fontSize: 20.sp),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(top: 10.r, left: 20.r, right: 20.r),
                                child: Container(
                                  height: 100.h,
                                  width: 100.w,
                                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/Game/res_btn.png"), fit: BoxFit.fill)),
                                  child: Container(
                                    height: 0.12.sh,
                                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text("Battle Record", style: TextStyle(color: txtColor, fontSize: 14.sp)),
                                          Padding(padding: EdgeInsets.all(3.0)),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(
                                                children: [
                                                  Text("Highest", style: TextStyle(color: white, fontSize: 14.sp), textAlign: TextAlign.center),
                                                  Text("${session.read("hi_perce_${widget.gameModel.id.index}") ?? 0}% | ${session.read("hi_meanTime_${widget.gameModel.id.index}") ?? 0}s",
                                                      style: TextStyle(color: white, fontSize: 18.sp), textAlign: TextAlign.center),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                                width: 15.w,
                                              ),
                                              Column(
                                                children: [
                                                  Text("Lowest", style: TextStyle(color: white, fontSize: 14.sp), textAlign: TextAlign.center),
                                                  Text("${session.read("low_percent_${widget.gameModel.id.index}") ?? 0}% | ${session.read("low_meanTime_${widget.gameModel.id.index}") ?? 0}s",
                                                      style: TextStyle(color: white, fontSize: 18.sp), textAlign: TextAlign.center),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.all(5)),
                        Padding(padding: EdgeInsets.only(top: 10.r)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                ClsSound.playSound(SOUNDTYPE.Tap);
                                callRetry();
                              },
                              child: dialogBtn(Icons.restart_alt_rounded),
                            ),
                            GestureDetector(
                              onTap: () async {
                                ClsSound.playSound(SOUNDTYPE.Tap);
                                if(GameCount % 25 == 0) {
                                  await showRatingDialog(context);
                                }
                                callHome();
                              },
                              child: dialogBtn(Icons.home_rounded),
                            ),
                            GestureDetector(
                              onTap: () {
                                ClsSound.playSound(SOUNDTYPE.Tap);
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => GameCompleteDialog(
                                    data: gf,
                                    onRestartclick: (value) {
                                      if(value.toLowerCase() == "yes") {
                                      } else {
                                        callHome();
                                      }
                                    },
                                    gameModel: widget.gameModel,
                                  ),
                                );
                              },
                              child: Container(
                                height: 50.r,
                                width: 50.r,
                                margin: EdgeInsets.only(left: 5.r, right: 5.r),
                                decoration: BoxDecoration(shape: BoxShape.circle, color: dialogBtnColor,
                                    border: Border.all(color: txtColor.withOpacity(0.8), width: 2.r)),
                                child: Center(
                                  child: Lottie.asset("assets/lotti/74429-press-send.json"),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: widget.nextView,
                              child: GestureDetector(
                                onTap: () {
                                  ClsSound.playSound(SOUNDTYPE.Tap);
                                  widget.nextLevelTap();
                                },
                                child: dialogBtn(Icons.keyboard_double_arrow_right_rounded),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: controllerTopCenter,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Colors.yellow
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  void shareOther(File? savedImageFile) {
    ShareExtend.share(savedImageFile!.path, 'image');
  }

  int GameCount = 0;

  void callRetry() async {
    if(GameCount % 25 == 0) {
      await showRatingDialog(context);
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TipsScreen(gameModel: widget.gameModel)));
  }

  void callHome() {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePage()), (Route<dynamic> route) => false);
  }

  void initScoreValue() {
    isrestart = true;
    preTotal = (session.read(KEY.KEY_Point) ?? 0);
    if(widget.resultInfo!.no_of_que == 0) {
      mean_time = 0;
      percent = 0;
      points = 0;
    } else {
      mean_time = (widget.gameModel.playTimeSec / (widget.resultInfo!.no_of_que)!);
      percent = ((widget.resultInfo!.correct)! / (widget.resultInfo!.no_of_que)!) * 100;
      points = (percent / mean_time).toInt() - (widget.resultInfo?.incorrect ?? 0);
      if(widget.resultInfo!.incorrect == 0) {
        points = points * 2;
        Future.delayed(Duration(milliseconds: 2000), () {
          setState(() {
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => GiftPage(gameModel: widget.gameModel, points: points)));
          });
        });
      }
    }
    if(points<1) {
      points = 0;
    }

    mean_time = mean_time.toPrecision(2);
    percent = percent.toPrecision(2);
    if(session.read(KEY.KEY_Avg_Accuarcy) == 0) {
      avg_accuracy = 0;
    } else {
      avg_accuracy = ((session.read(KEY.KEY_Avg_Accuarcy) ?? 0)+percent)/2;
    }
    preTotal1 = preTotal;
    for(int i = 0; i < points; i++) {
      preTotal1 = preTotal1 + 1;
      if((preTotal1) % 1000 == 0) {
        controllerTopCenter.play();
      }
      print("PreTotal: $preTotal1");
    }

    session.write(KEY.KEY_Avg_Accuarcy, avg_accuracy.toPrecision(2));
    gf = ShareData(percent: percent, time: mean_time, correct: widget.resultInfo!.correct, incorrect: widget.resultInfo!.incorrect);
    print('$percent ' + widget.resultInfo!.correct.toString() + " " + widget.resultInfo!.incorrect.toString());
    session.write("total_${widget.gameModel.id.index}", (session.read("total_${widget.gameModel.id.index}") ?? 0) + points);
    session.write(KEY.KEY_Point, (session.read(KEY.KEY_Point) ?? 0) + points);
    GameCount = (session.read(KEY.KEY_GameCount) ?? 0);
    GameCount++;
    session.write(KEY.KEY_GameCount, GameCount);

    session.write("GPlay_${widget.gameModel.id.index}", (session.read("GPlay_${widget.gameModel.id.index}") ?? 0) + 1);
    try {
      var result = GamesServices.submitScore(score: Score(androidLeaderboardID: getTopPointLBId, iOSLeaderboardID: getTopPointLBId, value: (session.read(KEY.KEY_Point) ?? 0)));
      print(result.toString());
    }  catch (e, t) {
      print(t);
    }
    try {
      var result = GamesServices.submitScore(score: Score(androidLeaderboardID: getTopGamePlayLBId, iOSLeaderboardID: getTopGamePlayLBId, value: (session.read(KEY.KEY_GameCount) ?? 0)));
      print(result.toString());
    } catch (e, t) {
      print(t);
    }

    checkAchivement();
    if ((session.read("hi_coin_${widget.gameModel.id.index}") ?? 0) < points) {
      session.write("hi_coin_${widget.gameModel.id.index}", points);
      session.write("hi_meanTime_${widget.gameModel.id.index}", mean_time);
      session.write("hi_perce_${widget.gameModel.id.index}", percent);
      session.write("hi_score_${widget.gameModel.id.index}", points);
    } else {
      if ((session.read("low_coin_${widget.gameModel.id.index}") ?? 1000) > points) {
        session.write("low_coin_${widget.gameModel.id.index}", points);
        session.write("low_meanTime_${widget.gameModel.id.index}", mean_time);
        session.write("low_percent_${widget.gameModel.id.index}", percent);
      }
    }
  }

  void checkAchivement() async {
    try {
      List<AchievementItemData> achievementList = await GamesServices.loadAchievements() ?? [];

      for (AchievementItemData achievementItemData in achievementList) {}

      if ((session.read(KEY.KEY_GameCount) ?? 0 )>= 25) {
        var result = GamesServices.unlock(achievement: Achievement(androidID: get25GamePlayACHId, iOSID: get25GamePlayACHId, percentComplete: 100));
        print('result=${result.toString()}');
      }
      if ((session.read(KEY.KEY_GameCount) ?? 0 )>= 50) {
        var result = GamesServices.unlock(achievement: Achievement(androidID: get50GamePlayACHId, iOSID: get50GamePlayACHId, percentComplete: 100));
        print(result.toString());
      }

      if ((session.read(KEY.KEY_GameCount) ?? 0 )>= 100) {
        var result = GamesServices.unlock(achievement: Achievement(androidID: get100GamePlayACHId, iOSID: get100GamePlayACHId, percentComplete: 100));
        print(result.toString());
      }

      if ((session.read(KEY.KEY_Point) ?? 0) >= 1000) {
        var result = GamesServices.unlock(achievement: Achievement(androidID: get1KPointACHId, iOSID: get1KPointACHId, percentComplete: 100));
        print(result.toString());
      }
      if ((session.read(KEY.KEY_Point) ?? 0 )>= 2500) {
        var result = GamesServices.unlock(achievement: Achievement(androidID: get2500PointACHId, iOSID: get2500PointACHId, percentComplete: 100));
        print(result.toString());
      }
      if ((session.read(KEY.KEY_Point) ?? 0 )>= 5000) {
        var result = GamesServices.unlock(achievement: Achievement(androidID: get5KPointACHId, iOSID: get5KPointACHId, percentComplete: 100));
        print(result.toString());
      }
    } catch (e, t) {
      print(e);
      print(t);
    }
  }
}

dialogBtn(IconData icon) {
  return Container(
    height: 50.r,
    width: 50.r,
    margin: EdgeInsets.only(left: 5.r, right: 5.r),
    decoration: BoxDecoration(shape: BoxShape.circle, color: dialogBtnColor, border: Border.all(color: txtColor.withOpacity(0.8), width: 2.r)),
    child: Center(
      child: Icon(icon, color: txtColor, size: 30.r),
    ),
  );
}
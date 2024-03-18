import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:confetti/confetti.dart';
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:games_services/games_services.dart';
import 'package:lottie/lottie.dart';
import 'package:mind_maze/common/Common.dart';
import 'package:mind_maze/common/Key.dart';
import 'package:mind_maze/main.dart';
import 'package:mind_maze/screens/HomePage.dart';
import 'package:mind_maze/screens/Play%20with%20frd/CompleteDialogFrd.dart';
import 'package:mind_maze/screens/Play%20with%20frd/LevelPage.dart';
import 'package:mind_maze/screens/Play%20with%20frd/ScoreBoardFrd.dart';
import 'package:mind_maze/screens/ResultPage.dart';
import 'package:mind_maze/screens/game_operations/LiveScorePoint.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../common/ClsSound.dart';
import '../../constants.dart';

class ResultPageFrd extends StatefulWidget {
  ResultInfoFrd resultInfofrd;
  final Board? data;
  GameInfo gameInfo;

  ResultPageFrd({Key? key, this.data, required this.resultInfofrd, required this.gameInfo}) : super(key: key);

  @override
  State<ResultPageFrd> createState() => _ResultPageFrdState();
}

class _ResultPageFrdState extends State<ResultPageFrd> {
  double percent1 = 0, avg_accuracy1 = 0, percent2 = 0, avg_accuracy2 = 0;
  bool isrestart = false;
  int preTotal = 0;
  double mean_time = 0;
  late ShareDataFrd gfs;
  int points = 0;
  int preTotal1 = 0;
  late ConfettiController controllerTopCenter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controllerTopCenter = ConfettiController(duration: Duration(seconds: 10));
    oldPoint = 0;

    if(widget.resultInfofrd != null) {
      initScoreValue1();
      initScoreValue2();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LevelPage()));
                  },
                  child: Icon(Icons.chevron_left, size: 30.r, color: txtColor),
                ),
              ),
              actions: [
                InkWell(
                  onTap: () {
                    ClsSound.playSound(SOUNDTYPE.Tap);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ScoreBoardFrd()));
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
                        Padding(padding: EdgeInsets.only(top: 5.r)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(padding: EdgeInsets.all(5.r)),
                            Container(
                              height: 40.h,
                              width: 30.w,
                              child: Image.asset(widget.data!.player1emoji!, height: 50.h, width: 30.w, fit: BoxFit.contain),
                            ),
                            Padding(padding: EdgeInsets.all(5.r)),
                            Text(widget.data!.player1name!, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20.sp)),
                            Padding(padding: EdgeInsets.all(5.r)),
                            SizedBox(width: 30.r),
                            Text(int.parse(widget.data!.player1score!) > int.parse(widget.data!.player2score!)
                                ? "Winner" : int.parse(widget.data!.player1score!) == int.parse(widget.data!.player2score!)
                                ? "It's Tie" : "Losser",
                              style: TextStyle(color: int.parse(widget.data!.player1score!) > int.parse(widget.data!.player2score!)
                                  ? Colors.green : int.parse(widget.data!.player1score!) == int.parse(widget.data!.player2score!)
                                  ? Colors.yellow : Colors.red, fontWeight: FontWeight.w900, fontSize: 20.sp),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 5.r)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(padding: EdgeInsets.all(5.r)),
                            Column(
                              children: [
                                Text("Incorrect", style: TextStyle(color: txtColor, fontSize: 16.sp)),
                                Text(widget.resultInfofrd!.incorrect1.toString(), style: TextStyle(color: txtColor, fontSize: 20.sp))
                              ],
                            ),
                            Padding(padding: EdgeInsets.all(10.r)),
                            CircularPercentIndicator(
                              animation: true,
                              animationDuration: 1000,
                              radius: 65.r,
                              lineWidth: 18.w,
                              backgroundColor: txtColor,
                              percent: percent1 / 100,
                              center: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Accuracy", textAlign: TextAlign.center, style: TextStyle(color: white, fontSize: 12.sp)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text((percent1).toStringAsFixed(2), textAlign: TextAlign.center,
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
                            Padding(padding: EdgeInsets.all(10.r)),
                            Column(
                              children: [
                                Text("Correct", style: TextStyle(color: litetxtColor, fontSize: 16.sp)),
                                Text(widget.resultInfofrd!.correct1.toString(), style: TextStyle(color: litetxtColor, fontSize: 20.sp)),
                              ],
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.all(5.r)),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(left: 25.w, top: 5.h, bottom: 0, right: 25.w),
                          color: Colors.white,
                          height: 1,
                        ),
                        Padding(padding: EdgeInsets.only(top: 5.r)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(padding: EdgeInsets.all(5.r)),
                            Container(
                              height: 40.h,
                              width: 30.w,
                              child: Image.asset(widget.data!.player2emoji!, height: 50.h, width: 30.w, fit: BoxFit.contain),
                            ),
                            Padding(padding: EdgeInsets.all(5.r)),
                            Text(widget.data!.player2name!, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20.sp)),
                            Padding(padding: EdgeInsets.all(5.r)),
                            SizedBox(width: 30.r),
                            Text(int.parse(widget.data!.player2score!) > int.parse(widget.data!.player1score!)
                                ? "Winner" : int.parse(widget.data!.player1score!) == int.parse(widget.data!.player2score!)
                                ? "It's Tie" : "Losser",
                              style: TextStyle(color: int.parse(widget.data!.player2score!) > int.parse(widget.data!.player1score!)
                                  ? Colors.green : int.parse(widget.data!.player1score!) == int.parse(widget.data!.player2score!)
                                  ? Colors.yellow : Colors.red, fontWeight: FontWeight.w900, fontSize: 20.sp),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 5.r)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(padding: EdgeInsets.all(5.r)),
                            Column(
                              children: [
                                Text("Incorrect", style: TextStyle(color: txtColor, fontSize: 16.sp)),
                                Text(widget.resultInfofrd!.incorrect2.toString(), style: TextStyle(color: txtColor, fontSize: 20.sp))
                              ],
                            ),
                            Padding(padding: EdgeInsets.all(10.r)),
                            CircularPercentIndicator(
                              animation: true,
                              animationDuration: 1000,
                              radius: 65.r,
                              lineWidth: 18.w,
                              backgroundColor: txtColor,
                              percent: percent2 / 100,
                              center: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Accuracy", textAlign: TextAlign.center, style: TextStyle(color: white, fontSize: 12.sp)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text((percent2).toStringAsFixed(2), textAlign: TextAlign.center,
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
                            Padding(padding: EdgeInsets.all(10.r)),
                            Column(
                              children: [
                                Text("Correct", style: TextStyle(color: litetxtColor, fontSize: 16.sp)),
                                Text(widget.resultInfofrd!.correct2.toString(), style: TextStyle(color: litetxtColor, fontSize: 20.sp)),
                              ],
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.all(10.r)),
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
                        Padding(padding: EdgeInsets.all(5.r)),
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
                        Padding(padding: EdgeInsets.all(5.r)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                ClsSound.playSound(SOUNDTYPE.Tap);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => LevelPage()));
                              },
                              child: dialogBtn(Icons.restart_alt_rounded),
                            ),
                            InkWell(
                              onTap: () async {
                                ClsSound.playSound(SOUNDTYPE.Tap);
                                if(GameCount % 25 == 0) {
                                  await showRatingDialog(context);
                                }
                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                              },
                              child: dialogBtn(Icons.home_rounded),
                            ),
                            InkWell(
                              onTap: () {
                                ClsSound.playSound(SOUNDTYPE.Tap);
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => CompleteDialogFrd(
                                    data1: widget.data!,
                                    dataFrd: gfs,
                                    onRestartclick: (value) {
                                      if(value.toLowerCase() == "yes") {
                                      } else {
                                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePage()), (Route<dynamic> route) => false);
                                      }
                                    },
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

  int GameCount = 0;

  void initScoreValue1() {
    isrestart = true;
    preTotal = (session.read(KEY.KEY_Point) ?? 0);
    if(widget.resultInfofrd!.no_of_que == 0) {
      mean_time = 0;
      percent1 = 0;
      points = 0;
    } else {
      mean_time = (widget.resultInfofrd?.no_of_que ?? 0) > 0 ? (widget.gameInfo!.playTimeSec / (widget.resultInfofrd!.no_of_que!)) : 0;
      percent1 = ((widget.resultInfofrd!.correct1)! / (widget.resultInfofrd!.no_of_que)!) * 100;
      points = (percent1 / mean_time).toInt() - (widget.resultInfofrd?.incorrect1 ?? 0);
      if(widget.resultInfofrd!.incorrect1 == 0) {
        points = points * 2;
        Future.delayed(Duration(milliseconds: 2000), () {
          setState(() {});
        });
      }
    }
    if(points<1) {
      points = 0;
    }

    mean_time = double.parse(mean_time.toStringAsFixed(2));
    percent1 = double.parse(percent1.toStringAsFixed(2));
    if(session.read(KEY.KEY_Avg_Accuarcy) == 0) {
      avg_accuracy1 = 0;
    } else {
      avg_accuracy1 = ((session.read(KEY.KEY_Avg_Accuarcy) ?? 0)+percent1)/2;
    }
    preTotal1 = preTotal;
    for(int i = 0; i < points; i++) {
      preTotal1 = preTotal1 + 1;
      if((preTotal1) % 1000 == 0) {
        controllerTopCenter.play();
      }
      print("PreTotal: $preTotal1");
    }

    session.write(KEY.KEY_Avg_Accuarcy, avg_accuracy1.toPrecision(2));
    gfs = ShareDataFrd(percent1: percent1, time: mean_time, correct1: widget.resultInfofrd!.correct1, incorrect1: widget.resultInfofrd!.incorrect1);
    print('$percent1 ' + widget.resultInfofrd!.correct1.toString() + " " + widget.resultInfofrd!.incorrect1.toString());
    session.write(KEY.KEY_Point, (session.read(KEY.KEY_Point) ?? 0) + points);
    GameCount = (session.read(KEY.KEY_GameCount) ?? 0);
    GameCount++;
    session.write(KEY.KEY_GameCount, GameCount);

    try {
      var result = GamesServices.submitScore(score: Score(androidLeaderboardID: getTopPointLBId, iOSLeaderboardID: getTopPointLBId, value: (session.read(KEY.KEY_Point) ?? 0)));
      print(result.toString());
    } catch (e, t) {
      print(t);
    }
    try {
      var result = GamesServices.submitScore(score: Score(androidLeaderboardID: getTopGamePlayLBId, iOSLeaderboardID: getTopGamePlayLBId, value: (session.read(KEY.KEY_GameCount) ?? 0)));
      print(result.toString());
    } catch (e, t) {
      print(t);
    }

    checkAchivement();
  }

  void initScoreValue2() {
    isrestart = true;
    preTotal = (session.read(KEY.KEY_Point) ?? 0);
    if(widget.resultInfofrd!.no_of_que == 0) {
      mean_time = 0;
      percent2 = 0;
      points = 0;
    } else {
      mean_time = (widget.resultInfofrd?.no_of_que ?? 0) > 0 ? (widget.gameInfo!.playTimeSec / (widget.resultInfofrd!.no_of_que!)) : 0;
      percent2 = ((widget.resultInfofrd!.correct2)! / (widget.resultInfofrd!.no_of_que)!) * 100;
      points = (percent2 / mean_time).toInt() - (widget.resultInfofrd?.incorrect2 ?? 0);
      if(widget.resultInfofrd!.incorrect2 == 0) {
        points = points * 2;
        Future.delayed(Duration(milliseconds: 2000), () {
          setState(() {});
        });
      }
    }
    if(points<1) {
      points = 0;
    }

    mean_time = double.parse(mean_time.toStringAsFixed(2));
    percent2 = double.parse(percent2.toStringAsFixed(2));
    if(session.read(KEY.KEY_Avg_Accuarcy) == 0) {
      avg_accuracy2 = 0;
    } else {
      avg_accuracy2 = ((session.read(KEY.KEY_Avg_Accuarcy) ?? 0)+percent2)/2;
    }
    preTotal1 = preTotal;
    for(int i = 0; i < points; i++) {
      preTotal1 = preTotal1 + 1;
      if((preTotal1) % 1000 == 0) {
        controllerTopCenter.play();
      }
      print("PreTotal: $preTotal1");
    }

    session.write(KEY.KEY_Avg_Accuarcy, avg_accuracy2.toPrecision(2));
    gfs = ShareDataFrd(percent2: percent2, time: mean_time, correct2: widget.resultInfofrd!.correct2, incorrect2: widget.resultInfofrd!.incorrect2);
    print('$percent2 ' + widget.resultInfofrd!.correct2.toString() + " " + widget.resultInfofrd!.incorrect2.toString());
    session.write(KEY.KEY_Point, (session.read(KEY.KEY_Point) ?? 0) + points);
    GameCount = (session.read(KEY.KEY_GameCount) ?? 0);
    GameCount++;
    session.write(KEY.KEY_GameCount, GameCount);

    try {
      var result = GamesServices.submitScore(score: Score(androidLeaderboardID: getTopPointLBId, iOSLeaderboardID: getTopPointLBId, value: (session.read(KEY.KEY_Point) ?? 0)));
      print(result.toString());
    } catch (e, t) {
      print(t);
    }
    try {
      var result = GamesServices.submitScore(score: Score(androidLeaderboardID: getTopGamePlayLBId, iOSLeaderboardID: getTopGamePlayLBId, value: (session.read(KEY.KEY_GameCount) ?? 0)));
      print(result.toString());
    } catch (e, t) {
      print(t);
    }

    checkAchivement();
  }

  void checkAchivement() async {
    try {
      List<AchievementItemData> achievementList = await GamesServices.loadAchievements() ?? [];

      for (AchievementItemData achievementItemData in achievementList) {}

      if ((session.read(KEY.KEY_GameCount) ?? 0) >= 25) {
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

  @override
  void dispose() {
    super.dispose();
    controllerTopCenter.dispose();
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
}

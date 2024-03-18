import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mind_maze/common/Common.dart';
import 'package:mind_maze/main.dart';
import 'package:mind_maze/screens/GameModel.dart';
import 'package:mind_maze/screens/ResultPage.dart';
import 'package:mind_maze/screens/TimerTitle.dart';
import 'package:mind_maze/screens/TipsScreen.dart';
import 'package:mind_maze/screens/game_operations/LiveScorePoint.dart';
import 'package:quiver/async.dart';
import 'package:vibration/vibration.dart';
import '../../common/ClsSound.dart';
import '../../common/Key.dart';
import '../../constants.dart';

class ColorDeceptionGamePage extends StatefulWidget {
  GameModel gameModel;

  ColorDeceptionGamePage({required this.gameModel});

  @override
  State<ColorDeceptionGamePage> createState() => _ColorDeceptionGamePageState();
}

class _ColorDeceptionGamePageState extends State<ColorDeceptionGamePage> with SingleTickerProviderStateMixin {
  bool isAnimation = false, isStart = true;
  List<int> timeList = [];
  Timer? timer;

  int correct = 0;
  int incorrect = 0;
  int _current = 30;
  int count = 0;

  String selected = "Pink";
  bool isWrong = true;
  bool isDone = true;
  late AnimationController _animationController;

  Map<String, Color> colorMap = {
    'Pink': Colors.pinkAccent,
    'Red': Colors.red,
    'Blue': Colors.blue,
    'Yellow': Colors.yellow,
    'Green': Colors.green
  };

  Map<String, Color> currentColor = {};

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        ClsSound.playSound(SOUNDTYPE.Tap);
        countDownTimer?.cancel();
        ClsSound.stopTikTik();
        _animationController.stop();
        return backButton(context);
      },
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: box_decoration,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            actions: [
              LiveScorePoint(correct, incorrect, _current, widget.gameModel.playTimeSec),
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
          body: Column(
            children: [
              Expanded(
                child: isStart ? Container(
                  alignment: Alignment.center,
                  child: DefaultTextStyle(
                    style: TextStyle(fontSize: 70.0.sp, color: white),
                    child: AnimatedTextKit(
                      isRepeatingAnimation: false,
                      onFinished: () {
                        setState(() {
                          isStart = false;
                          startTime();
                        });
                      },
                      animatedTexts: [
                        ScaleAnimatedText('3', duration: 500.ms),
                        ScaleAnimatedText('2', duration: 500.ms),
                        ScaleAnimatedText('1', duration: 500.ms),
                      ],
                    ),
                  ),
                ) : Stack(
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
                                end: Alignment.bottomCenter
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
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          StaggeredGrid.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            children: currentColor.keys.map((key) {
                              return GestureDetector(
                                onTap: () {
                                  selected = key;
                                  if(currentColor[key] != colorMap[key]) {
                                    initGame(count++);
                                    setState(() {
                                      print("==> correct ${correct++}");
                                      ClsSound.playSound(SOUNDTYPE.Correct);
                                    });
                                  } else {
                                    setState(() {
                                      print("==> correct ${incorrect++}");
                                      isWrong = false;
                                      Vibration.vibrate(duration: 300);
                                    });
                                    Future.delayed(200.ms, () {
                                      isWrong = !isWrong;
                                      setState(() {});
                                    });
                                  }
                                },
                                child: isWrong
                                  ? Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(20),
                                  height: 100.h,
                                  width: 100.h,
                                  decoration: BoxDecoration(
                                    color: currentColor[key],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(key, style: TextStyle(color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.bold)),
                                  ),
                                ).animate(target: isDone ? 1 : 0).shimmer(duration: 200.ms).shake(hz: 2, curve: Curves.easeInOutCubic)
                                  : Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(20),
                                  height: 100.h,
                                  width: 100.h,
                                  decoration: BoxDecoration(
                                    color: currentColor[key],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(key, style: TextStyle(color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.bold)),
                                  ),
                                ).animate(target: selected != key ? 1 : 0).shake(hz: 8, curve: Curves.easeInOutCubic).scale(begin: Offset(1, 1), end: Offset(0.9, 0.9)),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void initGame(int count) {
    currentColor = {};
    Random random = Random();

    List<String> keys = colorMap.keys.toList();
    keys.shuffle();

    if(random.nextInt(100) % 2 == 0) {
      currentColor[keys[0]] = colorMap[keys[0]]!;
      currentColor[keys[1]] = colorMap[keys[1]]!;
      currentColor[keys[2]] = colorMap[keys[2]]!;
      currentColor[keys[3]] = colorMap[keys[4]]!;
    } else if(random.nextInt(100) % 3 == 0) {
      currentColor[keys[0]] = colorMap[keys[0]]!;
      currentColor[keys[1]] = colorMap[keys[4]]!;
      currentColor[keys[2]] = colorMap[keys[2]]!;
      currentColor[keys[3]] = colorMap[keys[3]]!;
    } else if(random.nextInt(100) % 4 == 0) {
      currentColor[keys[0]] = colorMap[keys[0]]!;
      currentColor[keys[1]] = colorMap[keys[1]]!;
      currentColor[keys[2]] = colorMap[keys[4]]!;
      currentColor[keys[3]] = colorMap[keys[3]]!;
    } else {
      currentColor[keys[0]] = colorMap[keys[4]]!;
      currentColor[keys[1]] = colorMap[keys[1]]!;
      currentColor[keys[2]] = colorMap[keys[2]]!;
      currentColor[keys[3]] = colorMap[keys[3]]!;
    }

    print(currentColor);
    Future.delayed(200.ms, () {
      isDone = !isDone;
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    initGame(count);
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationController.repeat(reverse: true);
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    countDownTimer?.cancel();
    ClsSound.stopTikTik();
    _animationController.stop();
    super.dispose();
  }

  CountdownTimer? countDownTimer;

  startTime() async {
    countDownTimer = CountdownTimer(
      Duration(seconds: widget.gameModel.playTimeSec),
      Duration(seconds: 1),
    );

    var sub = countDownTimer!.listen(null);
    sub.onData((duration) {
      setState(() {
        _current = widget.gameModel.playTimeSec - duration.elapsed.inSeconds;

        if (_current == 6) {
          ClsSound.playTikTik();
        }
        if(_current < 6) {
          isAnimation = true;
        }
      });
    });

    sub.onDone(() {
      ResultInfo resultInfo = ResultInfo(no_of_que: correct + incorrect, correct: correct, incorrect: incorrect);
      sub.cancel();
      goTo(resultInfo);
    });
  }

  goTo(ResultInfo resultInfo) {
    List temp = (session.read(KEY.KEY_Unlock) ?? [1]);
    temp.add(gameModelList[3].gameId);
    session.write(KEY.KEY_Unlock, temp);

    int sum = (session.read(KEY.KEY_TotalCompleteLevel) ?? 0) + 1;
    session.write(KEY.KEY_TotalCompleteLevel, sum);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
        ResultPage(
          resultInfo: resultInfo,
          gameModel: widget.gameModel,
          nextLevelTap: () {
            session.write(KEY.KEY_Timer, 0);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return TipsScreen(gameModel: gameModelList[3]);
            }));
          },
        )));
  }
}

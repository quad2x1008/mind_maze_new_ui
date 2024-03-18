import 'dart:async';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mind_maze/common/Key.dart';
import 'package:mind_maze/main.dart';
import 'package:mind_maze/screens/GameModel.dart';
import 'package:mind_maze/screens/TipsScreen.dart';
import 'package:quiver/async.dart';
import 'package:vibration/vibration.dart';
import '../../common/ClsSound.dart';
import '../../common/Common.dart';
import '../../constants.dart';
import '../ResultPage.dart';
import '../TimerTitle.dart';
import '../game_operations/LiveScorePoint.dart';

class FlickMaster extends StatefulWidget {
  GameModel gameModel;

  FlickMaster({required this.gameModel});

  @override
  State<FlickMaster> createState() => _FlickMasterState();
}

class _FlickMasterState extends State<FlickMaster> with SingleTickerProviderStateMixin {
  int num = 1;
  var preImage;
  static var _random = Random();

  @override
  void initState() {
    super.initState();
    initGame();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationController?.repeat(reverse: true);
  }

  var imageToShow = listImagesNotFound[0];

  void initGame() {
    imageToShow = listImagesNotFound[_random.nextInt(listImagesNotFound.length)];
    if (preImage == imageToShow) {
      do {
        imageToShow = listImagesNotFound[_random.nextInt(listImagesNotFound.length)];
      } while (preImage == imageToShow);
    }
    setState(() {});
  }

  Timer? timer;
  int ans = 0;
  int correct = 0;
  int incorrect = 0;
  int _current = 30;

  AnimationController? _animationController;
  bool isAnimation = false, isStart = true;
  bool isDone = true;
  bool isWrong = true;
  bool isDetact = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        ClsSound.playSound(SOUNDTYPE.Tap);
        countDownTimer?.cancel();
        ClsSound.stopTikTik();
        _animationController?.stop();
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
              LiveScorePoint(correct,incorrect,_current,widget.gameModel.playTimeSec),
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
                  _animationController?.dispose();
                  backButton(context);
                },
                child: Icon(Icons.chevron_left, size: 30.r, color: primaryColor)),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: isStart?Container(
                    alignment: Alignment.center,
                    child: DefaultTextStyle(
                      style:  TextStyle(fontSize: 70.0.sp, color: white),
                      child: AnimatedTextKit(
                        isRepeatingAnimation: false,
                        onFinished: () {
                          setState(() {
                            isStart = false;
                            startTime();
                          });
                        },
                        animatedTexts: [
                          ScaleAnimatedText('3',duration: 500.ms),
                          ScaleAnimatedText('2',duration: 500.ms),
                          ScaleAnimatedText('1',duration: 500.ms),
                        ],
                      ),
                    ),
                  ):Stack(
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
                          opacity: _animationController!,
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
                        transformAlignment: Alignment.center,
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Listener(
                          onPointerDown: (point) {
                            ClsSound.playSound(SOUNDTYPE.Tap);
                            print(point.position);
                          },
                          onPointerMove: (details) {
                            if (!isDetact) {
                              if (details.delta.dy > 3) {
                                isDetact = true;
                                print("down${details.delta.dy}");
                                checkAns('down');
                              }
                              if (details.delta.dy < -3) {
                                print("up${details.delta.dy}");
                                isDetact = true;
                                checkAns('up');
                              }
                              if (details.delta.dx > 3) {
                                print("right${details.delta.dx}");
                                isDetact = true;
                                checkAns('right');
                              }
                              if (details.delta.dx < -3) {
                                print("left, ${details.delta.dx}");
                                isDetact = true;
                                checkAns('left');
                              }
                            }
                          },
                          onPointerUp: (details) {
                            isDetact = false;
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(30.0),
                            child: Center(
                              child: isWrong
                                ? Image.asset(imageToShow.toString()).animate(target: isDone ? 1 : 0).scale(begin: Offset(1, 1), end: Offset(0.8, 0.8))
                                : Image.asset(imageToShow.toString()).animate(target: isDone ? 1 : 0).shake(hz: 8, curve: Curves.easeInOutCubic).scale(begin: Offset(1, 1), end: Offset(0.8, 0.8)),
                            ),
                          ),
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

  void checkAns(String s) {
    if (imageToShow.contains("blue") && imageToShow.contains(s)) {
      print("Correct");
      setState(() {
        isDone = false;
        correct++;
        ClsSound.playSound(SOUNDTYPE.Correct);
      });
      preImage = imageToShow;
      initGame();
      Future.delayed(Duration(milliseconds: 200), () {
        setState(() {
          isDone = true;
        });
      });
    } else if (imageToShow.contains("red") && !imageToShow.contains(s)) {
      print("Correct");
      setState(() {
        isDone = false;
        correct++;
        ClsSound.playSound(SOUNDTYPE.Correct);
      });
      preImage = imageToShow;
      initGame();
      Future.delayed(Duration(milliseconds: 200), () {
        setState(() {
          isDone = true;
        });
      });
    } else {
      print(" In Correct");
      setState(() {
        isDone = false;
        isWrong = false;
        incorrect++;
      });
      Future.delayed(Duration(milliseconds: 200), () {
        setState(() {
          isDone = true;
          isWrong = true;
        });
      });
      Vibration.vibrate(duration: 300);
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    countDownTimer?.cancel();
    ClsSound.stopTikTik();
    _animationController?.stop();
    super.dispose();
  }

  CountdownTimer? countDownTimer;

  startTime() async {
    countDownTimer = CountdownTimer(
      Duration(seconds: widget.gameModel.playTimeSec),
      const Duration(seconds: 1),
    );

    var sub = countDownTimer!.listen(null);
    sub.onData((duration) {
      setState(() {
        _current = widget.gameModel.playTimeSec - duration.elapsed.inSeconds;

        if (_current == 6) {
          ClsSound.playTikTik();
        }
        if (_current < 6) {
          isAnimation = true;
        }
      });
    });

    sub.onDone(() {
      ResultInfo resultInfo = ResultInfo(no_of_que: correct + incorrect, correct: correct, incorrect: incorrect);
      sub.cancel();
      goto(resultInfo);
    });
  }

  goto(ResultInfo resultInfo) async {
    List temp = (session.read(KEY.KEY_Unlock) ?? [1]);
    temp.add(gameModelList[4].gameId);
    session.write(KEY.KEY_Unlock, temp);

    int sum = (session.read(KEY.KEY_TotalCompleteLevel) ?? 0) + 1;
    session.write(KEY.KEY_TotalCompleteLevel, sum);

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) =>
        ResultPage(
          resultInfo: resultInfo,
          gameModel: widget.gameModel,
          nextLevelTap: () {
            session.write(KEY.KEY_Timer, 0);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return TipsScreen(gameModel: gameModelList[4]);
            }));
          },
        )));
  }
}

String fickerImage = "assets/ficker";

var listImagesNotFound = [
  "$fickerImage/blue_left.png",
  "$fickerImage/blue_down.png",
  "$fickerImage/blue_right.png",
  "$fickerImage/blue_up.png",
  "$fickerImage/red_left.png",
  "$fickerImage/red_down.png",
  "$fickerImage/red_right.png",
  "$fickerImage/red_up.png"
];

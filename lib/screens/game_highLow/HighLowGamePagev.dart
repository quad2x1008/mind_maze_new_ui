import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mind_maze/main.dart';
import 'package:mind_maze/screens/GameModel.dart';
import 'package:mind_maze/screens/TipsScreen.dart';
import 'package:quiver/async.dart';
import 'package:vibration/vibration.dart';
import '../../common/ClsSound.dart';
import '../../common/Common.dart';
import '../../common/Key.dart';
import '../../constants.dart';
import '../ResultPage.dart';
import '../TimerTitle.dart';
import '../game_operations/LiveScorePoint.dart';

class HighLowGamePage extends StatefulWidget {
  GameModel gameModel;

  HighLowGamePage({required this.gameModel});

  @override
  State<HighLowGamePage> createState() => _HighLowGamePageState();
}

class _HighLowGamePageState extends State<HighLowGamePage> with TickerProviderStateMixin {
  int oldNum = Random().nextInt(99) + 1;
  int currentNum = Random().nextInt(99) + 1;
  bool isNew = true;
  bool isStart = true;
  bool isUp = true;
  bool isDown = true;
  bool isWrong = true;
  int correct = 0;
  int incorrect = 0;
  int _current = 30;

  late AnimationController _animationController;
  bool isAnimation = false, isStart1 = true;
  bool isDetact = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationController.repeat(reverse: true);
  }

  initGame() {
    if (currentNum == oldNum) {
      do {
        currentNum = Random().nextInt(99) + 1;
      } while (currentNum == oldNum);
    }
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isNew = false;
      });
    });
  }

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
                  child: Icon(Icons.chevron_left, size: 30.r, color: primaryColor),
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: isStart1?Container(
                    alignment: Alignment.center,
                    child: DefaultTextStyle(
                      style:  TextStyle(fontSize: 70.0.sp, color: white),
                      child: AnimatedTextKit(
                        isRepeatingAnimation: false,
                        onFinished: () {
                          setState(() {
                            isStart1 = false;
                            initGame();
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
                      isNew
                          ? Container(
                          alignment: Alignment.center,
                          child: Card(
                            color: bgColor,
                            elevation: 6,
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              height: 150.w,
                              width: 150.w,
                              child: Text('${oldNum}', style: TextStyle(color: primaryColor, fontSize: 40.sp, fontWeight: FontWeight.bold)),
                            ),
                          )
                      ).animate(target: isStart ? 1 : 0).slide(duration: 200.ms, begin: Offset(-1, 0), end: Offset.zero).slide(delay: 1500.ms, duration: 200.ms, begin: Offset.zero, end: Offset(1, 0))
                          : Container(
                        alignment: Alignment.center,
                        child: Listener(
                          onPointerDown: (point) {
                            ClsSound.playSound(SOUNDTYPE.Tap);
                            print(point.position);
                          },
                          onPointerMove: (details) {
                            if (!isDetact) {
                              if (details.delta.dy > 0) {
                                isDetact = true;
                                print("down");
                                checkAns('down');
                              }
                              // Swiping in left direction.
                              if (details.delta.dy < 0) {
                                print("up");
                                isDetact = true;
                                checkAns('up');
                              }
                            }
                          },
                          onPointerUp: (details) {
                            isDetact = false;
                          },
                          child: Card(
                            color: bgColor,
                            elevation: 6,
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              height: 150.w,
                              width: 150.w,
                              child: Text('${currentNum}', style: TextStyle(color: primaryColor, fontSize: 40.sp, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ).animate(target: isStart ? 1 : 0).slideX(duration: 100.ms, begin: -1, end: 0)
                          .animate(target: isUp ? 1 : 0).slideY(duration: 200.ms, begin: 0, end: 1)
                          .animate(target: isDown ? 1 : 0).slideY(duration: 200.ms, begin: 0, end: -1)
                          .animate(target: isWrong ? 1 : 0).shake(hz: 8, curve: Curves.easeInOutCubic)
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
    if (s == "up" && oldNum < currentNum) {
      print('num1 = $oldNum , num2 = $currentNum, Largest number is $oldNum');
      setState(() {
        oldNum = currentNum;
        isUp = false;
        correct++;
        ClsSound.playSound(SOUNDTYPE.Correct);
      });
      Future.delayed(Duration(milliseconds: 200), () {
        setState(() {
          isUp = true;
          getnewNumber();
        });
      });
    } else if (s == "down" && oldNum > currentNum) {
      print('num1 = $oldNum , num2 = $currentNum, Largest number is $currentNum');
      setState(() {
        oldNum = currentNum;
        changeDown();
        correct++;
        ClsSound.playSound(SOUNDTYPE.Correct);
      });
      Future.delayed(Duration(milliseconds: 200), () {
        setState(() {
          changeDown();
          getnewNumber();
        });
      });
    } else {
      print('num1 = $oldNum , num2 = $currentNum, Largest number is $currentNum');
      setState(() {
        changeWrong();
        incorrect++;
        Vibration.vibrate(duration: 300);
      });
      Future.delayed(200.ms, () {
        changeWrong();
        setState(() {});
      });
      print('Wrong');
    }
  }

  void getnewNumber() {
    do {
      currentNum = Random().nextInt(99) + 1;
    } while (currentNum == oldNum);
    setState(() {
      isStart = false;
    });
    Future.delayed(200.ms, () {
      setState(() {
        isStart = true;
      });
    });
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
        if (_current < 6) {
          isAnimation = true;
        }
      });
    });

    sub.onDone(() {
      ResultInfo resultInfo = ResultInfo(no_of_que: correct + incorrect, correct: correct, incorrect: incorrect);
      sub.cancel();
      route(resultInfo);
    });
  }

  route(ResultInfo resultInfo) {
    List temp = (session.read(KEY.KEY_Unlock) ?? [1]);
    temp.add(gameModelList[6].gameId);
    session.write(KEY.KEY_Unlock, temp);

    int sum = (session.read(KEY.KEY_TotalCompleteLevel) ?? 0) + 1;
    session.write(KEY.KEY_TotalCompleteLevel, sum);

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) =>
        ResultPage(
          resultInfo: resultInfo,
          gameModel: widget.gameModel,
          nextLevelTap: () {
            session.write(KEY.KEY_Unlock, 0);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return TipsScreen(gameModel: gameModelList[6]);
            }));
          },
        )));
  }

  changeDown() {
    isDown = !isDown;
  }

  changeWrong() {
    isWrong = !isWrong;
  }
}

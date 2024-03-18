import 'dart:async';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
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

class ColorSenseScreen extends StatefulWidget {
  GameModel gameModel;

  ColorSenseScreen({required this.gameModel});

  @override
  State<ColorSenseScreen> createState() => _ColorSenseScreenState();
}

class _ColorSenseScreenState extends State<ColorSenseScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool isAnimation = false, isStart = true, isWrong = true;
  Timer? timer;
  int correct = 0;
  int incorrect = 0;
  int _current = 30;
  int count = 0;

  Map<String, Color> colorMapList = {
    "Red": Colors.red,
    "Yellow": Colors.amber,
    "Blue": Colors.blue,
    "Green": Colors.green,
    "Brown": Colors.brown,
    "Purple": Colors.deepPurpleAccent,
    "Orange": Colors.orange,
    "White": Colors.white,
  };
  int number = 1;
  bool timerStatus = false;
  List<Color> colorList = [];
  int answerNo = 0;
  int questionNo = 0;
  List questionList = ["Tap The", "Don't Tap The"];
  List<bool> shakeList = [];
  bool clickStatus = false;

  initGame() {
    clickStatus = true;
    timerStatus = true;
    colorList = [];
    answerNo = Random().nextInt(8);
    questionNo = Random().nextInt(2);
    colorList.add(colorMapList.values.toList()[answerNo]);

    List temp = colorMapList.values.toList();
    temp.shuffle();
    for (int i = 0; i < temp.length; i++) {
      if (colorList.length < 3) {
        if (!colorList.contains(temp[i])) {
          colorList.add(temp[i]);
        }
      } else {
        break;
      }
    }
    shakeList = List.filled(colorList.length, false);
    colorList.shuffle();
    setState(() {});
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
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${questionList[questionNo]} ",
                                style: TextStyle(color: txtColor.withOpacity(0.8), fontSize: 22.r),
                              ),
                              Text("${colorMapList.keys.toList()[answerNo]} ".toUpperCase(),
                                style: TextStyle(color: colorList[Random().nextInt(3)], fontSize: 25.r),
                              ),
                              Text("Button", style: TextStyle(color: txtColor.withOpacity(0.8), fontSize: 22.r)),
                            ],
                          ),
                          SizedBox(height: 50.r),
                          Container(
                            width: 180.r,
                            child: Center(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: colorList.length,
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      ClsSound.playSound(SOUNDTYPE.Tap);
                                      if (clickStatus) {
                                        clickStatus = false;
                                        if (questionNo == 0) {
                                          if (colorList[index] == colorMapList.values.toList()[answerNo]) {
                                            initGame();
                                            setState(() {
                                              print("==> correct ${correct++}");
                                              ClsSound.playSound(SOUNDTYPE.Correct);
                                            });
                                          } else {
                                            shakeList[index] = true;
                                            setState(() {});
                                            await Future.delayed(Duration(milliseconds: 800));
                                            shakeList[index] = false;
                                            setState(() {});
                                            isWrong = false;
                                            initGame();
                                            print("==> incorrect ${incorrect++}");
                                            Vibration.vibrate(duration: 300);
                                            Future.delayed(200.ms, () {
                                              isWrong = !isWrong;
                                              setState(() {});
                                            });
                                            print("Game Over");
                                          }
                                        } else {
                                          if (colorList[index] != colorMapList.values.toList()[answerNo]) {
                                            initGame();
                                            setState(() {
                                              print("==> correct ${correct++}");
                                              ClsSound.playSound(SOUNDTYPE.Correct);
                                            });
                                          } else {
                                            shakeList[index] = true;
                                            setState(() {});
                                            await Future.delayed(Duration(milliseconds: 800));
                                            shakeList[index] = false;
                                            setState(() {});
                                            isWrong = false;
                                            initGame();
                                            print("==> incorrect ${incorrect++}");
                                            Vibration.vibrate(duration: 300);
                                            Future.delayed(200.ms, () {
                                              isWrong = !isWrong;
                                              setState(() {});
                                            });
                                            print("Game Over");
                                          }
                                        }
                                      }
                                    },
                                    child: ShakeWidget(
                                      autoPlay: shakeList[index],
                                      shakeConstant: ShakeDefaultConstant1(),
                                      child: Container(
                                        height: 60.r,
                                        margin: EdgeInsets.all(5.r),
                                        decoration: BoxDecoration(color: colorList[index], borderRadius: BorderRadius.circular(10.r)),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
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

  CountdownTimer? countDownTimer;

  @override
  void initState() {
    super.initState();
    initGame();
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
    temp.add(gameModelList[21].gameId);
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
              return TipsScreen(gameModel: gameModelList[21]);
            }));
          },
        )));
  }
}

import 'dart:async';
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

class ChromaShapesScreen extends StatefulWidget {
  GameModel gameModel;

  ChromaShapesScreen({required this.gameModel});

  @override
  State<ChromaShapesScreen> createState() => _ChromaShapesScreenState();
}

class _ChromaShapesScreenState extends State<ChromaShapesScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool isAnimation = false, isStart = true, isWrong = true;
  Timer? timer;
  int correct = 0;
  int incorrect = 0;
  int _current = 30;
  int count = 0;

  Map<String, IconData> iconList = {"CIRCLE": Icons.circle_outlined, "SQUARE": Icons.square_outlined};
  Map<String, Color> colorsList = {"green": Colors.green, "blue": Colors.blue, "red": Colors.red, "white": Colors.white, "purple": Colors.purple, "orange": Colors.orange};
  int num = 0, number = 0, numcolor = 0, numIcon = 0, or = 0, nor = 0;
  List<String> colorKeys = [], shapeKeys = [];
  Random random = Random();
  late String text;
  late IconData iconData;
  late Color color;
  bool isTrue = Random().nextBool();
  bool isAnimation1 = true;
  bool isStart1 = true, isEnd = true, isWrong1 = true;
  bool _canShowIcon = true;
  bool timer1 = false;
  double progress = 0;
  late AnimationController _animationController1;
  bool clickStatus = false;

  Future<void> initGame() async {
    setState(() {
      _canShowIcon = false;
      clickStatus = true;
      timer1 = true;
      isStart1 = false;
      isTrue = random.nextBool();
      colorKeys = colorsList.keys.toList();
      shapeKeys = iconList.keys.toList();
      colorKeys.shuffle();
      shapeKeys.shuffle();
      numcolor = random.nextInt(colorsList.length);
      color = colorsList[colorKeys[numcolor]]!;
      numIcon = random.nextInt(iconList.length);
      iconData = iconList[shapeKeys[numIcon]]!;
      or = random.nextInt(colorsList.length);
      nor = random.nextInt(iconList.length);
      text = "It's a ${colorKeys[numcolor]} ${shapeKeys[numIcon]}";
      num = numcolor;
      print("$text, $numcolor, $numIcon");
      number++;

      if (isTrue) {
        if (random.nextBool() == true) {
          if (number > 10) {
            if (numcolor == or || numIcon == nor) {
              do {
                or = random.nextInt(colorsList.length);
                nor = random.nextInt(iconList.length);
              } while (numcolor == or || numIcon == nor);
            }
            text = "It's a ${colorKeys[numcolor]} ${shapeKeys[numIcon]} or a ${colorKeys[or]} ${shapeKeys[nor]}";
            print("isTrue1 $numcolor, $numIcon or a $or, $nor");
          } else {
            text = "It's a ${colorKeys[numcolor]} ${shapeKeys[numIcon]}";
            print("isTrue , $numcolor , $numIcon");
          }
        } else {
          numcolor = random.nextInt(colorsList.length);
          numIcon = random.nextInt(iconList.length);
          or = random.nextInt(colorsList.length);
          nor = random.nextInt(iconList.length);
          if (number > 10) {
            if (numcolor == num || iconData == iconList[numIcon]) {
              do {
                numcolor = random.nextInt(colorsList.length);
                numIcon = random.nextInt(iconList.length);
              } while (numcolor == num || iconData == iconList[numIcon]);
            }
            if (numcolor == or || numIcon == nor) {
              do {
                or = random.nextInt(colorsList.length);
                nor = random.nextInt(iconList.length);
              } while (numcolor == or || numIcon == nor);
            }
            text = "It's not a ${colorKeys[numcolor]} ${shapeKeys[numIcon]} neither a ${colorKeys[or]} ${shapeKeys[nor]}";
            print("isTrue1 not $numcolor, $numIcon neither a $or, $nor");
          } else {
            if (numcolor == num || iconData == iconList[numIcon]) {
              do {
                numcolor = random.nextInt(colorsList.length);
                numIcon = random.nextInt(iconList.length);
              } while (numcolor == num || iconData == iconList[numIcon]);
            }
            text = "It's not a ${colorKeys[numcolor]} ${shapeKeys[numIcon]}";
            print("isTrue not $numcolor, $numIcon");
          }
        }
      }
      else if (!isTrue) {
        if (random.nextBool() == true) {
          if (number > 10) {
            if (numcolor == num || iconData == iconList[numIcon]) {
              do {
                numcolor = random.nextInt(colorsList.length);
                numIcon = random.nextInt(iconList.length);
              } while (numcolor == num || iconData == iconList[numIcon]);
            }
            if (numcolor == or || numIcon == nor) {
              do {
                or = random.nextInt(colorsList.length);
                nor = random.nextInt(iconList.length);
              } while (numcolor == or || numIcon == nor);
            }
            text = "It's a ${colorKeys[numcolor]} ${shapeKeys[numIcon]} or a ${colorKeys[or]} ${shapeKeys[nor]}";
            print("isWrong or, $numcolor, $numIcon");
          } else {
            numcolor = random.nextInt(colorsList.length);
            numIcon = random.nextInt(iconList.length);
            if (num == numcolor || iconData == iconList[numIcon]) {
              do {
                numcolor = random.nextInt(colorsList.length);
                numIcon = random.nextInt(iconList.length);
              } while (num == numcolor || iconData == iconList[numIcon]);
            }
            text = "It's a ${colorKeys[numcolor]} ${shapeKeys[numIcon]}";
            print("isWrong, $numcolor, $numIcon");
          }
        } else {
          or = random.nextInt(colorsList.length);
          nor = random.nextInt(iconList.length);
          if (number > 10) {
            if (numcolor == or || numIcon == nor) {
              do {
                or = random.nextInt(colorsList.length);
                nor = random.nextInt(iconList.length);
              } while (numcolor == or || numIcon == nor);
            }
            text = "It's not a ${colorKeys[numcolor]} ${shapeKeys[numIcon]} neither a ${colorKeys[or]} ${shapeKeys[nor]}";
            print("isWrong1 not $numcolor, $numIcon neither a $or, $nor");
          } else {
            text = "It's not a ${colorKeys[numcolor]} ${shapeKeys[numIcon]}";
            print("isWrong not, $numcolor, $numIcon");
          }
        }
      }
    });

    Future.delayed(Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          isStart1 = true;
        });
      }
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
        _animationController1.dispose();
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
                  _animationController1.dispose();
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
                      padding: EdgeInsets.only(top: 150.r),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10.r),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10.r),
                                  child: Text(text, textAlign: TextAlign.center, style: TextStyle(color: txtColor, fontSize: 20.r)),
                                ),
                                SizedBox(height: 10.r),
                                Stack(
                                  fit: StackFit.loose,
                                  children: [
                                    Icon(iconData, color: color, size: 120.r).animate(target: isWrong1 ? 1 : 0).shimmer(duration: 200.ms).shake(hz: 8, curve: Curves.easeInOutCubic),
                                    Visibility(visible: _canShowIcon, child: Positioned(left: 0, right: 0, top: 0, bottom: 0, child: Icon(Icons.clear_rounded, color: Colors.red, size: 100.r).animate(target: isAnimation1 ? 1 : 0).fadeIn(curve: Curves.easeOut).scale(begin: Offset(0.5, 0)))),
                                  ],
                                ),
                              ],
                            ).animate(target: isStart1 ? 1 : 0).slide(duration: 200.ms, begin: Offset(2.0, 0.0), end: Offset.zero).animate(target: isEnd ? 1 : 0).slide(duration: 200.ms, begin: Offset(-1, 0), end: Offset.zero),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 100.r),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    ClsSound.playSound(SOUNDTYPE.Tap);
                                    if (clickStatus) {
                                      clickStatus = false;
                                      setState(() {});
                                      if (!isTrue) {
                                        setState(() {
                                          isEnd = true;
                                          initGame();
                                          setState(() {
                                            print("==> correct ${correct++}");
                                            ClsSound.playSound(SOUNDTYPE.Correct);
                                          });
                                        });
                                        print("Right");
                                      } else {
                                        setState(() {
                                          isAnimation1 = true;
                                          _canShowIcon = true;
                                          timer1 = false;
                                          isWrong1 = false;
                                          isWrong = false;
                                          initGame();
                                          print("==> incorrect ${incorrect++}");
                                          Vibration.vibrate(duration: 300);
                                          Future.delayed(200.ms, () {
                                            isWrong = !isWrong;
                                            setState(() {});
                                          });
                                          print("wrong");
                                        });
                                      }
                                    }
                                  },
                                  child: roundButton(Icons.close_rounded, Colors.red),
                                ),
                                SizedBox(width: 50.r),
                                GestureDetector(
                                  onTap: () {
                                    ClsSound.playSound(SOUNDTYPE.Tap);
                                    if (clickStatus) {
                                      clickStatus = false;
                                      setState(() {});
                                      if (isTrue) {
                                        setState(() {
                                          isEnd = true;
                                          initGame();
                                          setState(() {
                                            print("==> correct ${correct++}");
                                            ClsSound.playSound(SOUNDTYPE.Correct);
                                          });
                                        });
                                        print("Right");
                                      } else {
                                        setState(() {
                                          isAnimation1 = true;
                                          _canShowIcon = true;
                                          timer1 = false;
                                          isWrong1 = false;
                                          isWrong = false;
                                          initGame();
                                          print("==> incorrect ${incorrect++}");
                                          Vibration.vibrate(duration: 300);
                                          Future.delayed(200.ms, () {
                                            isWrong = !isWrong;
                                            setState(() {});
                                          });
                                          print("wrong");
                                        });
                                      }
                                    }
                                  },
                                  child: roundButton(Icons.check_rounded, Colors.green),
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
    _animationController1 = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _animationController1.repeat(reverse: true);
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
    _animationController1.dispose();
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
    temp.add(gameModelList[20].gameId);
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
              return TipsScreen(gameModel: gameModelList[20]);
            }));
          },
        )));
  }

  roundButton(IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: txtColor.withOpacity(0.8), width: 3.r)),
      child: Container(
        margin: EdgeInsets.all(5.r),
        decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xff454B61)),
        padding: EdgeInsets.all(2.r),
        child: Center(
          child: Icon(icon, color: color, size: 50.r),
        ),
      ),
    );
  }
}

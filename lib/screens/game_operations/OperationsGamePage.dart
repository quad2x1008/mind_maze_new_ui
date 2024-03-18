import 'dart:async';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mind_maze/common/ClsSound.dart';
import 'package:mind_maze/common/Common.dart';
import 'package:mind_maze/common/Key.dart';
import 'package:mind_maze/constants.dart';
import 'package:mind_maze/main.dart';
import 'package:mind_maze/screens/GameModel.dart';
import 'package:mind_maze/screens/ResultPage.dart';
import 'package:mind_maze/screens/TipsScreen.dart';
import 'package:quiver/async.dart';
import 'package:vibration/vibration.dart';
import '../../QuizBrain.dart';
import '../TimerTitle.dart';
import 'LiveScorePoint.dart';

class OperationsGamePage extends StatefulWidget {
  GameModel gameModel;

  OperationsGamePage({required this.gameModel});

  @override
  State<OperationsGamePage> createState() => _OperationsGamePageState();
}

class _OperationsGamePageState extends State<OperationsGamePage> with SingleTickerProviderStateMixin {
  List<Question>? listQue = [];
  bool isAnimation = false, isStart = true, isWrong = false;
  List<int> timeList = [];
  Timer? timer;
  Question? question;
  int? num1, num2, ans;

  int correct = 0;
  int incorrect = 0;
  int _current = 30;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    startGame();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationController.repeat(reverse: true);
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  void startGame() {
    timeList.add(_current);
    question = getQuestion();
    num1 = question!.num1;
    num2 = question!.num2;
    ans = question!.answer;
  }

  Color sum = primaryColor, sub = primaryColor, div = primaryColor, mul = primaryColor;

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
            actions: [
              LiveScorePoint(correct,incorrect,_current,widget.gameModel.playTimeSec),
            ],
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
                      visible: isWrong,
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
                              )
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
                                )
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
                              )
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
                          )
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(" $num1 ", style: TextStyle(color: white, fontSize: 40.sp)),
                            Image.asset("assets/shapes/8.png", color: white, height: 40.h, width: 40.h),
                            Text(" $num2 ", style: TextStyle(color: white, fontSize: 40.sp)),
                            Text(" = ", style: TextStyle(color: white, fontSize: 40.sp)),
                            Text(" $ans", style: TextStyle(color: white, fontSize: 40.sp)),
                          ],
                        ),
                        SizedBox(height: 30.h),
                        Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                          Bounce(
                            duration: Duration(milliseconds: 200),
                            onPressed: () {
                              ClsSound.playSound(SOUNDTYPE.Tap);
                              if (question!.operator == '+' || ans == (num1! + num2!)) {
                                setState(() {
                                  startGame();
                                  question!.isDone = true;
                                  listQue!.add(question!);
                                  correct++;
                                  ClsSound.playSound(SOUNDTYPE.Correct);
                                  sum = Colors.green;
                                });
                                Future.delayed(Duration(milliseconds: 200), () {
                                  print(listQue!.length);
                                  setState(() {
                                    sum = primaryColor;
                                  });
                                });
                              } else {
                                setState(() {
                                  question!.isDone = false;
                                  sum = Colors.red;
                                  incorrect++;
                                  changeWrong();
                                  Vibration.vibrate(duration: 300);
                                });
                                Future.delayed(Duration(milliseconds: 200), () {
                                  print(listQue!.length);
                                  setState(() {
                                    sum = primaryColor;
                                    changeWrong();
                                  });
                                });
                              }
                            },
                            child: Card(
                              color: bgColor,
                              elevation: 3,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                              child: Center(
                                child: Image.asset("assets/shapes/plus.png", color: sum, height: 95.h, width: 95.h),
                              ),
                            ),
                          ),
                          Bounce(
                            duration: Duration(milliseconds: 200),
                            onPressed: () {
                              ClsSound.playSound(SOUNDTYPE.Tap);
                              if (question!.operator == '-' || ans == (num1! - num2!)) {
                                setState(() {
                                  startGame();
                                  sub = Colors.green;
                                  question!.isDone = true;
                                  listQue!.add(question!);
                                  correct++;
                                  ClsSound.playSound(SOUNDTYPE.Correct);
                                });
                                Future.delayed(Duration(milliseconds: 200), () {
                                  print(listQue!.length);
                                  setState(() {
                                    sub = primaryColor;
                                  });
                                });
                              } else {
                                setState(() {
                                  question!.isDone = false;
                                  sub = Colors.red;
                                  incorrect++;
                                  changeWrong();
                                  Vibration.vibrate(duration: 300);
                                });
                                Future.delayed(Duration(milliseconds: 200), () {
                                  print(listQue!.length);
                                  setState(() {
                                    sub = primaryColor;
                                    changeWrong();
                                  });
                                });
                              }
                            },
                            child: Card(
                              color: bgColor,
                              elevation: 3,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                              child: Center(
                                child: Image.asset("assets/shapes/minus.png", color: sub, height: 95.h, width: 95.h),
                              ),
                            ),
                          )
                        ]),
                        Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                          Bounce(
                            duration: Duration(milliseconds: 200),
                            onPressed: () {
                              ClsSound.playSound(SOUNDTYPE.Tap);
                              if (question!.operator == '*' || ans == (num1! * num2!)) {
                                setState(() {
                                  startGame();
                                  question!.isDone = true;
                                  listQue!.add(question!);
                                  mul = Colors.green;
                                  correct++;
                                  ClsSound.playSound(SOUNDTYPE.Correct);
                                });
                                Future.delayed(Duration(milliseconds: 200), () {
                                  print(listQue!.length);
                                  setState(() {
                                    mul = primaryColor;
                                  });
                                });
                              } else {
                                setState(() {
                                  mul = Colors.red;
                                  question!.isDone = false;
                                  incorrect++;
                                  changeWrong();
                                  Vibration.vibrate(duration: 300);
                                });
                                Future.delayed(Duration(milliseconds: 200), () {
                                  print(listQue!.length);
                                  setState(() {
                                    mul = primaryColor;
                                    changeWrong();
                                  });
                                });
                              }
                            },
                            child: Card(
                              color: bgColor,
                              elevation: 3,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                              child: Center(
                                child: Image.asset("assets/shapes/close.png", color: mul, height: 95.h, width: 95.h),
                              ),
                            ),
                          ),
                          Bounce(
                            duration: Duration(milliseconds: 200),
                            onPressed: () {
                              ClsSound.playSound(SOUNDTYPE.Tap);
                              if (question!.operator == "/" || ans == (num1! ~/ num2!)) {
                                setState(() {
                                  startGame();
                                  question!.isDone = true;
                                  listQue!.add(question!);
                                  div = Colors.green;
                                  correct++;
                                  ClsSound.playSound(SOUNDTYPE.Correct);
                                });
                                Future.delayed(Duration(milliseconds: 200), () {
                                  print(listQue!.length);
                                  setState(() {
                                    div = primaryColor;
                                  });
                                });
                              } else {
                                setState(() {
                                  question!.isDone = false;
                                  div = Colors.red;
                                  incorrect++;
                                  changeWrong();
                                  Vibration.vibrate(duration: 300);
                                });
                                Future.delayed(Duration(milliseconds: 200), () {
                                  print(listQue!.length);
                                  setState(() {
                                    div = primaryColor;
                                    changeWrong();
                                  });
                                });
                              }
                            },
                            child: Card(
                              color: bgColor,
                              elevation: 6,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                              child: Center(
                                child: Image.asset("assets/shapes/divide.png", color: div, height: 95.h, width: 95.h),
                              ),
                            ),
                          )
                        ]),
                      ],
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

  Question getQuestion() {
    String selectedSign;
    int num1;
    int num2;
    int? result;

    List<String> _listOfSigns = ['+', '-', '*', '/'];
    Random random = Random();
    selectedSign = _listOfSigns[random.nextInt(_listOfSigns.length)];
    num1 = random.nextInt(20);
    num2 = random.nextInt(20);

    switch (selectedSign) {
      case '+':
        if(num1 == 0 && num2 == 0) {
          do {
            num1 = Random().nextInt(20);
            num2 = Random().nextInt(20);
          } while(num1 == 0 && num2 == 0);
        }
        result = num1 + num2;
        break;
      case '-':
        {
          if(num1 < num2) {
            do {
              num2 = random.nextInt(20);
            } while(num2 > num1);
          } else if(num1 == 0 && num2 == 0) {
            do {
              num1 = Random().nextInt(20);
              num2 = Random().nextInt(20);
            } while(num1 == 0 && num2 == 0);
          }
          result = num1 - num2;
        }
        break;
      case '*':
        if(num1 == 0 && num2 == 0) {
          do {
            num1 = Random().nextInt(20);
            num2 = Random().nextInt(20);
          } while(num1 == 0 && num2 == 0);
        }
        result = num1 * num2;
        break;
      case '/':
        {
          if(num1 == 0) {
            do {
              num1 = Random().nextInt(20);
            } while(num1 == 0);
          }
          do {
            num2 = Random().nextInt(20);
          } while(num2 == 0);

          if((num1 % num2) != 0) {
            do {
              num2 = random.nextInt(9) + 1;
              if(num2 != 0 && (num1 % num2) != 0) {
                num2 = 0;
              }
            } while(num2 == 0);
          }
          result = num1 ~/ num2;
        }
    }

    Question Q = Question(num1: num1, num2: num2, operator: selectedSign, answer: result, isDone: false);
    print("$num1 $num2 $selectedSign");
    return Q;
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

        if(_current==6){
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
      goto(resultInfo);
    });
  }

  goto(ResultInfo resultInfo) async {
    List temp = (session.read(KEY.KEY_Unlock) ?? [1]);
    temp.add(gameModelList[1].gameId);
    session.write(KEY.KEY_Unlock, temp);

    int sum = (session.read(KEY.KEY_TotalCompleteLevel) ?? 0) + 1;
    session.write(KEY.KEY_TotalCompleteLevel, sum);

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) =>
        ResultPage(
          gameModel: widget.gameModel,
          resultInfo: resultInfo,
          nextLevelTap: () {
            session.write(KEY.KEY_Timer, 0);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return TipsScreen(gameModel: gameModelList[1]);
            }));
          },
        ))).then((value) {
          return null;
        });
  }

  changeWrong() {
    isWrong = !isWrong;
  }
}





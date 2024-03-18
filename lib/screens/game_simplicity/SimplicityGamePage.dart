import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mind_maze/common/Key.dart';
import 'package:mind_maze/main.dart';
import 'package:mind_maze/screens/GameModel.dart';
import 'package:mind_maze/screens/TipsScreen.dart';
import 'package:quiver/async.dart';
import 'package:vibration/vibration.dart';
import '../../QuizBrain.dart';
import '../../common/ClsSound.dart';
import '../../common/Common.dart';
import '../../constants.dart';
import '../ResultPage.dart';
import '../TimerTitle.dart';
import '../game_operations/LiveScorePoint.dart';

class SimplicityGamePage extends StatefulWidget {
  GameModel gameModel;

  SimplicityGamePage({required this.gameModel});

  @override
  State<SimplicityGamePage> createState() => _SimplicityGamePageState();
}

class _SimplicityGamePageState extends State<SimplicityGamePage> with SingleTickerProviderStateMixin {
  List<SimQuestion>? listQue = [];
  bool isAnimation = false, isStart = true, isWrong = false;
  SimQuestion? question;
  int? ans;
  String? que;
  List<int>? options;

  int count = 0;
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

  void startGame() {
    question = getQuestion(count++);
    que = question!.que;
    options = question!.option;
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
            actions: [
              LiveScorePoint(correct,incorrect,_current,widget.gameModel.playTimeSec),
            ],
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
                child: isStart?Container(
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
                          ScaleAnimatedText('3',duration: 500.ms),
                          ScaleAnimatedText('2',duration: 500.ms),
                          ScaleAnimatedText('1',duration: 500.ms),
                        ],
                      ),
                    ),
                  ): Stack(
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
                          Center(child: Text(" $que", style: TextStyle(color: white, fontSize: 40.sp))),
                          SizedBox(height: 30.h),
                          Bounce(
                            duration: Duration(milliseconds: 200),
                              onPressed: () {
                                ClsSound.playSound(SOUNDTYPE.Tap);
                                if (ans == options![0]) {
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
                                    Vibration.vibrate(duration: 300);
                                    changeWrong();
                                    sum = Colors.red;
                                    incorrect++;
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
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 100.0),
                                child: SizedBox(
                                  height: 60,
                                  width: 200,
                                  child: Card(
                                    color: bgColor,
                                    elevation: 3,
                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                    child: Center(
                                      child: Text(options![0].toString(), style: TextStyle(color: sum, fontSize: 30.sp)),
                                    ),
                                  ),
                                ),
                              ),
                          ),
                          Bounce(
                            duration: Duration(milliseconds: 200),
                            onPressed: () {
                              ClsSound.playSound(SOUNDTYPE.Tap);
                              if (ans == options![1]) {
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
                                  Vibration.vibrate(duration: 300);
                                  changeWrong();
                                  sub = Colors.red;
                                  incorrect++;
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
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 0, horizontal: 100.0),
                              child: SizedBox(
                                height: 60,
                                width: 200,
                                child: Card(
                                  color: bgColor,
                                  elevation: 3,
                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                  child: Center(
                                    child: Text(options![1].toString(), style: TextStyle(color: sub, fontSize: 30.sp)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Bounce(
                            duration: Duration(milliseconds: 200),
                            onPressed: () {
                              ClsSound.playSound(SOUNDTYPE.Tap);
                              if (ans == options![2]) {
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
                                  Vibration.vibrate(duration: 300);
                                  changeWrong();
                                  incorrect++;
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
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 0, horizontal: 100.0),
                              child: SizedBox(
                                height: 60,
                                width: 200,
                                child: Card(
                                  color: bgColor,
                                  elevation: 3,
                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                  child: Center(
                                    child: Text(options![2].toString(), style: TextStyle(color: mul, fontSize: 30.sp)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Bounce(
                              duration: Duration(milliseconds: 200),
                              onPressed: () {
                                ClsSound.playSound(SOUNDTYPE.Tap);
                                if (ans == options![3]) {
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
                                    Vibration.vibrate(duration: 300);
                                    changeWrong();
                                    div = Colors.red;
                                    incorrect++;
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
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 100.0),
                                child: SizedBox(
                                  height: 60,
                                  width: 200,
                                  child: Card(
                                    color: bgColor,
                                    elevation: 6,
                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                    child: Center(
                                      child: Text(options![3].toString(), style: TextStyle(color: div, fontSize: 30.sp)),
                                    ),
                                  ),
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
    );
  }

  int nextIntRange(int min, int max) => min + Random().nextInt((max + 1) - min);

  SimQuestion getQuestion(int count) {
    String selectedSign;
    int num1;
    int num2;
    int num3;
    int no_of_num;
    int? result;
    String? que;

    List<String> _listOfSigns = ['+', '-'];
    Random random = Random();
    selectedSign = _listOfSigns[random.nextInt(_listOfSigns.length)];
    num1 = random.nextInt(9)+1;
    num2 = random.nextInt(9)+1;

    if(count>7){
      no_of_num = 1;
    }else{
      no_of_num = 0;
    }
    num3 = random.nextInt(5);

    List<int>? options = [];

    switch (no_of_num) {
      case 0:
        switch (selectedSign) {
          case '+':
            if (num1 == 0 && num2 == 0) {
              do {
                num1 = random.nextInt(10);
                num2 = random.nextInt(10);
              } while (num1 == 0 && num2 == 0);
            }
            result = num1 + num2;
            que = num1.toString() + " + " + num2.toString();
            break;
          case '-':
            {
              if (num1 == 0 && num2 == 0) {
                do {
                  num1 = random.nextInt(10);
                  num2 = random.nextInt(10);
                } while (num1 == 0 && num2 == 0);
              }
              result = num1 - num2;
              que = num1.toString() + " - " + num2.toString();
            }
            break;
        }
        break;
      case 1:
        switch (selectedSign) {
          case '+':
            {
              if (num1 == 0) {
                do {
                  num1 = random.nextInt(10);
                } while (num1 == 0);
              } else if (num2 == 0) {
                do {
                  num2 = random.nextInt(10);
                } while (num2 == 0);
              } else if (num3 == 0) {
                do {
                  num3 = random.nextInt(10);
                } while (num3 == 0);
              }
              result = num1 + num2;
              que = num1.toString() + "+" + num2.toString();
              switch (selectedSign) {
                case '+':
                  result = result + num3;
                  que = random.nextBool() ? num3.toString() + " + " + "(" + que + ")" : "(" + que + ")" + " + " + num3.toString();
                  break;
                case '-':
                  {
                    result = result - num3;
                    que = random.nextBool() ? num3.toString() + " - " + "(" + que + ")" : "(" + que + ")" + " - " + num3.toString();
                  }
                  break;
              }
            }
            break;
          case '-':
            {
              if (num1 == 0) {
                do {
                  num1 = random.nextInt(10);
                } while (num1 == 0);
              } else if (num2 == 0) {
                do {
                  num2 = random.nextInt(10);
                } while (num2 == 0);
              } else if (num3 == 0) {
                do {
                  num3 = random.nextInt(10);
                } while (num3 == 0);
              }
              result = num1 - num2;
              que = num1.toString() + "-" + num2.toString();
              switch (selectedSign) {
                case '+':
                  result = result + num3;
                  que = random.nextBool() ? num3.toString() + "+" + "(" + que + ")" : "(" + que + ")" + "+" + num3.toString();
                  break;
                case '-':
                  {
                    result = result - num3;
                    que = random.nextBool() ? num3.toString() + "-" + "(" + que + ")" : "(" + que + ")" + "-" + num3.toString();
                  }
                  break;
              }
            }
            break;
        }
        break;
    }

    int op1 = nextIntRange(result! - 5, result + 5);
    if (op1 == result) {
      do {
        op1 = nextIntRange(result - 5, result + 5);
      } while (op1 == result);
    }

    int op2 = nextIntRange(result - 10, result + 5);
    if (op2 == result || op2 == op1) {
      do {
        op2 = nextIntRange(result - 5, result + 5);
        if (op2 == op1) {
          op2 = result;
        }
      } while (op2 == result);
    }
    int op3 = nextIntRange(result - 5, result + 5);
    if (op3 == result || op3 == op1 || op3 == op2) {
      do {
        op3 = nextIntRange(result - 5, result + 5);
        if (op3 == op1) {
          op3 = result;
        }
        if (op3 == op2) {
          op3 = result;
        }
      } while (op3 == result);
    }
    options!.add(op1);
    options!.add(op2);
    options!.add(op3);
    options!.add(result);
    options!.shuffle();
    SimQuestion Q = new SimQuestion(que: que, option: options, answer: result, isDone: false);
    print("$que $result $op1 $op2 $op3");
    return Q;
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
      goto(resultInfo);
    });
  }

  goto(ResultInfo resultInfo) async {
    List temp = (session.read(KEY.KEY_Unlock) ?? [1]);
    temp.add(gameModelList[2].gameId);
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
              return TipsScreen(gameModel: gameModelList[2]);
            }));
          },
        )));
  }

  changeWrong() {
    isWrong = !isWrong;
  }
}

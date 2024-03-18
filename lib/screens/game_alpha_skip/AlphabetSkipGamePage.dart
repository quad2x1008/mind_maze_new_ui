import 'dart:async';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mind_maze/main.dart';
import 'package:mind_maze/screens/GameModel.dart';
import 'package:mind_maze/screens/TipsScreen.dart';
import 'package:quiver/async.dart';
import 'package:vibration/vibration.dart';
import '../../QuizBrain.dart';
import '../../common/ClsSound.dart';
import '../../common/Common.dart';
import '../../common/Key.dart';
import '../../constants.dart';
import '../ResultPage.dart';
import '../TimerTitle.dart';
import '../game_operations/LiveScorePoint.dart';

class AlphabetSkipGamePage extends StatefulWidget {
  GameModel gameModel;

  AlphabetSkipGamePage({required this.gameModel});

  @override
  State<AlphabetSkipGamePage> createState() => _AlphabetSkipGamePageState();
}

class _AlphabetSkipGamePageState extends State<AlphabetSkipGamePage> with TickerProviderStateMixin {
  List<AlphaQuestion>? listQue = [];
  bool isAnimation = false, isStart = true, isWrong = false;
  List<int> timeList = [];
  Timer? timer;
  AlphaQuestion? question;
  String? que, selectedAlpha, ans;
  List<String>? options;

  int correct = 0;
  int incorrect = 0, count = 0;
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
    if (mounted) {
      super.setState(fn);
    }
  }

  void startGame() {
    question = getQuestion(count++);
    que = question!.que;
    selectedAlpha = question!.selectedAlpha;
    options = question!.options;
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
      child: Stack(
        children: [
          Container(
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Text("$selectedAlpha", textAlign: TextAlign.center, style: TextStyle(color: white, fontSize: 50.sp)),
                            ),
                            Center(
                              child: Text(" $que", textAlign: TextAlign.center, style: TextStyle(color: white, fontSize: 40.sp)),
                            ),
                            SizedBox(height: 20.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                                          changeWrong();
                                          sum = primaryColor;
                                        });
                                      });
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 90.w,
                                    width: 90.w,
                                    child: Card(
                                      color: bgColor,
                                      elevation: 3,
                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                      child: Center(
                                        child: Text(options![0], style: TextStyle(color: sum, fontSize: 45.sp)),
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
                                          changeWrong();
                                          sub = primaryColor;
                                        });
                                      });
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 90.w,
                                    width: 90.w,
                                    child: Card(
                                      color: bgColor,
                                      elevation: 3,
                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                      child: Center(
                                        child: Text(options![1], style: TextStyle(color: sub, fontSize: 45.sp)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                                          changeWrong();
                                          mul = primaryColor;
                                        });
                                      });
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 90.w,
                                    width: 90.w,
                                    child: Card(
                                      color: bgColor,
                                      elevation: 3,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          options![2],
                                          style: TextStyle(color: mul, fontSize: 45.sp),
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
                                          changeWrong();
                                          div = primaryColor;
                                        });
                                      });
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 90.w,
                                    width: 90.w,
                                    child: Card(
                                      color: bgColor,
                                      elevation: 6,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          options![3],
                                          style: TextStyle(color: div, fontSize: 45.sp),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
        ],
      ),
    );
  }

  int nextIntRange(int min, int max) => min + Random().nextInt((max + 1) - min);

  AlphaQuestion getQuestion(int count) {
    String selectedAlpha;
    int skip_no;
    int alph_no;
    int ans_no;
    String? result;
    String? que;
    Random random = Random();
    const availableChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    alph_no = random.nextInt(20);

    selectedAlpha = availableChars[alph_no];
    if(count>6){
      skip_no = 3;
    }else{
      skip_no = 2;
    }

    ans_no = alph_no + skip_no + 1;
    if (ans_no >= availableChars.length) {
      do {
        skip_no = random.nextInt(4) + 1;
        ans_no = alph_no + skip_no + 1;
      } while (ans_no >= availableChars.length);
    }

    result = availableChars[ans_no];

    que = "Skip " + skip_no.toString();

    List<String>? options = [];

    int op1 = nextIntRange(ans_no! - 5, ans_no + 5);
    if (op1 == ans_no || op1 >= availableChars.length || op1.isNegative) {
      do {
        op1 = nextIntRange(ans_no - 5, ans_no + 5);
      } while (op1 == ans_no || op1.isNegative || op1 >= availableChars.length);
    }

    int op2 = nextIntRange(ans_no - 5, ans_no + 5);
    if (op2 == ans_no || op2 == op1 || op2 >= availableChars.length || op2.isNegative) {
      do {
        op2 = nextIntRange(ans_no - 5, ans_no + 5);
        if (op2 == op1) {
          op2 = ans_no;
        }
      } while (op2 == ans_no || op2.isNegative || op2 >= availableChars.length);
    }
    int op3 = nextIntRange(ans_no - 5, ans_no + 5);
    if (op3 == ans_no || op3 == op1 || op3 == op2 || op3 >= availableChars.length || op3.isNegative) {
      do {
        op3 = nextIntRange(ans_no - 5, ans_no + 5);
        if (op3 == op1) {
          op3 = ans_no;
        }
        if (op3 == op2) {
          op3 = ans_no;
        }
      } while (op3 == ans_no || op3.isNegative || op3 >= availableChars.length);
    }
    options!.add(availableChars[op1]);
    options!.add(availableChars[op2]);
    options!.add(availableChars[op3]);
    options!.add(result);
    options!.shuffle();
    AlphaQuestion Q = new AlphaQuestion(que: que, selectedAlpha: selectedAlpha, options: options, answer: result, isDone: false);
    print("$que $result $op1 $op2 $op3");
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
    temp.add(gameModelList[8].gameId);
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
              return TipsScreen(gameModel: gameModelList[8]);
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

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
import '../../common/ClsSound.dart';
import '../../common/Common.dart';
import '../../common/Key.dart';
import '../../constants.dart';
import '../ResultPage.dart';
import '../TimerTitle.dart';
import '../game_operations/LiveScorePoint.dart';

class TouchNumberGamePage extends StatefulWidget {
  GameModel gameModel;

  TouchNumberGamePage({required this.gameModel});

  @override
  State<TouchNumberGamePage> createState() => _TouchNumberGamePageState();
}

class _TouchNumberGamePageState extends State<TouchNumberGamePage> with TickerProviderStateMixin {
  var numbers = List.filled(9, 0);
  int level = 3;
  int randnum = 0;
  List<int> visibleNum = [];
  List<int> visible_ans = [];
  int sum = 0;

  bool _isvisible = false;
  bool _visible = false;

  bool isWrong = false;
  bool isDone = false;

  int correct = 0;
  int incorrect = 0;

  Random random = Random();

  @override
  void initState() {
    startGame();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    countDownTimer?.cancel();
    ClsSound.stopTikTik();
    _animationController.stop();
    super.dispose();
  }

  late AnimationController _animationController;
  int _current = 30;
  bool isAnimation = false;
  bool isStart = true;

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
    temp.add(gameModelList[17].gameId);
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
              return TipsScreen(gameModel: gameModelList[17]);
            }));
          },
        )));
  }

  Color color1 = primaryColor,
      color2 = primaryColor,
      color3 = primaryColor,
      color4 = primaryColor;

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
                        ScaleAnimatedText('3',duration: 500.ms),
                        ScaleAnimatedText('2',duration: 500.ms),
                        ScaleAnimatedText('1',duration: 500.ms),
                      ],
                    ),
                  ),
                ) : Stack(
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
                                )),
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
                                  )),
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
                                )),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 35.h,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [red75, red60, red45, red30, red15, Colors.transparent],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter
                                    )),),
                            )
                          ],
                        )
                      // ),
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
                                )
                            )
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(35, 0, 35, 0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                        ),
                        itemCount: numbers.length,
                        itemBuilder: (context, index) {
                          return numbers[index] == 0
                              ? Container()
                              : GestureDetector(
                            onTap: () {
                              hideItem(index);
                              setState(() {});
                              if (visibleNum.length == 0) {
                                setState(() {
                                  _isvisible = true;
                                });
                              }
                            },
                            child: isWrong ? Container(
                              decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text("${numbers[index]}",
                                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w400, color: Colors.white,),
                                ),
                              ),
                            ).animate(target: isDone ? 1 : 0).shake(hz: 10, curve: Curves.easeInOutCubic)
                                : Container(
                              decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text("${numbers[index]}",
                                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w400, color: Colors.white,),
                                ),
                              ),
                            ).animate(target: isDone ? 1 : 0).shake(hz: 10, curve: Curves.easeInOutCubic),
                          );
                        },
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: _visible,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text("${visible_ans[0]}",
                                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400, color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text("${visible_ans[1]}",
                                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400, color: Colors.white,),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text("${visible_ans[2]}",
                                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400, color: Colors.white,),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 50),
                          child: Visibility(
                            visible: _isvisible,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Bounce(
                                  duration: Duration(milliseconds: 150),
                                  onPressed: () {
                                    print("List index 1 = ${visible_ans}");
                                    if (sum == options![0]) {
                                      if (mounted) {
                                        setState(() {
                                          startGame();
                                          correct++;
                                          _isvisible = false;
                                          _visible = false;
                                          isDone = false;
                                          isWrong = false;
                                          color1 = Colors.green;
                                        });
                                      }
                                      Future.delayed(Duration(milliseconds: 150), () {
                                        if (mounted) {
                                          setState(() {
                                            color1 = primaryColor;
                                          });
                                        }
                                      });
                                    } else {
                                      if (mounted) {
                                        print('inCorrect op1');
                                        setState(() {
                                          incorrect++;
                                          Vibration.vibrate(duration: 300);
                                          _visible = true;
                                          color1 = Colors.red;
                                          changeWrong();
                                        });
                                      }
                                      Future.delayed(Duration(milliseconds: 150), () {
                                        if (mounted) {
                                          setState(() {
                                            color1 = primaryColor;
                                            changeWrong();
                                          });
                                        }
                                      });
                                    }
                                  },
                                  child: Container(
                                    child: SizedBox(
                                      height: 65,
                                      width: 275,
                                      child: Card(
                                        color: Colors.white,
                                        elevation: 6,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                        ),
                                        child: Center(
                                          child: Text(
                                            options![0].toString(),
                                            style: TextStyle(color: color1, fontSize: 30),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 3,),
                                Bounce(duration: Duration(milliseconds: 150),
                                  onPressed: () {
                                    print("List index 2 = ${visible_ans}");
                                    if (sum == options![1]) {
                                      if (mounted) {
                                        setState(() {
                                          startGame();
                                          correct++;
                                          _isvisible = false;
                                          _visible = false;
                                          isDone = false;
                                          isWrong = false;
                                          color2 = Colors.green;
                                        });
                                      }
                                      Future.delayed(Duration(milliseconds: 150), () {
                                        if (mounted) {
                                          setState(() {
                                            color2 = primaryColor;
                                          });
                                        }
                                      });
                                    } else {
                                      if (mounted) {
                                        print('inCorrect op2');
                                        setState(() {
                                          incorrect++;
                                          Vibration.vibrate(duration: 300);
                                          _visible = true;
                                          changeWrong();
                                          color2 = Colors.red;
                                        });
                                      }
                                      Future.delayed(Duration(milliseconds: 150), () {
                                        if (mounted) {
                                          setState(() {
                                            changeWrong();
                                            color2 = primaryColor;
                                          });
                                        }
                                      });
                                    }
                                  },
                                  child: Container(
                                    child: SizedBox(
                                      height: 65,
                                      width: 275,
                                      child: Card(
                                        color: Colors.white,
                                        elevation: 6,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                        ),
                                        child: Center(
                                          child: Text(
                                            options![1].toString(),
                                            style: TextStyle(color: color2, fontSize: 30),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 3,),
                                Bounce(
                                  duration: Duration(milliseconds: 150),
                                  onPressed: () {
                                    print("List index 3 = ${visible_ans}");
                                    if (sum == options![2]) {
                                      if (mounted) {
                                        setState(() {
                                          startGame();
                                          correct++;
                                          _isvisible = false;
                                          _visible = false;
                                          isDone = false;
                                          isWrong = false;
                                          color3 = Colors.green;
                                        });
                                      }
                                      Future.delayed(Duration(milliseconds: 150), () {
                                        if (mounted) {
                                          setState(() {
                                            color3 = primaryColor;
                                          });
                                        }
                                      });
                                    } else {
                                      if (mounted) {
                                        print('inCorrect op3');
                                        setState(() {
                                          incorrect++;
                                          Vibration.vibrate(duration: 300);
                                          _visible = true;
                                          changeWrong();
                                          color3 = Colors.red;
                                        });
                                      }
                                      Future.delayed(Duration(milliseconds: 150), () {
                                        if (mounted) {
                                          setState(() {
                                            changeWrong();
                                            color3 = primaryColor;
                                          });
                                        }
                                      });
                                    }
                                  },
                                  child: Container(
                                    child: SizedBox(
                                      height: 65,
                                      width: 275,
                                      child: Card(
                                        color: Colors.white,
                                        elevation: 6,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                        ),
                                        child: Center(
                                          child: Text(
                                            options![2].toString(),
                                            style: TextStyle(color: color3, fontSize: 30),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 3,),
                                Bounce(
                                  duration: Duration(milliseconds: 150),
                                  onPressed: () {
                                    print("List index 4 = ${visible_ans}");
                                    if (sum == options![3]) {
                                      if (mounted) {
                                        setState(() {
                                          startGame();
                                          correct++;
                                          _isvisible = false;
                                          _visible = false;
                                          isDone = false;
                                          isWrong = false;
                                          color4 = Colors.green;
                                        });
                                      }
                                      Future.delayed(Duration(milliseconds: 150), () {
                                        if (mounted) {
                                          setState(() {
                                            color4 = primaryColor;
                                          });
                                        }
                                      });
                                    } else {
                                      if (mounted) {
                                        print('inCorrect op4');
                                        setState(() {
                                          incorrect++;
                                          changeWrong();
                                          Vibration.vibrate(duration: 300);
                                          _visible = true;
                                          color4 = Colors.red;
                                        });
                                      }
                                      Future.delayed(Duration(milliseconds: 150), () {
                                        if (mounted) {
                                          setState(() {
                                            changeWrong();
                                            color4 = primaryColor;
                                          });
                                        }
                                      });
                                    }
                                  },
                                  child: Container(
                                    child: SizedBox(
                                      height: 65,
                                      width: 275,
                                      child: Card(
                                        color: Colors.white,
                                        elevation: 6,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                        ),
                                        child: Center(
                                          child: Text(
                                            options![3].toString(),
                                            style: TextStyle(color: color4, fontSize: 30),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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

  void startGame() {
    visibleNum = [];
    randnum = 0;
    sum = 0;
    options = [];
    numbers = List.filled(9, 0);
    for (int i = 0; i < level; i++) {
      do {
        randnum = random.nextInt(9) + 1;
      } while (numbers.contains(randnum));
      numbers[i] = randnum;
      print('${numbers[i]}');
    }

    visibleNum = numbers.getRange(0, 3).toList();
    visible_ans = numbers.getRange(0, 3).toList();
    numbers.shuffle();
    visibleNum.sort();
    visible_ans.sort();
    print('visibleNum = ${visibleNum}');
    print('visible_ans = ${visible_ans}');

    for (int i = 0; i < visibleNum.length; i++) {
      sum += visibleNum[i];
    }
    print('sum == $sum');

    getOption();

    setState(() {});
  }

  void hideItem(int index) {
    if (numbers[index] == visibleNum.first) {
      numbers[index] = 0;
      visibleNum.remove(visibleNum.first);
    } else {
      Vibration.vibrate(duration: 300);
      print('vibrate item');
      setState(() {
        changeWrong();
        isDone = !isDone;
      });

      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          changeWrong();
        });
      });
    }
  }

  int nextIntRange(int min, int max) => min + Random().nextInt((max + 1) - min);

  List<int> options = [];

  getOption() {
    options.add(sum);
    for (int i =0;i<3;i++){
      int op = 0;
      do {
        op = nextIntRange(sum - 5, sum + 5);
      } while (options.contains(op));
      options.add(op);
    }

    options.shuffle();
    print('options == $sum $options');
  }

  changeWrong() {
    isWrong = !isWrong;
  }
}

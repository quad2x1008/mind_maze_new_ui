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

class AdditionGamePage extends StatefulWidget {
  GameModel gameModel;

  AdditionGamePage({required this.gameModel});

  @override
  State<AdditionGamePage> createState() => _AdditionGamePageState();
}

List<int> startGame() {
  List<int> numList = [];
  for (int i = 0; i < 3; i++) {
    numList.add(Random().nextInt(18) + 1);
  }
  return numList;
}

class _AdditionGamePageState extends State<AdditionGamePage> with TickerProviderStateMixin {
  bool isAnimation = false, isStart = true, isWrong = false;
  List<int> numList = startGame();
  int ans = 0, correct = 0, incorrect = 0;
  int _current = 30;
  bool isDone = true;
  List<int> options = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  List<bool> optSelected = [true, true, true, true, true, true, true, true, true];
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationController.repeat(reverse: true);
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
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
                child: Icon(Icons.chevron_left, size: 30.r, color: primaryColor)),
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
                        Container(
                          alignment: Alignment.center,
                          transformAlignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              AnimatedOpacity(
                                opacity: isDone ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 80.w),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
                                      height: 50.w,
                                      width: 50.w,
                                      child: Center(
                                        child: Text(numList[0].toString(), textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 32.0, color: Colors.black)),
                                      ),
                                    ).animate(target: isDone ? 1 : 0 ).slide(duration: 200.ms, begin: Offset(1, 0), end: Offset.zero),
                                    SizedBox(width: 30.w),
                                    Text(numList[1].toString(), textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 35.0, color: white),
                                    ).animate(target: isDone ? 1 : 0).slide(delay: 50.ms, duration: 200.ms, begin: Offset(1, 0), end: Offset.zero),
                                    SizedBox(width: 30.w),
                                    Text(numList[2].toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: 35.0, color: white),
                                    ).animate(target: isDone ? 1 : 0).slide(delay: 100.ms, duration: 200.ms, begin: Offset(1, 0), end: Offset.zero),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Container(
                                  alignment: Alignment.center,
                                  transformAlignment: Alignment.center,
                                  margin: EdgeInsets.all(30.0),
                                  padding: EdgeInsets.all(12.0),
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: options.length,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 3.0, mainAxisSpacing: 3.0),
                                    reverse: true,
                                    itemBuilder: (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: () {
                                          ClsSound.playSound(SOUNDTYPE.Tap);
                                          ans = options[index] + ans;
                                          print('que = ${numList[0]}' + ' num = ${options[index]}' + ' ans = $ans');
                                          if (ans < numList[0]) {
                                            setState(() {
                                              optSelected[index] = false;
                                            });
                                            Future.delayed(Duration(seconds: 1), () {
                                              setState(() {
                                                optSelected[index] = true;
                                              });
                                            });
                                          } else if (ans == numList[0]) {
                                            setState(() {
                                              ans = 0;
                                              optSelected[index] = false;
                                              isDone = false;
                                              numList.removeAt(0);
                                              numList.add(Random().nextInt(18) + 1);
                                              correct++;
                                              ClsSound.playSound(SOUNDTYPE.Correct);
                                            });
                                            Future.delayed(Duration(milliseconds: 200), () {
                                              setState(() {
                                                isDone = true;
                                              });
                                            });
                                            Future.delayed(Duration(seconds: 1), () {
                                              setState(() {
                                                optSelected[index] = true;
                                              });
                                            });
                                          } else if (ans > numList[0]) {
                                            setState(() {
                                              optSelected[index] = false;
                                              isDone = false;
                                              numList.removeAt(0);
                                              numList.add(Random().nextInt(18) + 1);
                                              incorrect++;
                                              ans = 0;
                                              Vibration.vibrate(duration: 300);
                                              changeWrong();
                                            });
                                            Future.delayed(Duration(milliseconds: 200), () {
                                              setState(() {
                                                isDone = true;
                                                changeWrong();
                                              });
                                            });
                                            Future.delayed(Duration(seconds: 1), () {
                                              setState(() {
                                                optSelected[index] = true;
                                              });
                                            });
                                          }
                                        },
                                        child: AnimatedOpacity(
                                          opacity: optSelected[index] ? 1.0 : 0.0,
                                          duration: const Duration(milliseconds: 200),
                                          child: Card(
                                            color: bgColor,
                                            elevation: 6,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                            ),
                                            child: Center(
                                              child: Text(options[index].toString(), textAlign: TextAlign.center,
                                                style: TextStyle(color: primaryColor, fontSize: 34.sp),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                              ),
                              SizedBox(height: 20.h),
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
    temp.add(gameModelList[5].gameId);
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
              return TipsScreen(gameModel: gameModelList[5]);
            }));
          },
        )));
  }

  changeWrong() {
    isWrong = !isWrong;
  }
}

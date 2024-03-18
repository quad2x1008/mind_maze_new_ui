import 'dart:async';
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

class StopTheBallGameScreen extends StatefulWidget {
  GameModel gameModel;

  StopTheBallGameScreen({required this.gameModel});

  @override
  State<StopTheBallGameScreen> createState() => _StopTheBallGameScreenState();
}

class _StopTheBallGameScreenState extends State<StopTheBallGameScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool isAnimation = false, isStart = true, isWrong = true;
  Timer? timer;
  int correct = 0;
  int incorrect = 0;
  int _current = 30;
  int count = 0;

  GlobalKey ballKey = GlobalKey();
  List<GlobalKey> keyList = [];
  AnimationController? roundController;
  AnimationController? animationController;
  List<int> numberList = [5, 6, 7, 8, 9, 10, 9, 8, 7, 6, 5];
  int current = -1;
  int time = 3000, leftTry = 4, score = 0, target = 38;
  bool tapStatus = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        ClsSound.playSound(SOUNDTYPE.Tap);
        countDownTimer?.cancel();
        ClsSound.stopTikTik();
        roundController?.dispose();
        animationController?.dispose();
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
                  roundController?.dispose();
                  animationController?.dispose();
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
                          startTime();//
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
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 50.r,
                          height: 550.r,
                          child: ListView.builder(
                            itemCount: numberList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                key: keyList[index],
                                height: 50.r,
                                width: 50.r,
                                decoration: BoxDecoration(border: Border.all(color: current == index ? Colors.green : Colors.white, width: 2.r)),
                                child: Center(
                                  child: Text("${numberList[index]}",
                                    style: TextStyle(color: current == index ? Colors.green : txtColor, fontSize: 20.r, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          width: 50.r,
                          height: 500.r,
                          child: Center(
                            child: Container(
                              key: ballKey,
                              child: Image.asset("assets/Game/basketball.png", width: 25.r, height: 25.r)
                                  .animate(onPlay: (controller) =>
                                  controller.repeat(), controller: roundController, delay: 50.ms)
                                  .rotate(duration: 1000.ms, curve: Curves.easeInOut),
                            ),
                          ).animate(delay: 1000.ms, controller: animationController, onPlay: (controller) => controller.repeat())
                              .slideY(begin: -0.7.r, end: 0.235.r, duration: time.ms)
                              .slideY(begin: 0.235.r, end: -0.7.r, duration: time.ms, delay: time.ms),
                        ),
                        InkWell(
                          onTap: () {
                            ClsSound.playSound(SOUNDTYPE.Tap);
                            if (tapStatus) {
                              tapStatus = false;
                              current = -1;
                              roundController?.stop();
                              animationController?.stop();
                              int keyPress = -1;
                              RenderBox box = ballKey.currentContext?.findRenderObject() as RenderBox;
                              Offset pos = box.localToGlobal(Offset.zero);
                              pos = pos.translate(12.5.r, 12.5.r);
                              for (int i = 0; i < 11; i++) {
                                RenderBox box = keyList[i].currentContext?.findRenderObject() as RenderBox;
                                Offset position = box.localToGlobal(Offset.zero);
                                bool touchw = hitTest(pos, Rect.fromLTWH(position.dx, position.dy, box.size.width, box.size.height));
                                if (touchw) {
                                  keyPress = i;
                                  break;
                                }
                              }
                              if (keyPress == -1) {
                                return;
                              }
                              current = keyPress;
                              score = score + numberList[keyPress];
                              leftTry--;
                              Future.delayed(Duration(seconds: 1), () {
                                setState(() {});
                                time = time - 500;
                                roundController?.reset();
                                animationController?.reset();
                                if (score >= target) {
                                  print("Complete");
                                  roundController?.stop();
                                  animationController?.stop();
                                  setState(() {
                                    print("==> correct ${correct++}");
                                    ClsSound.playSound(SOUNDTYPE.Correct);
                                  });
                                  ResultInfo resultInfo = ResultInfo(no_of_que: correct + incorrect, correct: correct, incorrect: incorrect);
                                  goTo(resultInfo);
                                } else if (leftTry == 0 && score != target) {
                                  print("Game Over");
                                  roundController?.stop();
                                  animationController?.stop();
                                  isWrong = false;
                                  print("==> incorrect ${incorrect++}");
                                  Vibration.vibrate(duration: 300);
                                  Future.delayed(200.ms, () {
                                    isWrong = !isWrong;
                                    setState(() {});
                                  });
                                  ResultInfo resultInfo = ResultInfo(no_of_que: correct + incorrect, correct: correct, incorrect: incorrect);
                                  goTo(resultInfo);
                                } else {
                                  tapStatus = true;
                                }
                              });
                            }
                          },
                          child: Container(
                            width: 1.sw,
                            height: 550.r,
                            color: Colors.transparent,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            width: 0.35.sw,
                            alignment: Alignment.topCenter,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("LEFT TRY", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.r, color: txtColor)),
                                SizedBox(height: 10.r),
                                Container(
                                  height: 40.r,
                                  width: 80.r,
                                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/Game/find_btn.png"), fit: BoxFit.fill)),
                                  child: Center(
                                    child: Text("$leftTry",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.r, color: txtColor),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30.r),
                                Text("TARGET : $target", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.r, color: txtColor)),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            width: 0.35.sw,
                            alignment: Alignment.topRight,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("YOUR SCORE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.r, color: txtColor)),
                                SizedBox(height: 10.r),
                                Container(
                                  height: 40.r,
                                  width: 80.r,
                                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/Game/find_btn.png"), fit: BoxFit.fill)),
                                  child: Center(
                                    child: Text("$score", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.r, color: txtColor)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
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

  bool hitTest(Offset touchPoint, Rect position) {
    Path path = Path();
    path.addRect(position);
    path.close();
    return path.contains(touchPoint);
  }

  CountdownTimer? countDownTimer;

  @override
  void initState() {
    super.initState();
    target = (score >= target ?? 1) == 1 ? 38 : 46;
    leftTry = (score >= target ?? 1) == 1 ? 4 : 5;
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationController.repeat(reverse: true);
    roundController = AnimationController(vsync: this);
    animationController = AnimationController(vsync: this);
    for (int i = 0; i < 11; i++) {
      keyList.add(GlobalKey());
    }
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
    roundController?.dispose();
    animationController?.dispose();
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
    temp.add(gameModelList[24].gameId);
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
                return TipsScreen(gameModel: gameModelList[24]);
              }));
          },
        )));
  }
}

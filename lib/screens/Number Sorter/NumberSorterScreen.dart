import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mind_maze/screens/GameModel.dart';
import 'package:mind_maze/screens/TipsScreen.dart';
import 'package:quiver/async.dart';
import 'package:vibration/vibration.dart';
import '../../common/ClsSound.dart';
import '../../common/Common.dart';
import '../../common/Key.dart';
import '../../constants.dart';
import '../../main.dart';
import '../ResultPage.dart';
import '../TimerTitle.dart';
import '../game_operations/LiveScorePoint.dart';

class NumberSorterScreen extends StatefulWidget {
  GameModel gameModel;

  NumberSorterScreen({required this.gameModel});

  @override
  State<NumberSorterScreen> createState() => _NumberSorterScreenState();
}

class _NumberSorterScreenState extends State<NumberSorterScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool isAnimation = false, isStart = true, isWrong = true;
  Timer? timer;
  int correct = 0;
  int incorrect = 0;
  int _current = 30;
  int count = 0;

  List<int> initNumberList = [];
  List<int> tempNumberList = [];
  int i = 1, level = 1, crossAxisCount = 0, k = 0, hideElement = 0;
  List? t = [];
  bool clickStatus = false;

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
                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(10.r),
                        child: Center(
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: initNumberList.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10
                            ),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  ClsSound.playSound(SOUNDTYPE.Tap);
                                  if (clickStatus && initNumberList[index] != 0) {
                                    clickStatus = false;
                                    await checkAscendingNo(initNumberList[index]);
                                  }
                                },
                                child: initNumberList[index] != 0 ? Container(
                                  margin: EdgeInsets.all(2.r),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(6.r), color: colorList[index],
                                      image: DecorationImage(image: AssetImage("assets/Game/find_btn.png"), fit: BoxFit.fill)),
                                  child: Center(child: Text("${initNumberList[index]}", style: TextStyle(color: txtColor, fontSize: 30.r))),
                                ) : Container(),
                              );
                            },
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

  checkAscendingNo(int element) {
    if (element == getShortedNo()) {
      if ((t!.length - 1 == i)) {
        // initGame();
        ResultInfo resultInfo = ResultInfo(no_of_que: correct + incorrect, correct: correct, incorrect: incorrect);
        goTo(resultInfo);
      }
      initNumberList[initNumberList.indexOf(element)] = 0;
      i++;
      clickStatus = true;
      setState(() {
        print("==> correct ${correct++}");
        ClsSound.playSound(SOUNDTYPE.Correct);
      });
      setState(() {});
    } else {
      print("Game Over : ${element} == ${getShortedNo()}");
      colorList[initNumberList.indexOf(element)] = Colors.red;
      colorList[initNumberList.indexOf(getShortedNo())] = Colors.green;
      setState(() {});
      isWrong = false;
      print("==> incorrect ${incorrect++}");
      Vibration.vibrate(duration: 300);
      Future.delayed(200.ms, () {
        isWrong = !isWrong;
        setState(() {});
      });

      ResultInfo resultInfo = ResultInfo(no_of_que: correct + incorrect, correct: correct, incorrect: incorrect);
      goTo(resultInfo);
    }
  }

  List<Color> colorList = [];

  initGame() {
    checkLevel();
    clickStatus = true;
    for (int i = 1; i <= k; i++) {
      tempNumberList.add(i);
    }
    i = 0;
    initNumberList = [];
    initNumberList = tempNumberList;
    initNumberList.shuffle();
    initNumberList = initNumberList.sublist(0, initNumberList.length - hideElement);
    colorList = List.filled(initNumberList.length, litetxtColor);
    setState(() {});
  }

  checkLevel() {
    print("Level = ${session.read(KEY.KEY_Timer)}");
    k = 40;
    hideElement = 10;
    crossAxisCount = 5;
  }

  getShortedNo() {
    t = initNumberList.toList();
    t!.sort();
    return t![i];
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
    temp.add(gameModelList[22].gameId);
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
                return TipsScreen(gameModel: gameModelList[22]);
              }));
          },
        )));
  }
}
